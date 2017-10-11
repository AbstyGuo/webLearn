//
//  AppDelegate.h
//  web6_(CoreData 01)
//
//  Created by zhulei on 15/12/14.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//managedObjectContext 完成对数据进行增删改查的功能
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//是与数据库的表相关联的模型<想对数据库的数据进行操作,只需要操作模型就可以了>
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

