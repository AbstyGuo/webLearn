//
//  ViewController.m
//  web7_(sidePush 02)
//
//  Created by MS on 15-12-15.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
{
    AppDelegate * _delegate;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    //关闭手势
    _delegate = [UIApplication sharedApplication].delegate;
    _delegate.DDController.needSwipeShowMenu = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //在页面将要消失时打开手势
    _delegate.DDController.needSwipeShowMenu = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
