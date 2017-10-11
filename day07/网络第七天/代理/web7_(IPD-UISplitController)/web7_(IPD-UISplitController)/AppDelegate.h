//
//  AppDelegate.h
//  web7_(IPD-UISplitController)
//
//  Created by zhulei on 15/12/15.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftTableViewController.h"
#import "RightTableViewController.h"
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UISplitViewControllerDelegate>{
    
    LeftTableViewController *_left;
    UINavigationController *_leftNav;
    
    RightTableViewController *_right;
    UINavigationController *_rightNav;
    
    //分屏控制器 UISplitViewController <能够把ipad的屏幕一分为二并且两个屏幕之间可以相互通信>
    UISplitViewController *_splitView;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

