//
//  UIViewController+Category.m
//  DataStructureDemo
//
//  Created by hello on 2018/6/13.
//  Copyright © 2018年 wupeng. All rights reserved.
//

#import "UIViewController+Category.h"
#import <objc/message.h>

@implementation UIViewController (Category)

+ (void)load
{
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method viewDidLoadMethod = class_getInstanceMethod([self class], @selector(viewDidLoad));
        Method custom_viewDidLoadMethod = class_getInstanceMethod([self class], @selector(custom_viewDidLoad));
        method_exchangeImplementations(viewDidLoadMethod, custom_viewDidLoadMethod);
        
        Method viewWillAppearMethod = class_getInstanceMethod([self class], @selector(viewWillAppear:));
        Method custom_viewWillAppearMethod = class_getInstanceMethod([self class], @selector(custom_viewWillAppear:));
        method_exchangeImplementations(viewWillAppearMethod, custom_viewWillAppearMethod);
        
        Method viewWillDisappearMethod = class_getInstanceMethod([self class], @selector(viewWillDisappear:));
        Method custom_viewWillDisappearMethod = class_getInstanceMethod([self class], @selector(custom_viewWillDisappear:));
        method_exchangeImplementations(viewWillDisappearMethod, custom_viewWillDisappearMethod);
        
        Method deallocMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
        Method custom_deallocMethod = class_getInstanceMethod([self class], @selector(custom_dealloc));
        method_exchangeImplementations(deallocMethod, custom_deallocMethod);
    });
}
//系统调用UIViewController的viewDidLoad方法时，实际上执行的是我们实现的swizzlingViewDidLoad方法。而我们在swizzlingViewDidLoad方法内部调用[self swizzlingViewDidLoad];时，执行的是UIViewController的viewDidLoad方法
- (void)custom_viewDidLoad
{
    if (![self isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    [self custom_viewDidLoad];
}

- (void)custom_viewWillAppear:(BOOL)animated{
//    NSLog(@"你将要进入了%@页面",[self class]);
    [self custom_viewWillAppear:animated];
}

- (void)custom_viewWillDisappear:(BOOL)animated{
//    NSLog(@"你将要离开了%@页面",[self class]);
    [self custom_viewWillDisappear:animated];
}
                
- (void)custom_dealloc{
  NSString * className = NSStringFromClass([self class]);
  if (![className containsString:@"OS_"] && ![className containsString:@"NS"]) {
//      NSLog(@"%@ dealloc",[self class]);
  }
  [self custom_dealloc];
}

@end
