//
//  FMDBManager.h
//  web4_(FMDBManager 02)
//
//  Created by zhulei on 15/12/10.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface FMDBManager : NSObject{
    
    FMDatabase *_dataBase;
}

+(instancetype)shareInstance;
/*!
 打开数据库
 */
-(void)open;

/*!
 关闭数据库
 */
-(void)close;

/*!
 插入数据的方法
 */

-(void)insertDataWithName:(NSString *)name PassWord:(NSString *)passWord;

/*!
 查找数据库表里的所有数据,并以数组的形式返回,然后把该数组作为tableview 的数据源
 */

-(NSMutableArray *)select;

/*!
 删除数据
 */
-(void)deleteWithName:(NSString *)name;
/*!
 修改数据,把textField里面最新的text更新到数据库里
 */
-(void)updateDataWithName:(NSString *)name Age:(NSString *)age LastName:(NSString *)lastName;

@end
