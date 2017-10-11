//
//  ViewController.m
//  web7_(sidePush)
//
//  Created by zhulei on 15/12/15.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //关闭划出菜单的手势
    AppDelegate *delete = [UIApplication sharedApplication].delegate;
    
    delete.DDController.needSwipeShowMenu = NO;

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //在页面即将消逝的时候打开划出菜单的手势
    AppDelegate *delete = [UIApplication sharedApplication].delegate;
    
    delete.DDController.needSwipeShowMenu = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor cyanColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
