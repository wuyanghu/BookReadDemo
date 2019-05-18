//
//  CTFrameParser.m
//  CoreTextDemo
//
//  Created by 夏远全 on 16/12/25.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import "CTFrameParser.h"
#import "CTModel.h"
#import "CoreTextConstant.h"

@interface CTFrameParser()
{
    CTModel * _coreTextModel;
}
@end

@implementation CTFrameParser

- (instancetype)init{
    self = [super init];
    if (self) {
        _coreTextModel = [CTModel new];
    }
    return self;
}

#pragma mark - 解析方法

- (void)parseBookReadFile:(NSString *)path{
    [_coreTextModel calculatePageArray:path];
}

- (CTModel *)getCTModel{
    return _coreTextModel;
}

@end
