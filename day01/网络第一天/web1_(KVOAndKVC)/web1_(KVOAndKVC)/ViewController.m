//
//  ViewController.m
//  web1_(KVOAndKVC)
//
//  Created by zhulei on 15/12/7.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"
@interface ViewController (){
    
    Student *student;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    student = [[Student alloc]init];
   
    student.name = @"班长";
    
    //KVC -->KEY VALUE CODING  <键值编码>(用法和.语法类似)
    
    //value就是值,key就是类的属性
    [student setValue:@"学委" forKey:@"name"];
    
    NSLog(@"%@",student.name);
    
    
    
    
    //KVO -->KEY VALUE Observer <键值观察者>
    //定义:假设有A.B两个类,A有一个属性,然后给A添加一个观察者B,让B观察A的属性是否发生了变化,如果属性发生变化,那么B类就会执行一个观察者方法,来获取到A类的属性变化前后的值.
    
    [student addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
  
    
    student.name = @"体委";
    
}
//B类执行观察者方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
   
    
    NSString *oldName = [change objectForKey:@"old"];
    
    NSString *newName = [change objectForKey:@"new"];
    
    NSLog(@"%@%@",oldName,newName);

    
    //观察完后,把观察者移除掉
    
     [student removeObserver:self forKeyPath:@"name"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
