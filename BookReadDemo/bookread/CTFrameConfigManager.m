//
//  CTFrameParserConfig.m
//  CoreTextDemo
//
//  Created by 夏远全 on 16/12/25.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import "CTFrameConfigManager.h"
#import "CoreTextMacor.h"

@implementation CTFrameConfigManager

+ (instancetype)shareInstance
{
    static CTFrameConfigManager *moduleManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        moduleManager = [[self alloc] init];
    });
    return moduleManager;
}

//初始化
-(instancetype)init{
    self = [super init];
    if (self) {
        _width = screenRect.size.width;
        _height = screenRect.size.height-64-20;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = RGB(108, 108, 108);
    }
    return self;
}
//绘制的区域
- (CGRect)getDrawCTFrame{
    return CGRectMake(20, 0, self.width-40, self.height);
}

@end
