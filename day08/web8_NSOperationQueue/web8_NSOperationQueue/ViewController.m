//
//  ViewController.m
//  web8_NSOperationQueue
//
//  Created by MS on 15-12-16.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSOperationQueue * _queue;//操作队列<想象成迅雷下载任务器，只是一个装着任务的容器，queue里面装的任务，要按照容器的规则来运行>
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //先实例化容器
    _queue = [[NSOperationQueue alloc]init];
    
    //设置容器的属性<规则>
    //最大任务执行数
    _queue.maxConcurrentOperationCount = 1;
    
    //实例化装进容器里面的任务
    
    //创建任务的两种方式
    //1
    NSInvocationOperation * invocation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(renwu1) object:nil];
    //2
    NSBlockOperation * block = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务2");
    }];
    
    //把任务装到容器中去  当最大任务数是1的时候，那么往容器里添加任务的顺序就是任务的执行顺序
    
    //想改变任务的执行顺序,需要任务间有依附关系，A依附于B，那么B先执行，A后执行，并且需要注意的是，这种依附关系的确立，必须写在把任务添加到容器之前
    [invocation addDependency:block];//前一个依附于后一个
    
    [_queue addOperation:invocation];
    [_queue addOperation:block];
}

-(void)renwu1
{
    NSLog(@"任务1");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
