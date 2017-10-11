//
//  MyLabel.m
//  封装练习1
//
//  Created by MS on 15-12-8.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "MyLabel.h"

@implementation MyLabel
+(MyLabel *)initWithFrame:(CGRect)frame Text:(NSString *)text TextColor:(UIColor *)color TextAligment:(NSTextAlignment)alignment Font:(UIFont*)font
{
    MyLabel * label = [[MyLabel alloc]initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.textAlignment = alignment;
    label.font = font;
    return label;
}

@end
