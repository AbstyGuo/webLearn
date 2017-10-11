//
//  ViewController.m
//  web8_NSThread
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
     进程：整个APP从运行开始进程就开始，运行结束进程结束，进程不是人为创建的，是系统生成的，从接触UI的第一天开始就在接触进程
     
     线程：分为
        主线程：主线程是伴随进程的<注:主线程只操作UI类的东西>
        子线程：为了分担主线程的压力，加快机器运行效率，提高用户体验<注:子线程不能操作UI类的东西，一半操作的是请求数据>
     
     如果不小心在主线程操作了数据，或者在子线程操作了UI会导致以下几种后果：
        1、数据出不来，或出来非常缓慢，造成界面假死卡主
        2、数据永远出不来
        3、程序崩溃
     */
    [super viewDidLoad];
    
    //获取当前APP的主线程
    //NSThread线程类
    NSThread * mainThread = [NSThread mainThread];
    if ([mainThread isMainThread]) {
        NSLog(@"获取到了主线程");
        NSLog(@"%@",mainThread);
    }
    
    //写两个按钮
    NSArray * array = @[@"线程1",@"线程2"];
    for(int i = 0 ; i < 2 ; i++){
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake((self.view.frame.size.width-300)/2, 100+i*(30+50), 300, 30);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + i;
        [self.view addSubview:btn];
    }
}

-(void)click:(UIButton *)btn
{
    if (btn.tag == 100) {
        //创建线程1  通过类方法开辟的子线程，方法会自动执行
        NSNumber * num = @10;
        //这种写法等同于
//        NSNumber * num = [NSNumber numberWithInt:10];
        [NSThread detachNewThreadSelector:@selector(firstThread:) toTarget:self withObject:num];
        
    }else if(btn.tag == 101){
        //创建线程2
        NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(secondThread:) object:@10];
        
        //通过对象方法创建的线程需要手动执行
        [thread start];
    }
}

-(void)secondThread:(NSNumber *)num
{
    int number = [num intValue];
    //获取当前正在执行的线程
    NSThread * thread = [NSThread currentThread];
    
    [thread setName:@"线程2"];
    for (int i = 0; i< number; i++) {
        //为了更好的看出打印效果，每次打印睡一秒
        NSLog(@"%@  %d",thread.name,i);
        [NSThread sleepForTimeInterval:1];
    }
    //当子线程完成任务的时候，系统会给这个子线程发送一个通知，被告知要结束当前线程回到主线程了；<MPMediaPlayerController>
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishCurrentThread) name:NSThreadWillExitNotification object:nil];

}

//执行第一个线程的方法，如果方法有参数，那么参数类型一定要和带过来的Object的类型一致，这样才能获取到Object
-(void)firstThread:(NSNumber *)num{
    int number = [num intValue];
    //获取当前正在执行的线程
    NSThread * thread = [NSThread currentThread];
    
    [thread setName:@"线程1"];
    for (int i = 0; i< number; i++) {
        //为了更好的看出打印效果，每次打印睡一秒
        NSLog(@"%@  %d",thread.name,i);
        [NSThread sleepForTimeInterval:1];
    }
    //当子线程完成任务的时候，系统会给这个子线程发送一个通知，被告知要结束当前线程回到主线程了；<MPMediaPlayerController>
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishCurrentThread) name:NSThreadWillExitNotification object:nil];
}

//执行结束子线程的通知方法
-(void)finishCurrentThread
{
    NSLog(@"子线程的方法执行完了");
    [self performSelectorOnMainThread:@selector(backMainThread) withObject:nil waitUntilDone:YES];
}

-(void)backMainThread
{
    NSLog(@"回归到了主线程");
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSThreadWillExitNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
