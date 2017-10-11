//
//  MyButtons.h
//  Buttons
//
//  Created by zhulei on 15/10/29.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyButtonDelegate <NSObject>

-(void)clickButtonWithButtonTag:(NSInteger)tag;

@end
@interface MyButtons : UIView

@property (nonatomic,weak)id<MyButtonDelegate>delegate;
@end
