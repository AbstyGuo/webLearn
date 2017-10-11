//
//  ViewController.m
//  web1_(NSURLSession 03)
//
//  Created by zhulei on 15/12/7.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "ViewController.h"
#define REQUESTURL @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=1"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self creatData];
   

}
//数据请求
-(void)creatData{
  
    /*
     IOS9 以后 NSURLConnection 被废弃了,所以使用NSURLSession,
     NSURLSession是对NSURLConnection二次封装
     */
    
    //网络请求
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:REQUESTURL]];
    
    //网络连接
    NSURLSession *session = [NSURLSession sharedSession];
   
    //把网络请求和网络连接关联起来
   NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
     
       //data 就是02demo里面的_myData 是接收完所有的data返回来的容器,所以接下来对这个data 进行解析
       
       NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
       
       NSArray *array = [rootDic objectForKey:@"applications"];
       
       for (NSDictionary *dic in array) {
           
           NSLog(@"%@",[dic objectForKey:@"name"]);
       }
      
   }];
  
    //断点续传... 数据全部返回后再调用block
    [task resume];
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
