//
//  AppDelegate.m
//  web7_(sidePush 02)
//
//  Created by MS on 15-12-15.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    //先实例化左侧的菜单
    _leftView = [[LeftMenuController alloc]init];
    //实例化主页面
    _mainView = [[MainViewController alloc]init];
    _myNav = [[UINavigationController alloc]initWithRootViewController:_mainView];
    
    //实例化侧滑框架
    _DDController = [[YRSideViewController alloc]init];

    //给这个框架设置主页面和侧滑菜单页面
    _DDController.leftViewController = _leftView;
    _DDController.leftViewShowWidth = 160;
    [_DDController setRootViewController:_myNav];
    _window.rootViewController = _DDController;
    
    //重做动画效果的block
//    [_DDController setRootViewMoveBlock:^(UIView *rootView, CGRect orginFrame, CGFloat xoffset) {
//
    //    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
