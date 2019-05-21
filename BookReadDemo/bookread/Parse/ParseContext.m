//
//  ParseContext.m
//  BookReadDemo
//
//  Created by ruantong on 2019/5/21.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "ParseContext.h"

@interface ParseContext()
{
    BaseCTParse * _baseParse;
}
@end

@implementation ParseContext

- (instancetype)initWithParse:(BaseCTParse *)parse{
    self = [super init];
    if (self) {
        _baseParse = parse;
    }
    return self;
}

- (NSAttributedString *)operate:(NSDictionary *)dict{
    return [_baseParse parseDictionary:dict];
}

@end
