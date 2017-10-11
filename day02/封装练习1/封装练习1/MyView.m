//
//  MyView.m
//  封装练习1
//
//  Created by MS on 15-12-8.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "MyView.h"

@implementation MyView

//1.重写init方法
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

//往这个view上添加子视图<控件>
-(void)createUI
{
    UITextField * nameField = [[UITextField alloc]initWithFrame:CGRectMake((self.frame.size.width-300)/2, 10, 300, 40)];
    nameField.borderStyle = UITextBorderStyleRoundedRect;
    nameField.placeholder = @"请输入姓名";
    nameField.tag =100;
    [self addSubview:nameField];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"改变title" forState:UIControlStateNormal];
    button.frame = CGRectMake(50, 100, 100, 30);
    [self addSubview:button];
}

-(void)click
{
    UITextField * field = (id)[self viewWithTag:100];
    [_delegate changeTitleWithString:field.text];
}

@end
