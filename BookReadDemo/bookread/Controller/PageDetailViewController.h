//
//  ImageViewController.h
//  DataStructureDemo
//
//  Created by ruantong on 2018/8/1.
//  Copyright © 2018年 wupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTPageModel.h"
#import "CTModel.h"

@interface PageDetailViewController : UIViewController
- (void)refreshViewWithIndex:(NSInteger)index coreTextModel:(CTModel *)coreTextModel;
@end
