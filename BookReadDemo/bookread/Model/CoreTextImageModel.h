//
//  CoreTextImageData.h
//  CoreTextDemo
//
//  Created by 夏远全 on 16/12/26.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CoreTextImageModel : NSObject

//图片资源名称
@property (copy,nonatomic)NSString *name;
//图片位置的起始点
@property (assign,nonatomic)NSInteger position;
//图片的尺寸
@property (assign,nonatomic)CGRect imagePostion;

+ (CoreTextImageModel *)createImageModel:(NSString *)name position:(NSInteger)position;

@end
