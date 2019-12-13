//
//  CoreTextPageModel.h
//  DataStructureDemo
//
//  Created by ruantong on 2018/11/20.
//  Copyright © 2018 wupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "CTRunRefModel.h"
#import "CTLineRefModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CoreTextPageModel : NSObject
@property (nonatomic,assign) CTFrameRef frameRef;
@property (nonatomic,copy) NSAttributedString * content;

@property (nonatomic,strong) NSMutableArray * imageArray;
@property (nonatomic,strong) NSMutableArray<CTLineRefModel *> * lineArr;

+ (CoreTextPageModel *)createPageModel:(CTFrameRef)frameRef content:(NSAttributedString * )content;
@end

NS_ASSUME_NONNULL_END
