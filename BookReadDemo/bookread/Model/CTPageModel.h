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

@interface CTPageModel : NSObject
@property (nonatomic,assign) CTFrameRef frameRef;
@property (nonatomic,copy) NSAttributedString * content;

@property (nonatomic,strong) NSMutableArray * imageArray;
@property (nonatomic,strong) NSMutableArray<CTLineModel *> * lineArr;

+ (CTPageModel *)createPageModel:(CTFrameRef)frameRef content:(NSAttributedString * )content;
@end

NS_ASSUME_NONNULL_END
