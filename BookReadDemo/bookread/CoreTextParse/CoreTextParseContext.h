//
//  ParseContext.h
//  BookReadDemo
//
//  Created by ruantong on 2019/5/21.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCoreTextParse.h"
#import "CoreTextParseImage.h"
#import "CoreTextParseUpDownBdge.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreTextParseContext : NSObject
- (instancetype)initWithParse:(BaseCoreTextParse *)parse;
- (NSAttributedString * )praseDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
