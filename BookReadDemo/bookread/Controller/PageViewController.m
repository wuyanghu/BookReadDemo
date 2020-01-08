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
#import <SVProgressHUD/SVProgressHUD.h>

@interface PageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
{
    ParseCoreTextPage * _coreTextData;
    BOOL _isAfterPage;
}
@property(nonatomic ,strong) UIPageViewController *pageViewController;
@property(nonatomic ,strong) NSMutableArray<PageDetailViewController *> * dataArray;//翻页的view
@end

@implementation PageViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"阅读翻页"];

    //添加pageViewController到Controller
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    [self parseBookReadJson];
    [[self getPageDetailVC:0] refreshViewWithIndex:[self getConfigManager].indexPage coreTextModel:_coreTextData];
}

#pragma mark - private method

- (CTFrameConfigManager *)getConfigManager{
    return [CTFrameConfigManager shareInstance];
}

- (void)parseBookReadJson{
    _coreTextData = [ParseCoreTextPage new];
    NSString * bookJosn = [[NSBundle mainBundle] pathForResource:@"JsonTemplate" ofType:@"json"];
    [_coreTextData calculatePageArray:bookJosn];
}

- (BOOL)indexOverBorderDataArr:(NSArray *)dataArr index:(NSInteger)index{
    if (index<0 || index>=dataArr.count) {
        return YES;
    }
    return NO;
}

- (NSInteger)calculateBeforeIndex:(PageDetailViewController *)viewController{
    NSInteger beforeIndex = [self integerWithController:(PageDetailViewController *)viewController];
    beforeIndex = (beforeIndex-1+3)%3;
    
    return beforeIndex;
}

- (NSInteger)calculateAfterIndex:(PageDetailViewController *)viewController{
    NSUInteger afterIndex = [self integerWithController:(PageDetailViewController *)viewController];
    afterIndex = (afterIndex+1)%3;
    
    return afterIndex;
}

- (void)calculateCurrentIndex{
    CTFrameConfigManager * configManager = [CTFrameConfigManager shareInstance];
    if (_isAfterPage) {
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
    
}

#pragma mark - UIPageViewControllerDataSource
//显示前一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    _isAfterPage = NO;
    
    CTFrameConfigManager * configManager = [CTFrameConfigManager shareInstance];
    if (configManager.indexPage == 0) {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"前面没有了"];
        return nil;
    }
    PageDetailViewController * imageVC = [self getPageDetailVC:[self calculateBeforeIndex:(PageDetailViewController *)viewController]];
    return imageVC;
}

//显示下一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    _isAfterPage = YES;
    
    CTFrameConfigManager * configManager = [CTFrameConfigManager shareInstance];
    if (configManager.indexPage == _coreTextData.pageDataArray.count-1) {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"后面没有了"];
        return nil;
    }

    return [self getPageDetailVC:[self calculateAfterIndex:(PageDetailViewController *)viewController]];
    
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
    [self calculateCurrentIndex];

    PageDetailViewController * pageDetailVC = (PageDetailViewController *)pendingViewControllers.firstObject;
    if (![self indexOverBorderDataArr:_coreTextData.pageDataArray index:[self getConfigManager].indexPage]) {
        [pageDetailVC refreshViewWithIndex:[self getConfigManager].indexPage coreTextModel:_coreTextData];
    }else{
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"越界了"];
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
        PageDetailViewController *imageViewController = [self getPageDetailVC:0];
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
            PageDetailViewController * pageDetailVC = [[PageDetailViewController alloc]init];
            [_dataArray addObject:pageDetailVC];
        }
    }
    return _dataArray;
}

-(PageDetailViewController *)getPageDetailVC:(NSInteger)integer
{
    return [self.dataArray objectAtIndex:integer];
}

-(NSInteger)integerWithController:(PageDetailViewController *)vc
{
    return [self.dataArray indexOfObject:vc];
}

@end
