//
//  CoreTextPageModel.h
//  DataStructureDemo
//
//  Created by ruantong on 2018/11/20.
//  Copyright © 2018 wupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
NS_ASSUME_NONNULL_BEGIN

@interface CoreTextPageModel : NSObject
@property (nonatomic,assign) CTFrameRef frameRef;
@property (nonatomic,strong) NSMutableArray * imageArray;
@end

NS_ASSUME_NONNULL_END
