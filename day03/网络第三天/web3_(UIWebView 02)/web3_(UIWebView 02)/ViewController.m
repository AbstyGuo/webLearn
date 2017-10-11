//
//  ViewController.m
//  web3_(UIWebView 02)
//
//  Created by zhulei on 15/12/9.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.renren.com"]];
    
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
