//
//  LeftTableViewController.h
//  web7_(IPD-UISplitController)
//
//  Created by zhulei on 15/12/15.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftTableViewController : UITableViewController
//添加一个属性,用来记录KVO发生变化的值,属性的添加要根据传值的那给值的类型来确定属性的类型
@property (nonatomic,strong)NSIndexPath *indexPath;
@end
