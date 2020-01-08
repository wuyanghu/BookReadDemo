//
//  CTDispalyView.h
//  CoreTextDemo
//
//  Created by 夏远全 on 16/12/25.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextPageModel.h"
#import "ParseCoreTextPage.h"

@interface CTDispalyView : UIView
@property(strong,nonatomic) CoreTextPageModel * pageModel;
@property (nonatomic,strong) ParseCoreTextPage * coreTextModel;
@end
