//
//  ParseContext.h
//  BookReadDemo
//
//  Created by ruantong on 2019/5/21.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCTParse.h"
#import "TextCTParse.h"
#import "ImageCTParse.h"
#import "BdgeCTParse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParseContext : NSObject
- (instancetype)initWithParse:(BaseCTParse *)parse;
- (NSAttributedString * )operate:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
