//
//  BastCTParse.h
//  BookReadDemo
//
//  Created by ruantong on 2019/5/18.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextParseInterface.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "CTFrameConfigManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseCoreTextParse : NSObject<CoreTextParseInterface>
- (NSDictionary *)getDefaultTextAttributesDict;
@end



NS_ASSUME_NONNULL_END