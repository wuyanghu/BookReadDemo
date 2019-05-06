//
//  CoreTextPageModel.m
//  DataStructureDemo
//
//  Created by ruantong on 2018/11/20.
//  Copyright © 2018 wupeng. All rights reserved.
//

#import "CoreTextPageModel.h"

@implementation CoreTextPageModel

- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

@end
