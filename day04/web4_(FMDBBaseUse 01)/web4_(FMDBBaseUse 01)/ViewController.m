//
//  ViewController.m
//  web4_(FMDBBaseUse 01)
//
//  Created by MS on 15-12-10.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"

@interface ViewController ()
{
    FMDatabase * _dataBase;//因为全局都要调用数据库，所以写成全局变量
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createButtons];
}

-(void)createButtons
{
    NSArray * array = @[@"创建数据库",@"建表",@"增加",@"查找",@"修改",@"删除"];
    for (int i = 0; i<6; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor lightGrayColor];
        button.frame = CGRectMake((self.view.frame.size.width-300)/2, i*(30+20)+100, 300, 30);
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

-(void)click:(UIButton *)button
{
    int x = (int)button.tag-100;
    switch (x) {
        case 0:
        {
            //创建数据库并打开
            
            //1.需要找到一个存放数据库的沙盒路径
            //数据库的名字要以.db结尾，并且名字不能是系统的关键字
            NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/guo.db"];
            
            //2.创建数据库
            _dataBase = [[FMDatabase alloc]initWithPath:path];
            
            //3.打开数据库
            if ([_dataBase open]) {
                NSLog(@"数据库创建并打开成功");
            }
        }
            break;
        case 1:
        {
            //创建表Sql语句支持
            
            //表名不能是关键字，而且需要重点注意的是<建表之前一定要确定表里的字段>
            //括号前面是确定表名，括号里面是确定表的字段和字段的属性以及字节  字符串固定表示varchar (256)    语句id integer primary key autoincrement含义以id为主键并自动递增
            //数据库存储的数据类型为二进制型，如果要存储图片之类的信息，需要转换成NSData类型的<NSData类型的数据 在表的字段的属性表现形式为blob>
            NSString * createTableSql = @"create table if not exists student (id integer primary key ,name varchar (256),age varchar (256))";
            
            //让数据库来操作sql语句
            if([_dataBase executeUpdate:createTableSql])
            {
                NSLog(@"表创建成功");
            }
        }
            break;
        case 2:
        {
            //插入数据
            NSString * insertSql = @"insert into student (name,age)values(?,?)";
            if([_dataBase executeUpdate:insertSql,@"郭",@"20"])
            {
                NSLog(@"数据插入成功");
            }
        }
            break;
        case 3:
        {
            //查找数据 （全部查找和精确查找）
            /*
             全部查找和条件查找
             */
            
            //全部查找
             NSString * selectSql = @"select *from student";
//            NSString * selectSql = @"select *from student where id=2";
            //FMResultSet 里面就装着查找回来的数据，相当于一个数组
            FMResultSet * set = [_dataBase executeQuery:selectSql];
            while ([set next]) {
                NSInteger i = [set intForColumn:@"id"];
                NSString * name = [set stringForColumn:@"name"];
                NSString * age = [set stringForColumn:@"age"];
                
                NSLog(@"id = %ld name = %@,age = %@",i,name,age);
            }
            
        }
            break;
        case 4:
        {
            //修改数据
            //修改student表里面的 id=2 的那条数据的name和age
            NSString * updateSql = @"update student set name = ?,age = ? where id = 3";
            if ([_dataBase executeUpdate:updateSql,@"喂,小芳",@"30"]) {
                NSLog(@"修改成功");
            }
        }
            break;
        case 5:
        {
            //删除数据(全部删除和精确删除<条件删除>)
            //全部删除表内的数据后，主键不会归零，还是按原来的顺序自然递增
            NSString * deleteSql = @"delete from student";
            if ([_dataBase executeUpdate:deleteSql]) {
                NSLog(@"删除成功");
            }

//            NSString * deleteSql = @"delete from student where name = '喂,小芳'";
//            if ([_dataBase executeUpdate:deleteSql]) {
//                NSLog(@"删除成功");
//            }
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
