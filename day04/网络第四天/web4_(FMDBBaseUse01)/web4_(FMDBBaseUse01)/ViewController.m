//
//  ViewController.m
//  web4_(FMDBBaseUse01)
//
//  Created by zhulei on 15/12/10.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"
@interface ViewController (){
    
    FMDatabase *_dataBase;//因为全局都要调用数据库,所以写成全局变量
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self creatButtons];
}
-(void)creatButtons{
    
    NSArray *nameArray = @[@"创建数据库",@"建表",@"增加",@"查找",@"修改",@"删除"];
    
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
        //创建数据库并打开
       
        //1.需要找到一个存放数据库的沙盒路径
       
        //数据库的名要以.db结尾,并且名字不能是系统关键字
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/zhulei.db"];
        
        //2.创建数据库
        
        _dataBase = [[FMDatabase alloc]initWithPath:path];
        
        
        //打开数据库
        
        if([_dataBase open]){
            
            NSLog(@"数据库创建并打开成功");
        }
        
    }else if (button.tag == 101){
        //创建表
        
       //表名不能是关键字,而且需要重点注意的是<建表之前,一定要确定表里的字段>
     //括号前面是确定表名,括号里面是确定表的字段和字段的属性以及字节
        
        //数据库存储的数据类型为二进制类型的,如果要存图片之类的信息,需要转换成NSData类型的<NSData类型的数据 在表的字段的属性表现形式为blob>
     NSString *createTableSql = @"create table if not exists student (id integer primary key ,name varchar (256),age varchar (256))";
        
        //让数据库来操作sql语句
        
        if( [_dataBase executeUpdate:createTableSql]){
            
            
            NSLog(@"表创建成功");
        }
        
        
    }else if (button.tag == 102){
        //插入数据
      NSString *insertSql = @"insert into student (name,age)values(?,?)";
        
        if([_dataBase executeUpdate:insertSql,@"朱磊",@"17"]){
            
            NSLog(@"数据插入成功");
        }
        
        
    }else if (button.tag == 103){
        //查找数据
        
      /*
       全部查找和条件查找
       */
        
        //全部查找
        
     NSString *selectSql = @"select *from student where id = 1";
    
        //FMResultSet里面就装着查找回来的数据,相当于数组
    FMResultSet *set = [_dataBase executeQuery:selectSql];
        
        while ([set next]) {
            
            NSString *name = [set stringForColumn:@"name"];
            
            int studentId = [set intForColumn:@"id"];
            
            NSString *age = [set stringForColumn:@"age"];
            
            NSLog(@" Id =%d name = %@ age = %@",studentId,name,age);
            
        }
        
        
    }else if (button.tag == 104){
        //修改数据
        //修改student表里面 id=2的那条数据的name和age
     NSString *updateSql = @"update student set name = ?,age = ? where id = 1";
        
        if ([_dataBase executeUpdate:updateSql,@"喂,小芳",@"30"]) {
            
            NSLog(@"修改成功");
        }
        
        
        
    }else if (button.tag == 105){
        //删除数据
        
        //全部删除和精确删除
        
        NSString *deleteSql = @"delete from student";
        
        if ([_dataBase executeUpdate:deleteSql]) {
            
            NSLog(@"数据删除成功");
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
