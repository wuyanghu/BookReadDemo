//
//  TextCTParse.m
//  BookReadDemo
//
//  Created by ruantong on 2019/5/18.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "TextCTParse.h"

@implementation TextCTParse

-(NSAttributedString *)parseAttributeContentFromNSDictionary:(NSDictionary*)dict{
    
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

@end
