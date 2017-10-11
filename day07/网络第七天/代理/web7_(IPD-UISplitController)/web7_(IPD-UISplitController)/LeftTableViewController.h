//
//  LeftTableViewController.h
//  web7_(IPD-UISplitController)
//
//  Created by zhulei on 15/12/15.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftDelegate <NSObject>

-(void)changeTextWithIndexPath:(NSIndexPath *)indexPath;

@end
@interface LeftTableViewController : UITableViewController

@property (nonatomic,weak)id<LeftDelegate>delegate;
@end
