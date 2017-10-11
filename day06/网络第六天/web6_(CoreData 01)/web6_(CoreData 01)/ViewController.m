//
//  ViewController.m
//  web6_(CoreData 01)
//
//  Created by zhulei on 15/12/14.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"
#import "AppDelegate.h"
@interface ViewController (){
    
    AppDelegate *_delegate;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //实例化APPDelegate
    _delegate = [UIApplication sharedApplication].delegate;
    
    [self creatButtons];
}
-(void)creatButtons{
    
    NSArray *nameArray = @[@"增加",@"查找",@"修改",@"删除"];
    
    for (int i = 0; i<nameArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        button.frame = CGRectMake((self.view.frame.size.width - 300)/2, i*(30+20)+100, 300, 30);
        
        [button setTitle:[NSString stringWithFormat:@"%@",nameArray[i]] forState:UIControlStateNormal];
        
        button.tag = 100+i;
        
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
    }
    
}
-(void)click:(UIButton *)button{
    
    if (button.tag == 100) {
  //把student模型 和 数据库的student表进行映射关系的关联
     
        Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:_delegate.managedObjectContext];
        
  /*
   增加数据
   
   1.给模型的属性赋值
   2.数据库保存数据
   */
    //1.
//        student.name = @"朱磊";
//        student.age = @"18";
        
        [student setName:@"朱磊"];
        
        [student setAge:@"19"];
        
    //2.
        if([_delegate.managedObjectContext save:nil]){
            
            NSLog(@"数据插入成功");
        }
        
    }else if (button.tag == 101){
     
        //查找数据
       /*
        全部查找 条件查找
        */
        
        /*
         1.创建一个查找请求
         2.明确在哪儿进行查找的工作
         3.把1和2关联起来
         4.查找的结果是直接以数组的形式返回的,并且数组的元素是model
         
         */
        
        //1.
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        
        //如果需要条件查找,那么条件一定要写在1和3之间
        
        //predicate谓词,是正则表达式的一种,用于条件的设置<写法不固定>
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@",@"*朱磊*"];
        
        request.predicate = predicate;
        //2.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:_delegate.managedObjectContext];
        //3.
        [request setEntity:entity];
        
        //4.
        
        NSArray *array = [_delegate.managedObjectContext executeFetchRequest:request error:nil];
        
        if (array.count != 0) {
            
            for (Student *student in array) {
                
                NSLog(@"NAME = %@,AGE = %@",student.name,student.age);
            }
        }
        
        
    }else if (button.tag == 102){
        
     //修改数据
        
        /*
         1.先查找<把表里的数据都查找出来>
         2.再定位,<把要修改的数据,从返回的数组里面找出来>
         3.修改
         4.保存
         */
        
      //1.
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:_delegate.managedObjectContext];
        
        [request setEntity:entity];
        
        NSArray *array = [_delegate.managedObjectContext executeFetchRequest:request error:nil];
        
        //2
        Student *student = [array objectAtIndex:0];
        
        //3.
        student.name = @"朱磊1";
        student.age = @"29";
        
        //4.
        [_delegate.managedObjectContext save:nil];

        
    }else if (button.tag == 103){
        
     //删除数据
        
        /*
         1.先查找<把表里的数据都查找出来>
         2.再定位,<把要删除的数据,从返回的数组里面找出来>
         3.删除
         4.保存
         */
        
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:_delegate.managedObjectContext];
        
        [request setEntity:entity];
        
        NSArray *array = [_delegate.managedObjectContext executeFetchRequest:request error:nil];
        
        if (array.count>0) {
            
            Student *student = array[0];
            
            [_delegate.managedObjectContext deleteObject:student];
            
            [_delegate.managedObjectContext save:nil];
        }else if (array.count == 0){
            
            //如果删没了,按钮点击无效
            button.enabled = NO;
        }
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
