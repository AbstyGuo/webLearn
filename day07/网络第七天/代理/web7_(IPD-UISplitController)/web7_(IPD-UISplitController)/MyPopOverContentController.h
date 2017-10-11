//
//  MyPopOverContentController.h
//  web7_(IPD-UISplitController)
//
//  Created by zhulei on 15/12/15.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyPopDelegate <NSObject>

-(void)changeTextWithIndexPathRow:(NSIndexPath *)indexPath;

@end

@interface MyPopOverContentController : UITableViewController

@property (nonatomic,weak)id<MyPopDelegate>delegate;
@end
