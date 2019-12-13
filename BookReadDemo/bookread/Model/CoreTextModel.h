//
//  CoreTextData.h
//  CoreTextDemo
//
//  Created by 夏远全 on 16/12/25.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextMacor.h"
#import "CoreTextPageModel.h"

@class CoreTextImageModel;
@class CoreTextLinkModel;

@interface CoreTextModel : NSObject
@property (nonatomic,strong) NSMutableArray<CoreTextPageModel *> * pageDataArray;//提前计算好的分页数据

@property (strong,nonatomic) NSMutableArray<CoreTextImageModel *> *imageArray;//图片
@property (strong,nonatomic) NSMutableArray<CoreTextLinkModel *> * linkArray;//链接

- (void)calculatePageArray:(NSString *)path;
@end
