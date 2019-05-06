//
//  CoreTextUtils.h
//  CoreTextDemo
//
//  Created by 夏远全 on 16/12/26.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextLinkModel.h"
#import "CoreTextModel.h"
#import <UIKit/UIKit.h>

@interface CoreTextUtils : NSObject

/**
 *  检测点击位置是否在链接上
 *
 *  @param view  点击区域
 *  @param point 点击坐标
 *  @param data  数据源
 */
+(CoreTextLinkModel *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextPageModel *)pageModel coreTextModel:(CoreTextModel *)coreTextModel;

@end
