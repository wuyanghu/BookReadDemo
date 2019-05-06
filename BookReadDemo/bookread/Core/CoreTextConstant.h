//
//  CoreTextConstant.h
//  BookReadDemo
//
//  Created by ruantong on 2019/5/5.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CMTextBadgeTypeAttribute;//上下角标类型

/**
 角标类型
 
 - CMBadgeTextTypeNone: 不是角标
 - CMBadgeTextTypeSup: 上角标
 - CMBadgeTextTypeSub: 下角标
 */
typedef NS_ENUM(NSInteger, CMBadgeTextType) {
    CMBadgeTextTypeNone = 0,
    CMBadgeTextTypeSup,
    CMBadgeTextTypeSub,
};
