//
//  ViewController.m
//  web5_(AFReload 04)
//
//  Created by MS on 15-12-11.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "ViewController.h"
#import "AFDownloadRequestOperation.h"

@interface ViewController ()
{
    UIProgressView * _progress;
    //并不是所有的可以下载资源都支持断点续传，是否支持断点续传得写后台服务器的人会告诉我们
    AFDownloadRequestOperation * _operation;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)createUI
{
    NSArray * array = @[@"开始",@"暂停"];
    
    for (int i = 0; i<2; i++) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 100+i*(30+50), 100, 30)];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        btn.tag = 100+i;
        btn.backgroundColor = [UIColor lightGrayColor];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(20, 240, self.view.frame.size.width-40, 15)];
    
    [self.view addSubview:_progress];
}

-(void)click:(UIButton *)button
{
    if (button.tag==100) {
        //开始下载
        NSString * path =[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/guo"] ;
        NSLog(@"%@",path);
        _operation = [[AFDownloadRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://i5.download.fd.pchome.net/t_200x150/g1/M00/12/08/oYYBAFZk4huIRQHDAARuT0JnFLcAACy8wMy3SsABG5n816.jpg"]] targetPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/guo1"] shouldResume:YES];
        
        [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"OK");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed");
        }];
        
        [_operation setProgressiveDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
            //当前下载字节totalBytesReadForFile  总字节totalBytesExpectedToReadForFile
            _progress.progress = totalBytesReadForFile/(CGFloat)totalBytesExpectedToReadForFile;
        }];
        
        [_operation start];
        
    }else if (button.tag==101)
    {
        //暂停下载
        [_operation cancel];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
