//
//  ParseContext.m
//  BookReadDemo
//
//  Created by ruantong on 2019/5/21.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "CoreTextParseContext.h"

@interface CoreTextParseContext()
{
    BaseCoreTextParse * _baseParse;
}
@end

@implementation CoreTextParseContext

- (instancetype)initWithParse:(BaseCoreTextParse *)parse{
    self = [super init];
    if (self) {
        _baseParse = parse;
    }
    return self;
}

- (NSAttributedString *)praseDict:(NSDictionary *)dict{
    return [_baseParse attributedStringFromConfigDict:dict];
}

@end
