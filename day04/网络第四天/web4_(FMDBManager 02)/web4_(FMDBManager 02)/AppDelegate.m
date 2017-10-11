//
//  AppDelegate.m
//  web4_(FMDBManager 02)
//
//  Created by zhulei on 15/12/10.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "AppDelegate.h"
#import "FMDBManager.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    ViewController *view = [[ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:view];
    
    self.window.rootViewController = nav;
    
    [[FMDBManager shareInstance]open];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[FMDBManager shareInstance]close];
}

@end
