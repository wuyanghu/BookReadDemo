//
//  CTFrameParserConfig.h
//  CoreTextDemo
//
//  Created by 夏远全 on 16/12/25.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CTFrameConfigManager : NSObject

//配置属性
@property (nonatomic ,assign)CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic, assign)CGFloat fontSize;
@property (nonatomic, assign)CGFloat lineSpace;
@property (nonatomic, strong)UIColor *textColor;

@property (nonatomic,assign) NSInteger indexPage;//阅读下标
+ (instancetype)shareInstance;
@end
