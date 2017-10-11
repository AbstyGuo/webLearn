//
//  ViewController.m
//  封装练习1
//
//  Created by MS on 15-12-8.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "ViewController.h"
#import "MyView.h"
#import "MyLabel.h"

@interface ViewController ()<MyViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //为了减少代码的冗余和提高代码的复用，所以才有了封装
    MyView * myView = [[MyView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    myView.backgroundColor = [UIColor yellowColor];
    myView.delegate = self;
    [self.view addSubview:myView];
    MyLabel * label = [MyLabel initWithFrame:CGRectMake(10, 300, 200, 20) Text:@"1558" TextColor:[UIColor orangeColor] TextAligment:NSTextAlignmentCenter Font:[UIFont systemFontOfSize:15]];
    [self.view addSubview:label];
}

-(void)changeTitleWithString:(NSString *)title
{
    NSLog(@"%@",title);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
