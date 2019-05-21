//
//  BastCTParse.m
//  BookReadDemo
//
//  Created by ruantong on 2019/5/18.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "BaseCTParse.h"

@interface BaseCTParse()

@end

@implementation BaseCTParse

- (NSDictionary *)getDefaultTextAttributesDict{
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

- (NSAttributedString *)parseDictionary:(NSDictionary *)dict{
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self getDefaultTextAttributesDict]];
    
    //设置颜色
    UIColor *color = [self getTextColor:dict[@"color"]];
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
    
    attributes[(id)NSParagraphStyleAttributeName] = paragraphStyle; //段落属性
    
    NSString *content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

-(UIColor *)getTextColor:(NSString *)name{
    
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

- (void)operate{
    
}

@end
