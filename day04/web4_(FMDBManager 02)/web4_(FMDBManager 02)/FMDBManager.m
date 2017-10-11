//
//  FMDBManager.m
//  web4_(FMDBManager 02)
//
//  Created by MS on 15-12-10.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "FMDBManager.h"
#import "FMDatabase.h"
#import "StudentModel.h"

@implementation FMDBManager
{
    FMDatabase * _dataBase;
}

+(instancetype)shareInstance{
    //下面的代码写法是固定的
    //1、用本类先生成一个对象
    static FMDBManager * manager;
    //2、在一个静态的block里实例化对象
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FMDBManager alloc]init];
    });
    return manager;
}

-(void)close
{
    if([_dataBase close]){
        NSLog(@"程序退出，数据库关闭");
    };
}

-(void)open
{
    [_dataBase open];
    //只要数据库打开了，把表建好
    NSString * createTableSql = @"create table if not exists student(id integer primary key autoincrement ,name varchar(256),age varchar(256))";
    if ([_dataBase executeUpdate:createTableSql]) {
        NSLog(@"表创建成功");
    }
}

-(instancetype)init
{
    if (self = [super init]) {
        //来实例化该类的一些属性和全局变量
        _dataBase = [[FMDatabase alloc]initWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/guo.db"]];
    }
    return self;
}

-(void)insertDataWithName:(NSString *)name PassWord:(NSString *)passWord
{
    NSString * insertSql = @"insert into student (name,age) values(?,?)";
    if([_dataBase executeUpdate:insertSql,name,passWord])
    {
        NSLog(@"数据保存成功");
    }
}

-(NSMutableArray *)select
{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    NSString * selectSql = @"select *from student";
    FMResultSet * set = [_dataBase executeQuery:selectSql];
    
    while ([set next]) {
        StudentModel * stu = [[StudentModel alloc]init];
        stu.name = [set stringForColumn:@"name"];
        stu.age = [set stringForColumn:@"age"];
        [array addObject:stu];
    }
    
    return array;
}

-(void)deleteWithName:(NSString *)name
{
    NSString * deleteSql = @"delete from student where name = ?";
    if ([_dataBase executeUpdate:deleteSql,name]) {
        NSLog(@"删除成功");
    }
}

-(void)updateDateWithName:(NSString *)name Age:(NSString *)age LastName:(NSString *)lastName
{
    NSString * updateSql = @"update student set name = ?,age = ? where name = ?";
    if ([_dataBase executeUpdate:updateSql,name,age,lastName]) {
        NSLog(@"数据修改成功");
    }
}

@end
