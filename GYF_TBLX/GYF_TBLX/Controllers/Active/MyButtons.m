//
//  MyButtons.m
//  Buttons
//
//  Created by zhulei on 15/10/29.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "MyButtons.h"

@implementation MyButtons

-(id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatButtons];
    }
    
    return self;
}
-(void)creatButtons{
    
    NSArray *nameArray = @[@"activity_grid_item_content_new_1.png",@"activity_grid_item_content_new_2.png",@"activity_grid_item_content_new_3.png",@"activity_grid_item_content_new_4.png",@"activity_grid_item_content_new_6.png",@"activity_grid_item_content_new_8.png",@"activity_grid_item_content_new_9.png",@"activity_grid_item_content_new_10.png"];
    NSArray * titleArray = @[@"全部",@"周末",@"长线",@"摄影",@"入门",@"进阶",@"露营",@"亲子"];
    
    CGFloat buttonWidth = self.frame.size.width/4;
    for (int i = 0 ; i<nameArray.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((i%4)*buttonWidth, (i/4)*88, buttonWidth, 88);
        btn.layer.borderWidth = 0.3;
        
        UILabel * label = [[UILabel alloc]initWithFrame: CGRectMake(0,60, buttonWidth,20)];
        label.text = titleArray[i];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((buttonWidth/2-22),16, 44,44)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[nameArray objectAtIndex:i]]];
        
        [btn addSubview:imageView];
        [btn addSubview:label];
        
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        btn.layer.borderColor = [UIColor grayColor].CGColor;
//        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[nameArray objectAtIndex:i]]] forState:UIControlStateNormal];
        [self addSubview:btn];
        
    }
}
-(void)click:(UIButton *)button{
    
    [self.delegate clickButtonWithButtonTag:button.tag];
}
@end
