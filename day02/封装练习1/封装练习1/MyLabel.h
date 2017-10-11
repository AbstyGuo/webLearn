//
//  MyLabel.h
//  封装练习1
//
//  Created by MS on 15-12-8.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLabel : UILabel

+(MyLabel *)initWithFrame:(CGRect)frame Text:(NSString *)text TextColor:(UIColor *)color TextAligment:(NSTextAlignment)alignment Font:(UIFont*)font;

@end
