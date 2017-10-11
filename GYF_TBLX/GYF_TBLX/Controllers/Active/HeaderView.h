//
//  HeaderView.h
//  GYF_TBLX
//
//  Created by MS on 15-12-25.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButtons.h"

@protocol HeaderDelegate <NSObject>

-(void)pushController:(UIViewController *)controller;

@end

@interface HeaderView : UIView<MyButtonDelegate>

@property(nonatomic,assign) id<HeaderDelegate> delegate;

@end
