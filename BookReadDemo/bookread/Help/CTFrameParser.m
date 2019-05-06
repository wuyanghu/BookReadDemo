//
//  CTFrameParser.m
//  CoreTextDemo
//
//  Created by 夏远全 on 16/12/25.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import "CTFrameParser.h"
#import "CTFrameConfigManager.h"
#import "CoreTextModel.h"
#import "CoreImageModel.h"
#import "CoreTextLinkModel.h"
#import "CoreTextPageModel.h"

@implementation CTFrameParser

#pragma mark - 新增的方法

//用于提供对外的接口，调用方法二实现从一个JSON的模板文件中读取内容，然后调用方法五生成的CoreTextData
+(CoreTextModel *)parseTemplateFile:(NSString *)path{
    
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *linkArray  = [NSMutableArray array];
    NSAttributedString *content = [self convertAttributedContent:path imageArray:imageArray linkArray:linkArray];
    
    CoreTextModel *data = [[CoreTextModel alloc] init];
    data.pageDataArray = [self pageCoreText:content imageArray:imageArray];
    data.imageArray = imageArray;
    data.linkArray = linkArray;
    
    return data;
}

//分页
+ (NSArray *)pageCoreText:(NSAttributedString *)content imageArray:(NSArray *)imageArray{
    
    NSMutableArray<CoreTextPageModel *> * pageArray = [[NSMutableArray alloc] init];
    CFAttributedStringRef cfAttStr = (__bridge CFAttributedStringRef)content;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(cfAttStr);
    NSUInteger textPos = 0;
    NSUInteger totalPage = 0;
    NSUInteger strLength = [content length];
    
    CTFrameConfigManager * configManager = [CTFrameConfigManager shareInstance];
    @autoreleasepool {
        while (textPos < strLength)  {
            //设置路径
            CGPathRef path = CGPathCreateWithRect(CGRectMake(20, 0, configManager.width-40, configManager.height), NULL);
            //生成frame
            CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
            //获取范围并转换为NSRange
            CFRange frameRefRange = CTFrameGetVisibleStringRange(frameRef);
            
            CoreTextPageModel * pageModel = [CoreTextPageModel new];
            pageModel.frameRef = frameRef;
            
            [pageArray addObject:pageModel];
            //移动当前文本位置
            textPos += frameRefRange.length;
            
//            CFRelease(frameRef);
            CGPathRelease(path);
            totalPage++;
            //释放路径和frame，页数加1
            
        };
    };
    
    [self fillImagePosition:imageArray pageDataArray:pageArray];
    CFRelease(framesetter);
    return pageArray;
}

//填充图片占位
+(void)fillImagePosition:(NSArray *)imageArray pageDataArray:(NSArray *)pageDataArray{
    if (imageArray.count==0) {
        return;
    }
    
    CoreImageModel *imageData = imageArray[0];
    NSUInteger imgIndex = 0;
    
    for (CoreTextPageModel * pageModel in pageDataArray) {
        CTFrameRef frameRef = pageModel.frameRef;
        
        NSArray *lines = (NSArray *)CTFrameGetLines(frameRef);
        NSInteger lineCount = [lines count];
        CGPoint lineOrigins[lineCount];
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), lineOrigins);
        
        for (int i=0; i<lineCount; i++) {
            if (imageData==nil) {
                break;
            }
            CTLineRef line = (__bridge CTLineRef)lines[i];
            NSArray *runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
            for (id runObj in runObjArray) {
                CTRunRef run = (__bridge CTRunRef)runObj;
                NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
                CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];//判断是否有占位
                if (delegate == nil) {
                    continue;
                }else{
                    [pageModel.imageArray addObject:imageData];
                }
                
                NSDictionary *metaDic = CTRunDelegateGetRefCon(delegate);
                if (![metaDic isKindOfClass:[NSDictionary class]]) {
                    continue;
                }
                
                CGRect runBounds;
                CGFloat ascent;
                CGFloat descent;
                runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
                runBounds.size.height = ascent + descent;
                
                CGFloat x0ffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                runBounds.origin.x = lineOrigins[i].x + x0ffset;
                runBounds.origin.y = lineOrigins[i].y;
                runBounds.origin.y -= descent;
                runBounds.origin.x = (screenRect.size.width-runBounds.size.width)/2;
                
                CGPathRef pathRef = CTFrameGetPath(frameRef);
                CGRect colRect = CGPathGetBoundingBox(pathRef);
                CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
                
                imageData.imagePostion = delegateBounds;
                imgIndex ++;
                if (imgIndex == imageArray.count) {
                    imageData = nil;
                    break;
                }else{
                    imageData = imageArray[imgIndex];
                }
            }
        }
    }
    
}

#pragma mark - 添加设置CTRunDelegate信息的方法

static CGFloat ascentCallback(void *ref){
    
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"height"] floatValue];
}
static CGFloat descentCallback(void *ref){
    
    return 0;
}
static CGFloat widthCallback(void *ref){
    
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"width"] floatValue];
}

+(NSAttributedString *)parseImageDataFromNSDictionary:(NSDictionary *)dict{
    
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)dict);
    
    //使用0xFFFC作为空白占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary *attributes = [self attributesWithConfig];
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}


#pragma mark - 解析

//字符string转换attributedString
+(NSAttributedString *)convertAttributedContent:(NSString *)path imageArray:(NSMutableArray *)imageArray linkArray:(NSMutableArray *)linkArray{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if (data) {
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                
                NSString *type = dict[@"type"];
                
                if ([type isEqualToString:@"txt"]) {
                    
                    NSAttributedString *as = [self parseAttributeContentFromNSDictionary:dict];
                    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                    [result appendAttributedString:as];
                    
                }else if ([type isEqualToString:@"img"]){
                    
                    //创建CoreTextImageData,保存图片到imageArray数组中
                    CoreImageModel *imageData = [[CoreImageModel alloc] init];
                    imageData.name = dict[@"name"];
                    imageData.position = [result length];
                    [imageArray addObject:imageData];
                    
                    //创建空白占位符，并且设置它的CTRunDelegate信息
                    NSAttributedString *as = [self parseImageDataFromNSDictionary:dict];
                    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                    [result appendAttributedString:as];
                }
                else if ([type isEqualToString:@"link"]){
                    
                    NSUInteger startPos = result.length;
                    NSAttributedString *as = [self parseAttributeContentFromNSDictionary:dict];
                    [result appendAttributedString:as];
                    
                    //创建CoreTextLinkData
                    NSUInteger length = result.length - startPos;
                    NSRange linkRange = NSMakeRange(startPos, length);
                    CoreTextLinkModel *linkData = [[CoreTextLinkModel alloc] init];
                    linkData.title = dict[@"content"];
                    linkData.url   = dict[@"url"];
                    linkData.range = linkRange;
                    [linkArray addObject:linkData];
                }
            }
        }
    }
    return  result;
}

//配置信息格式化
+(NSDictionary *)attributesWithConfig{
    CTFrameConfigManager * config = [CTFrameConfigManager shareInstance];
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpcing = config.lineSpace;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment,sizeof(CGFloat),&lineSpcing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(CGFloat),&lineSpcing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(CGFloat),&lineSpcing},
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    UIColor *textColor = config.textColor;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(fontRef);
    CFRelease(theParagraphRef);
    return dict;
}

//方法三：将NSDcitionay内容转换为NSAttributedString
+(NSAttributedString *)parseAttributeContentFromNSDictionary:(NSDictionary*)dict{
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesWithConfig]];
    
    //设置颜色
    UIColor *color = [self colorFromTemplate:dict[@"color"]];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    
    //设置字号
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (fontSize>0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //缩进
    paragraphStyle.firstLineHeadIndent = 30;//首行缩进
    paragraphStyle.lineSpacing = 5;//行间距
    
    attributes[(id)NSParagraphStyleAttributeName] = paragraphStyle;
    
    NSString *content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

//提供将NSString转换为UIColor的功能
+(UIColor *)colorFromTemplate:(NSString *)name{
    
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    }else if ([name isEqualToString:@"red"]){
        return [UIColor redColor];
    }else if ([name isEqualToString:@"black"]){
        return [UIColor blackColor];
    }else{
        return nil;
    }
}

@end
