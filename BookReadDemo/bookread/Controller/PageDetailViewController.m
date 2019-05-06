//
//  ImageViewController.m
//  DataStructureDemo
//
//  Created by ruantong on 2018/8/1.
//  Copyright © 2018年 wupeng. All rights reserved.
//

#import "PageDetailViewController.h"
#import "CTDispalyView.h"
#import "CoreTextModel.h"

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

- (void)refreshView:(CoreTextPageModel *)pageData coreTextModel:(CoreTextModel *)coreTextModel{
    //创建绘制数据实例
    self.dispaleView.pageModel = pageData;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
