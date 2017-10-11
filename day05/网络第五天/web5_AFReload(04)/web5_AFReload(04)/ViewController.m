//
//  ViewController.m
//  web5_AFReload(04)
//
//  Created by zhulei on 15/12/11.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "ViewController.h"
#import "AFDownloadRequestOperation.h"
@interface ViewController (){
    
    UIProgressView *_progressView;
    
    AFDownloadRequestOperation *_operation;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *nameArray = @[@"下载",@"暂停"];
    
    for (int i = 0; i<nameArray.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        btn.frame = CGRectMake((self.view.frame.size.width - 300)/2, 100+i*(30+20), 300, 30);
        [btn setTitle:[NSString stringWithFormat:@"%@",nameArray[i]] forState:UIControlStateNormal];
        
        btn.tag = 100+i;
        
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }
    
    _progressView =[[UIProgressView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, 200, 300, 10)];
    
    [self.view addSubview:_progressView];
    
    
}
-(void)click:(UIButton *)btn{
 
    if (btn.tag == 100) {
        //开始下载
        
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/zhulei.jpg"];
        
        NSLog(@"%@",path);
        _operation = [[AFDownloadRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://imgsrc.baidu.com/forum/pic/item/4a36acaf2edda3ccf1bb668601e93901213f923d.jpg"]] targetPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/zhulei.jpg"] shouldResume:YES];
        
        
        [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
           
            NSLog(@"OK");
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Failed");
        }];
        
        
       [_operation setProgressiveDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
          
           //当前下载字节totalBytesReadForFile
           //总字节totalBytesExpectedToReadForFile
           
           _progressView.progress = totalBytesReadForFile/(CGFloat)totalBytesExpectedToReadForFile;
           
       }];
        [_operation start];
        
    }else if (btn.tag == 101){
        //暂停下载
        
        [_operation cancel];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
