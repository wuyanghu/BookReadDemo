//
//  ImageViewController.m
//  DataStructureDemo
//
//  Created by ruantong on 2018/8/1.
//  Copyright © 2018年 wupeng. All rights reserved.
//

#import "PageDetailViewController.h"
#import "CTDispalyView.h"
#import "ParseCoreTextPage.h"

@interface PageDetailViewController ()
@property (nonatomic,strong) CTDispalyView * dispaleView;
@end

@implementation PageDetailViewController

-(id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view addSubview:self.dispaleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshViewWithIndex:(NSInteger)index coreTextModel:(ParseCoreTextPage *)coreTextModel{
    //创建绘制数据实例
    self.dispaleView.pageModel = coreTextModel.pageDataArray[index];
    self.dispaleView.coreTextModel = coreTextModel;
    [self.dispaleView setNeedsDisplay];
}

#pragma mark - getter、setter

- (CTDispalyView *)dispaleView{
    if (!_dispaleView) {
        CGRect frame = self.view.frame;
        frame.origin.y +=64;
        
        //创建画布
        _dispaleView = [[CTDispalyView alloc] initWithFrame:frame];
        _dispaleView.backgroundColor = [UIColor whiteColor];
        
    }
    return _dispaleView;
}

@end
