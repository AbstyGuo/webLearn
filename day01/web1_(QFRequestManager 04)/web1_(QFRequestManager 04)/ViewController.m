//
//  ViewController.m
//  web1_(QFRequestManager 04)
//
//  Created by MS on 15-12-7.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "ViewController.h"
#import "QFRequestManager.h"

#define REQUESTURL @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=1"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
}

-(void)createData
{
    [QFRequestManager requestWithUrl:REQUESTURL IsCache:YES FinishBlock:^(NSData * data){
        //在这里 对data进行解析，这个data是通过block把NSURLSession返回的data传递过来的
        NSDictionary * rootDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray * array = [rootDic objectForKey:@"applications"];
        for (NSDictionary * dic in array) {
            NSLog(@"NAME = %@",dic[@"name"]);
        }
        
        //如果当前页面时tableView 需要reloaddata 那么就执行下面的方法，回到主线程让tableView刷新数据
        [self performSelectorOnMainThread:@selector(backMainThread) withObject:nil waitUntilDone:YES];
        
    } FailedBlock:^(NSError * error){
        //返回错误信息
    }];
}

-(void)backMainThread
{
//    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
