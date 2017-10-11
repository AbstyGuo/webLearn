//
//  AppDelegate.h
//  web7_(sidePush 02)
//
//  Created by MS on 15-12-15.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"//侧滑框架需要引入的头文件
#import "MainViewController.h"
#import "LeftMenuController.h"
#import "YRSideViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    /*
     侧滑的框架包括的页面分为
     主页面<对照手机版QQ的主页面>
     左侧滑界面和右侧滑界面<对照手机版QQ的侧滑菜单,但是通常情况下，侧滑的页面只写一个就够了>
     */
    MainViewController * _mainView;
    LeftMenuController * _leftView;
}

//通常情况下能不写属性就不写属性，只有跨页面需要调用变量的时候才把变量写成属性
@property(nonatomic,strong)YRSideViewController *DDController;
@property(nonatomic,strong)UINavigationController * myNav;

@property (strong, nonatomic) UIWindow *window;


@end

