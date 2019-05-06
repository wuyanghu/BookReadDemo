//
//  ImageViewController.h
//  DataStructureDemo
//
//  Created by ruantong on 2018/8/1.
//  Copyright © 2018年 wupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextPageModel.h"
#import "CoreTextModel.h"

@interface PageDetailViewController : UIViewController
- (void)refreshView:(CoreTextPageModel *)pageData coreTextModel:(CoreTextModel *)coreTextModel;
@end
