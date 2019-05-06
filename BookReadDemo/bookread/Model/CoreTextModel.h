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

@interface CoreTextModel : NSObject
//新增加的成员
@property (strong,nonatomic)NSArray *imageArray;
@property (strong,nonatomic)NSArray *linkArray;
@property (nonatomic,strong) NSArray<CoreTextPageModel *> * pageDataArray;
@end
