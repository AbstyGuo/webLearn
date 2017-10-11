//
//  ViewController.m
//  web8_GCD
//
//  Created by zhulei on 15/12/16.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    /*
     GCD->grand central dispatch
     
     队列
     系统队列
     主队列-->主线程
     
     全局队列-->子线程
     
     自定义队列
     */
    
    /*
     系统队列是自然存在的,我们只需要做的是调用队列,调用队列的方法是固定的,也是统一的.
     */
    [super viewDidLoad];
    
   //dispatch_async调用队列的固定方法,第一个参数是调用哪个队列的队列名
    //调用全局队列  全局队列的第一个参数是代表队列的优先级
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        //调用这个全局队列要做的事情 就在该block里面写
       
     //做一个网络请求
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img0.imgtn.bdimg.com/it/u=2673907580,550241866&fm=11&gp=0.jpg"]];
        
        //转化成Image
        UIImage *image = [UIImage imageWithData:data];
        
        //请求完数据后,回到主队列做UI的操作
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            //把这张image 作为当前页面的背景色
            
            self.view.backgroundColor = [UIColor colorWithPatternImage:image];
            
        });
        
});
    
    
    //自己创建一个队列 dispatch_queue_t创建队列的写法
    
    //DISPATCH_QUEUE_CONCURRENT 代表当前的队列是并行队列
    //DISPATCH_QUEUE_SERIAL 代表当前的队列是串行队列
    dispatch_queue_t myQueue = dispatch_queue_create("1558", DISPATCH_QUEUE_SERIAL);
    
    //创建完队列后,需要调用
    
    dispatch_async(myQueue, ^{
       
        NSLog(@"1");
        
        [NSThread sleepForTimeInterval:1];
    });
    
    dispatch_async(myQueue, ^{
        
        NSLog(@"2");
        
        [NSThread sleepForTimeInterval:1];
    });
    
    dispatch_async(myQueue, ^{
        
        NSLog(@"3");
        
        [NSThread sleepForTimeInterval:1];
    });
    
    //并行队列在执行block的时候,是一起执行,并且是无序的
    
    //串行队列在执行block的时候,是有序的,顺序按照block的调用顺序来定
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
