//
//  AppDelegate.h
//  web7_(sidePush)
//
//  Created by zhulei on 15/12/15.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "LeftMenuController.h"
#import "YRSideViewController.h"
#import "DDMenuController.h"//侧滑框架需要引入的头文件
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    /*
     侧滑的框架包括的页面分为主页面<对照手机版QQ的主页面> 左侧滑页面和右侧滑页面<对照手机版QQ的侧滑菜单,但是通常情况下,侧滑页面只写一个就够了.>
     */
    
    MainViewController *_mainView;
    
    LeftMenuController *_leftView;
}
//<能不写属性就不写属性,只要跨页面需要调用变量的时候,才把变量写成属性>
@property (nonatomic,strong)YRSideViewController *DDController;

@property (nonatomic,strong)UINavigationController *myNav;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

