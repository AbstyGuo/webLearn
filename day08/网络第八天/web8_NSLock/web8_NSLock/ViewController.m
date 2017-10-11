//
//  ViewController.m
//  web8_NSLock
//
//  Created by zhulei on 15/12/16.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    
    NSLock *_lock;//线程锁-->维护线程的执行顺序,防止抢占资源,防止导致程序崩溃
    
    int _tickets;//总票数
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lock = [[NSLock alloc]init];
    
    _tickets = 30;
    
    
    //开辟三个售票窗口来卖这30张票
    
    NSThread *thread1 = [[NSThread alloc]initWithTarget:self selector:@selector(saleTicket) object:nil];
    
    [thread1 setName:@"售票口1"];
    
    [thread1 start];
    
    NSThread *thread2 = [[NSThread alloc]initWithTarget:self selector:@selector(saleTicket) object:nil];
    
    [thread2 setName:@"售票口2"];
    
    [thread2 start];
    
    NSThread *thread3 = [[NSThread alloc]initWithTarget:self selector:@selector(saleTicket) object:nil];
    
    [thread3 setName:@"售票口3"];
    
    [thread3 start];
    
    
}
-(void)saleTicket{
    
    //获取一下当前正在售票的售票窗口
    NSThread *currentThread = [NSThread currentThread];
    
    while (1) {
        //加上线程锁
        [_lock lock];
        
        _tickets -- ;
        
        NSLog(@"当前售票窗口为%@, 剩余票数为%d张",currentThread.name,_tickets);
        
        [NSThread sleepForTimeInterval:0.5];
        
        if (_tickets == 0) {
            
            break;
        }
        //解锁
        [_lock unlock];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
