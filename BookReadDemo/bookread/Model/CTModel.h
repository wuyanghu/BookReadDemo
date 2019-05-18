//
//  CoreTextData.h
//  CoreTextDemo
//
//  Created by 夏远全 on 16/12/25.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextMacor.h"
#import "CTPageModel.h"

@class CTImageModel;
@class CTLinkModel;

@interface CTModel : NSObject

@property (strong,nonatomic) NSMutableArray<CTImageModel *> *imageArray;
@property (strong,nonatomic) NSMutableArray<CTLinkModel *> * linkArray;
@property (nonatomic,strong) NSMutableArray<CTPageModel *> * pageDataArray;

- (void)calculatePageArray:(NSString *)path;
@end
