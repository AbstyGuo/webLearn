//
//  MyView.h
//  封装练习1
//
//  Created by MS on 15-12-8.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyViewDelegate <NSObject>

-(void)changeTitleWithString:(NSString *)title;

@end

@interface MyView : UIView

@property(nonatomic,weak)id<MyViewDelegate> delegate;

@end
