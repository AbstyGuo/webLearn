//
//  FMDBManager.h
//  web4_(FMDBManager 02)
//
//  Created by MS on 15-12-10.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBManager : NSObject


+(instancetype)shareInstance;

//打开和关闭数据库
-(void)open;
-(void)close;

//插入数据的方法
-(void)insertDataWithName:(NSString *)name PassWord:(NSString *)passWord;

//查找数据库里的所有数据，并以数组的形式返回，然后把该数组作为tableView的数据源
-(NSMutableArray *)select;

//删除数据
-(void)deleteWithName:(NSString *)name;

//修改数据，把textfield里面最新的text更新到数据库里
-(void)updateDateWithName:(NSString *)name Age:(NSString *)age LastName:(NSString *)lastName;

@end
