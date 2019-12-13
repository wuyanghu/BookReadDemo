//
//  CoreTextImageData.m
//  CoreTextDemo
//
//  Created by 夏远全 on 16/12/26.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import "CoreTextImageModel.h"

@implementation CoreTextImageModel

+ (CoreTextImageModel *)createImageModel:(NSString *)name position:(NSInteger)position{
    CoreTextImageModel *imageData = [[CoreTextImageModel alloc] init];
    imageData.name = name;
    imageData.position = position;
    return imageData;
}


@end
