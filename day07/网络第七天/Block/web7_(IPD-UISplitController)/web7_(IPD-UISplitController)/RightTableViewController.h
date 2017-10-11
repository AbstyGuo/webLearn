//
//  RightTableViewController.h
//  web7_(IPD-UISplitController)
//
//  Created by zhulei on 15/12/15.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPopOverContentController.h"
@interface RightTableViewController : UITableViewController<MyPopDelegate>

@property (nonatomic,strong)NSIndexPath *indexPath;//是用来接收左视图传递过来的block值

@end
