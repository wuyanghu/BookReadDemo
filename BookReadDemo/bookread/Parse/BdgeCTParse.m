//
//  BdgeCTParse.m
//  BookReadDemo
//
//  Created by ruantong on 2019/5/18.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "BdgeCTParse.h"
#import "CoreTextConstant.h"
#import "CoreTextMacor.h"

@implementation BdgeCTParse

//添加角标属性
- (void)insertBadgeAttributedElement:(NSDictionary*)dict result:(NSMutableAttributedString *)result contentRange:(CFRange)contentRange
{
    CFMutableAttributedStringRef _contentAttributed = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);//纯文字的文字属性
    [(__bridge NSMutableAttributedString *)_contentAttributed appendAttributedString:[[NSAttributedString alloc] initWithAttributedString:result]];
    
    UIColor *fontColor = [UIColor blackColor];//字体颜色
    
    CTFrameConfigManager * config = [CTFrameConfigManager shareInstance];
    CGFloat fontSize = config.fontSize;//字体大小
    
    NSString * fontFamily = [UIFont systemFontOfSize:fontSize].familyName;//字体集
    
    NSMutableAttributedString *attr = result;
    
    UIColor *badgeColor = fontColor;
    UIFont *badgeFont = [UIFont fontWithName:fontFamily size:fontSize * 2 / 3];
    UIFont *textFont = [UIFont fontWithName:fontFamily size:fontSize];
    CGFloat baselineOffset;//基线向下向上偏移量
    if ([dict[@"type"] isEqualToString:@"sub"]) {
        baselineOffset = textFont.descender;
    }else{
        baselineOffset = textFont.ascender - (fabs(badgeFont.descender) + badgeFont.ascender) / 2;// + fabs(badgeFont.descender);
    }
    NSRange badgeRange = NSMakeRange(contentRange.location, contentRange.length);
    [attr addAttribute:NSBaselineOffsetAttributeName value:@(baselineOffset) range:badgeRange];
    [attr addAttribute:NSFontAttributeName value:badgeFont range:badgeRange];
    [attr addAttribute:NSForegroundColorAttributeName value:badgeColor range:badgeRange];
    
    CGFloat lineSpacing = config.lineSpace;
    CTParagraphStyleSetting paragraphStyleSetting[] = {
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(lineSpacing), &lineSpacing}};
    
    CTParagraphStyleRef paragraphStyleRef = CTParagraphStyleCreate(paragraphStyleSetting, sizeof(paragraphStyleSetting) / sizeof(paragraphStyleSetting[0]));
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:(__bridge id)paragraphStyleRef, NSParagraphStyleAttributeName, nil];
    if (paragraphStyleRef != NULL) CFRelease(paragraphStyleRef);
    CFDictionaryRef dictionary = (__bridge CFDictionaryRef)attrs;
    CFAttributedStringSetAttributes(_contentAttributed, contentRange, dictionary, NO);
    /*ios 10.0以下系统上下角标失效，增加CMTextBadgeTypeAttribute属性*/
    if(SYSTEM_VERSION_LESS_THAN(@"10.0")){
        CFAttributedStringSetAttribute(_contentAttributed,contentRange,(__bridge CFStringRef)CMTextBadgeTypeAttribute,(__bridge CFTypeRef)@([self badgeType:dict]));
    }
    
}

- (CMBadgeTextType)badgeType:(NSDictionary *)dict
{
    if ([dict[@"type"] isEqualToString:@"sup"]) return CMBadgeTextTypeSup;
    if ([dict[@"type"] isEqualToString:@"sub"]) return CMBadgeTextTypeSub;
    return CMBadgeTextTypeNone;
}

@end
