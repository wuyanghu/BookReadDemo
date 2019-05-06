//
//  ViewController.m
//  BookReadDemo
//
//  Created by ruantong on 2019/4/26.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "ViewController.h"
#import "PageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pushReadAction:(id)sender {
    PageViewController * pageVC = [[PageViewController alloc] init];
    [self.navigationController pushViewController:pageVC animated:YES];

}

@end
