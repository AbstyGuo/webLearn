//
//  ViewController.m
//  web8_GCD
//
//  Created by MS on 15-12-16.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    /*
     GCD -> grand central dispatch  
     
     GCD也被称为队列
     分为：
     系统队列
        主队列  -->    主线程
        全局队列 -->    子线程
     自定义队列
     */
    
    /*
     系统队列是自然存在的，我们只需要做的是调用队列，调用队列的方法是固定的，同时也是统一的。
     */
    
    [super viewDidLoad];
    
    //dispatch_async调用队列的固定方法，第一个参数是调用哪个队列的队列名，第二个参数是调用队列干什么
    //dispatch_get_global_queue 调用全局队列  第一个参数代表全局队列的优先级别  第二个参数固定填0
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //调用这个全局队列要做的事情就在该block内写
        
        //做一个网络请求
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://p1.wmpic.me/article/2015/12/05/1449303612_WUZDzsCg.jpg"]];
        
        //转换成image
        UIImage * image = [UIImage imageWithData:data];
    
        //请求完数据后，回到主队列做UI的操作
        dispatch_async(dispatch_get_main_queue(), ^{
            //把这个image 作为当前页面的背景色
            self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        });
    });
    
    
    //自己创建一个队列  dispatch_queue_t 创建队列的固定写法 第一个参数为标识符查找队列的标识
    //DISPATCH_QUEUE_CONCURRENT 代表当前队列是并行队列
    //DISPATCH_QUEUE_SERIAL 代表当前队列是串行队列
    dispatch_queue_t myQueue = dispatch_queue_create("1558", DISPATCH_QUEUE_SERIAL);
    
    //创建完队列后需要调用
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

    //并行队列在执行block时是一起执行，并且是无序的
    //串行队列在执行block时是有序的，顺序按照block的调用顺序来定
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
