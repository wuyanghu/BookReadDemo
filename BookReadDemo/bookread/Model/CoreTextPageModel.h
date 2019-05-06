//
//  CoreTextPageModel.h
//  DataStructureDemo
//
//  Created by ruantong on 2018/11/20.
//  Copyright © 2018 wupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "CTRunModel.h"
#import "CTLineModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CoreTextPageModel : NSObject
@property (nonatomic,assign) CTFrameRef frameRef;
@property (nonatomic,assign) CFRange frameRefRange;
@property (nonatomic,assign) CGRect path;
@property (nonatomic,copy) NSAttributedString * content;

@property (nonatomic,strong) NSMutableArray * imageArray;
@property (nonatomic,strong) NSMutableArray<CTLineModel *> * lineArr;

+ (CoreTextPageModel *)createPageModel:(CTFrameRef)frameRef frameRefRange:(CFRange)frameRefRange path:(CGRect)path content:(NSAttributedString * )content;
@end

NS_ASSUME_NONNULL_END
