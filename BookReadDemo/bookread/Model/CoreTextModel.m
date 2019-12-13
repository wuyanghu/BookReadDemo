//
//  CoreTextData.m
//  CoreTextDemo
//
//  Created by 夏远全 on 16/12/25.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import "CoreTextModel.h"
#import "CoreTextImageModel.h"
#import "CTFrameConfigManager.h"

#import "CoreTextLinkModel.h"
#import "CoreTextPageModel.h"
#import "CoreTextConstant.h"
#import "CoreTextParseContext.h"

@interface CoreTextModel()
{

}
@end

@implementation CoreTextModel

- (instancetype)init{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)calculatePageArray:(NSString *)path{
    NSAttributedString *content = [self convertAttributedContent:path];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString([self stringRefFromString:content]);
    NSUInteger textPos = 0;
    NSUInteger totalPage = 0;
    
    @autoreleasepool {
        while (textPos < content.length)  {
            //设置路径
            CGPathRef pathRef = [self pathRefFromPath];
            
            //生成frame
            CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), pathRef, NULL);
            
            CoreTextPageModel * pageModel = [CoreTextPageModel createPageModel:frameRef content:content];
            [self.pageDataArray addObject:pageModel];
            //移动当前文本位置
            textPos += [self rangeFromFrameRef:frameRef].length;
            
            CGPathRelease(pathRef);
            totalPage++;
            
            
        };
    };
    
    [self calculateImagePosition];
    CFRelease(framesetter);
    
}

- (void)calculateImagePosition{

    if (self.imageArray.count==0) {
        return;
    }
    
    CoreTextImageModel * imageData = self.imageArray[0];
    NSUInteger imgIndex = 0;
    
    for (CoreTextPageModel * pageModel in self.pageDataArray) {
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
                CTRunDelegateRef delegate = [self runDelegateRefFromRunObj:runObj];
                NSDictionary *metaDic = CTRunDelegateGetRefCon(delegate);

                if (!delegate || ![metaDic isKindOfClass:[NSDictionary class]]) {
                    continue;
                }
                [pageModel.imageArray addObject:imageData];

                CGRect colRect = CGPathGetBoundingBox(CTFrameGetPath(frameRef));
                imageData.imagePostion = CGRectOffset([self getRunBounds:lineOrigins[i] line:line runObj:runObj], colRect.origin.x, colRect.origin.y);
                
                imgIndex ++;
                if (imgIndex == self.imageArray.count) {
                    imageData = nil;
                    break;
                }else{
                    imageData = self.imageArray[imgIndex];
                }
            }
        }
    }
    
}


#pragma mark - private method

- (CGRect)getRunBounds:(CGPoint)orgin line:(CTLineRef)line runObj:(id)runObj {
    CGRect runBounds;
    CGFloat ascent;
    CGFloat descent;
    runBounds.size.width = CTRunGetTypographicBounds([self runRefFromRunObj:runObj], CFRangeMake(0, 0), &ascent, &descent, NULL);
    runBounds.size.height = ascent + descent;
    
    CGFloat x0ffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange([self runRefFromRunObj:runObj]).location, NULL);
    runBounds.origin.x = orgin.x + x0ffset;
    runBounds.origin.y = orgin.y;
    runBounds.origin.y -= descent;
    runBounds.origin.x = (screenRect.size.width-runBounds.size.width)/2;
    return runBounds;
}

- (CTRunDelegateRef)runDelegateRefFromRunObj:(id)runObj{
    NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes([self runRefFromRunObj:runObj]);
    return (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];//判断是否有占位
}

- (CFRange)rangeFromFrameRef:(CTFrameRef)frameRef{
    return CTFrameGetVisibleStringRange(frameRef);
}

- (CGPathRef)pathRefFromPath{
    CTFrameConfigManager * configManager = [CTFrameConfigManager shareInstance];
    return CGPathCreateWithRect(configManager.getDrawCTFrame, NULL);
}

- (CTRunRef)runRefFromRunObj:(id)runObj{
    return (__bridge CTRunRef)runObj;
}
//NSAttributedString转CFAttributedStringRef
- (CFAttributedStringRef)stringRefFromString:(NSAttributedString *)content{
    return (__bridge CFAttributedStringRef)content;
}

#pragma mark - 解析

//字符string转换attributedString
- (NSAttributedString *)convertAttributedContent:(NSString *)path{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if (data) {
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                NSString *type = dict[@"type"];
                CFRange contentRange = CFRangeMake(result.length, [dict[@"content"] length]);
                NSAttributedString * as;
                if ([type isEqualToString:@"txt"]) {
                    CoreTextParseContext * parseContext = [[CoreTextParseContext alloc] initWithParse:[BaseCoreTextParse new]];
                    [result appendAttributedString:[parseContext praseDict:dict]];
                    
                }else if ([type isEqualToString:@"img"]){
                    CoreTextImageModel * imageModel = [CoreTextImageModel createImageModel:dict[@"name"] position:contentRange.location];
                    [self.imageArray addObject:imageModel];
                    //创建空白占位符，并且设置它的CTRunDelegate信息
                    CoreTextParseContext * parseContext = [[CoreTextParseContext alloc] initWithParse:[CoreTextParseImage new]];
                    [result appendAttributedString:[parseContext praseDict:dict]];
                }else if ([type isEqualToString:@"link"]){
                    CoreTextLinkModel *linkData = [CoreTextLinkModel createLinkModel:dict[@"content"] url:dict[@"url"] range:contentRange];
                    [self.linkArray addObject:linkData];
                    
                    CoreTextParseContext * parseContext = [[CoreTextParseContext alloc] initWithParse:[BaseCoreTextParse new]];
                    [result appendAttributedString:[parseContext praseDict:dict]];
                    
                }else if ([type isEqualToString:@"sub"] || [type isEqualToString:@"sup"]){
                    CoreTextParseUpDownBdge * bdgeParse = [CoreTextParseUpDownBdge new];
                    CoreTextParseContext * parseContext = [[CoreTextParseContext alloc] initWithParse:bdgeParse];
                    [result appendAttributedString:[parseContext praseDict:dict]];
                    
                    [bdgeParse insertBadgeAttributedElement:dict result:result contentRange:contentRange];
                }else if ([type isEqualToString:@"line"]){
                    as = [[NSAttributedString alloc] initWithString:@"\n"];
                    [result appendAttributedString:as];
                }
            }
        }
    }
    return  result;
}

#pragma mark - getter

- (NSMutableArray<CoreTextImageModel *> *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray new];
    }
    return _imageArray;
}

- (NSMutableArray<CoreTextLinkModel *> *)linkArray{
    if (!_linkArray) {
        _linkArray = [NSMutableArray new];
    }
    return _linkArray;
}

- (NSMutableArray<CoreTextPageModel *> *)pageDataArray{
    if (!_pageDataArray) {
        _pageDataArray = [NSMutableArray new];
    }
    return _pageDataArray;
}

@end
