//
//  CTDispalyView.h
//  CoreTextDemo
//
//  Created by 夏远全 on 16/12/25.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTPageModel.h"
#import "CTModel.h"

@interface CTDispalyView : UIView
@property(strong,nonatomic) CTPageModel * pageModel;
@property (nonatomic,strong) CTModel * coreTextModel;
@end
