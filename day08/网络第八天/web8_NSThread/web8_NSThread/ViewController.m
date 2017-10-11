//
//  ViewController.m
//  web8_NSThread
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
     进程 整个App从运行开始,进程就开始,运行结束,进程结束,进程不是人为创建的,是系统生成的,从接触UI的第一天开始就在接触进程
     
     线程
     
     主线程 主线程是伴随进程的<注:主线程只操作UI类的东西>
     
     子线程 为了分担主线程的压力,加快机器运行效率,提高用户体验<注:子线程不能操作UI类的东西,一般操作的是请求数据>
     
     /如果不小心在主线程操作了数据,或者在子线程操作了UI会导致以下几种后果
     1.数据出来非常缓慢,造成界面假死卡住
     2.数据永远出不来
     3.程序崩溃
     /
     */
    [super viewDidLoad];
    
    
    //获取当前APP的主线程
    
    //NSThread线程类
    NSThread *mainThread = [NSThread mainThread];
    
    if ([mainThread isMainThread]) {
        
        NSLog(@"获取到了主线程");
    }
    
    //写两个按钮
    
    NSArray *nameArray = @[@"线程1",@"线程2"];
    
    for (int i = 0; i<nameArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        button.frame = CGRectMake((self.view.frame.size.width - 300)/2, 100+i*(30+20), 300, 30);
        
        [button setTitle:[NSString stringWithFormat:@"%@",nameArray[i]] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = 100+i;
        
        [self.view addSubview:button];
    }
}

-(void)click:(UIButton *)btn{
    
    if (btn.tag == 100) {
        //创建线程1  通过类方法开辟的子线程,方法会自动执行
        NSNumber *num = @10;
        //
//        NSNumber *num1 = [NSNumber numberWithInt:10];
        [NSThread detachNewThreadSelector:@selector(firstThread:) toTarget:self withObject:num];
    
    }else if (btn.tag == 101){
        //创建线程2
    
        NSNumber *num = @10;

        //通过对象方法创建的线程,需要手动执行
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(secondThread:) object:num];
        
        [thread start];
    }
}
-(void)secondThread:(NSNumber *)num{
    
    int number = [num intValue];
    //获取当前正在执行的线程
    NSThread *thread = [NSThread currentThread];
    
    [thread setName:@"线程2"];
    
    for (int i = 0; i<number; i++) {
        
        NSLog(@"%@ %d",thread.name,i);
        
        //为了更好的看出打印效果,每次打印睡一秒
        
        [NSThread sleepForTimeInterval:1];
    }
    
    //当子线程完成任务的时候,系统会给这个子线程发送一个通知,被告知要结束当前线程;<MPMediaPlayerContrller>
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishCurrentThread) name:NSThreadWillExitNotification object:nil];
}
//执行第一个线程的方法,如果方法有参数,那么参数类型一定要和带过来的object的类型一致,这样才能获取到object
-(void)firstThread:(NSNumber *)num{
    
    int number = [num intValue];
   //获取当前正在执行的线程
    NSThread *thread = [NSThread currentThread];
    
    [thread setName:@"线程1"];
    
    for (int i = 0; i<number; i++) {
        
        NSLog(@"%@ %d",thread.name,i);
        
        //为了更好的看出打印效果,每次打印睡一秒
        
        [NSThread sleepForTimeInterval:1];
    }
    
    //当子线程完成任务的时候,系统会给这个子线程发送一个通知,被告知要结束当前线程;<MPMediaPlayerContrller>
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishCurrentThread) name:NSThreadWillExitNotification object:nil];
    
}
//执行结束子线程的通知方法
-(void)finishCurrentThread{
    
  //回归到主线程
    [self performSelectorOnMainThread:@selector(backMainThread) withObject:nil waitUntilDone:YES];
    
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSThreadWillExitNotification object:nil];
}
-(void)backMainThread{
    
    NSLog(@"回归到了主线程");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
