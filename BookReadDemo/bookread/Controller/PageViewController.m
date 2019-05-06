//
//  PageViewController.m
//  DataStructureDemo
//
//  Created by ruantong on 2018/8/1.
//  Copyright © 2018年 wupeng. All rights reserved.
//

#import "PageViewController.h"
#import "PageDetailViewController.h"
#import "CTFrameConfigManager.h"
#import "CTFrameParser.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface PageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
{
    CoreTextModel * _coreTextData;
    BOOL isAfterPage;
}
@property(nonatomic ,strong) UIPageViewController *pageViewController;
@property(nonatomic ,strong) NSMutableArray<PageDetailViewController *> * dataArray;
@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"阅读翻页"];

    //添加pageViewController到Controller
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    //设置配置信息
    CTFrameConfigManager *config = [CTFrameConfigManager shareInstance];
    config.width = self.view.frame.size.width;
    config.height = self.view.frame.size.height-64-20;
    //获取模板文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JsonTemplate" ofType:@"json"];
    //创建绘制数据实例
    _coreTextData = [CTFrameParser parseTemplateFile:path];
    PageDetailViewController *imageViewController = [self createImage:0];
    [imageViewController refreshView:_coreTextData.pageDataArray[config.indexPage] coreTextModel:_coreTextData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPageViewControllerDataSource
//显示前一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    isAfterPage = NO;
    
    NSInteger integer = [self integerWithController:(PageDetailViewController *)viewController];
    integer = (integer-1+3)%3;
    
    CTFrameConfigManager * configManager = [CTFrameConfigManager shareInstance];
    if (configManager.indexPage == 0) {
        [SVProgressHUD showImage:nil status:@"前面没有了"];
        return nil;
    }
    PageDetailViewController * imageVC = [self createImage:integer];
    return imageVC;
}

//显示下一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    isAfterPage = YES;
    
    NSUInteger index = [self integerWithController:(PageDetailViewController *)viewController];
    index = (index+1)%3;
    if (index == self.dataArray.count)
    {
        return nil;
    }

    CTFrameConfigManager * configManager = [CTFrameConfigManager shareInstance];

    if (configManager.indexPage>0 && configManager.indexPage ==_coreTextData.pageDataArray.count-1) {
        [SVProgressHUD showImage:nil status:@"后面没有了"];
        return nil;
    }

    PageDetailViewController * imageVC = [self createImage:index];
    return imageVC;
    
}

//返回页控制器中页的数量
-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.dataArray.count;
}

//返回页控制器中当前页的索引
-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - UIPageViewControllerDelegate
//翻页视图控制器将要翻页时执行的方法
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    NSLog(@"将要翻页也就是手势触发时调用方法");

    CTFrameConfigManager * configManager = [CTFrameConfigManager shareInstance];
    if (isAfterPage) {
        configManager.indexPage++;
        if (configManager.indexPage == _coreTextData.pageDataArray.count) {
            configManager.indexPage--;
        }
    }else{
        configManager.indexPage--;
        if (configManager.indexPage<0) {
            configManager.indexPage++;
        }
    }
    NSLog(@"111-indexPage=%ld",configManager.indexPage);
    PageDetailViewController * pageDetailVC = (PageDetailViewController *)pendingViewControllers.firstObject;
    if (configManager.indexPage>=0 && configManager.indexPage<_coreTextData.pageDataArray.count) {
        [pageDetailVC refreshView:_coreTextData.pageDataArray[configManager.indexPage] coreTextModel:_coreTextData];
    }else{
        [SVProgressHUD showImage:nil status:@"越界了"];
    }
}

//可以通过返回值重设书轴类型枚举
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return UIPageViewControllerSpineLocationMin;
}

//返回页控制器中控制器的页内容控制器数
-(UIInterfaceOrientationMask)pageViewControllerSupportedInterfaceOrientations:(UIPageViewController *)pageViewController
{
    return UIInterfaceOrientationMaskPortrait;
}


//防止上一个动画还没有结束,下一个动画就开始了
//当用户从一个页面转向下一个或者前一个页面,或者当用户开始从一个页面转向另一个页面的途中后悔 了,并撤销返回到了之前的页面时,将会调用这个方法。假如成功跳转到另一个页面时,transitionCompleted 会被置成 YES,假如在跳转途中取消了跳转这个动作将会被置成 NO。
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(finished && completed)
    {
        // 无论有无翻页，只要动画结束就恢复交互。
        pageViewController.view.userInteractionEnabled = YES;
    }
    
}

#pragma mark - getter

- (UIPageViewController *)pageViewController{
    if (!_pageViewController) {
        //设置第三个参数
        NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
        
        //初始化UIPageViewController
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        //指定代理
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        
        //设置frame
        _pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        //是否双面显示，默认为NO
        _pageViewController.doubleSided = NO;
        
        //设置首页显示数据
        PageDetailViewController *imageViewController = [self createImage:0];
        NSArray *array = [NSArray arrayWithObjects:imageViewController, nil];
        [_pageViewController setViewControllers:array
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:YES
                                     completion:nil];
    }
    return _pageViewController;
}

- (NSMutableArray<PageDetailViewController *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            PageDetailViewController *imageVC = [[PageDetailViewController alloc]init];
            [_dataArray addObject:imageVC];
        }
    }
    return _dataArray;
}

//获取指定显示controller
-(PageDetailViewController *)createImage:(NSInteger)integer
{
    return [self.dataArray objectAtIndex:integer];
}

//获取显示controller元素下标
-(NSInteger)integerWithController:(PageDetailViewController *)vc
{
    return [self.dataArray indexOfObject:vc];
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
