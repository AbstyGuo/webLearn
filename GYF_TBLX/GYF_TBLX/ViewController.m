//
//  ViewController.m
//  GYF_TBLX
//
//  Created by MS on 15-12-25.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "ViewController.h"
#import "ActiveController.h"
#import "MyController.h"
#import "PathController.h"
#import "TravelController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    ActiveController * act = [[ActiveController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:act];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"活动" image:[UIImage imageNamed:@"icon_activity_57x49"] selectedImage:[UIImage imageNamed:@"icon_activity_pressed_57x49"]];
    nav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    TravelController * travel = [[TravelController alloc]init];
    travel.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"游记" image:[UIImage imageNamed:@"icon_travels_57x49"] selectedImage:[UIImage imageNamed:@"icon_travels_pressed_57x49"]];
    travel.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    PathController * path = [[PathController alloc]init];
    path.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"路线" image:[UIImage imageNamed:@"icon_route_57x49"] selectedImage:[UIImage imageNamed:@"icon_route_pressed_57x49"]];
    path.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    MyController * mine = [[MyController alloc]init];
    UINavigationController * myNav = [[UINavigationController alloc]initWithRootViewController:mine];
    myNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"icon_me_57x49"] selectedImage:[UIImage imageNamed:@"icon_me_pressed_57x49"]];
    myNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

    self.viewControllers = @[nav,travel,path,myNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
