//
//  CTFrameParser.h
//  CoreTextDemo
//
//  Created by 夏远全 on 16/12/25.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextModel.h"

@class CTFrameConfigManager;
@interface CTFrameParser : NSObject

/**
 *  配置信息格式化
 *
 */
+(NSDictionary *)attributesWithConfig;

/**
 *  给内容设置配置信息
 *
 *  @param path   模板文件路径
 */
+(CoreTextModel *)parseTemplateFile:(NSString *)path;

@end
