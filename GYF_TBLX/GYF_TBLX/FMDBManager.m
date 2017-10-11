//
//  FMDBManager.m
//  LoveLimit
//
//  Created by MS on 15-12-22.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "FMDBManager.h"
#import "BaseModel.h"

@implementation FMDBManager

+(instancetype)shareInstance{
    static FMDBManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FMDBManager alloc]init];
    });
    return manager;
}

-(instancetype)init{
    if (self = [super init]) {
        NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TULX.db"];
        _dataBase = [[FMDatabase alloc]initWithPath:path];
        [_dataBase open];
        
        
        NSString * createTableSql = @"create table if not exists tulx(id integer primary key autoincrement,appid varchar(256),iconurl varchar(256),name varchar(256))";
        if([_dataBase executeUpdate:createTableSql]){
        }
    }
    return self;
}

-(void)insertDataWithAppId:(NSString *)appId IconUrl:(NSString *)iconUrl Name:(NSString *)name
{
    NSString * insertSql = @"insert into tulx (appid,iconurl,name)values(?,?,?)";
    if ([_dataBase executeUpdate:insertSql,appId,iconUrl,name]) {
        NSLog(@"收藏成功");
    }
}

-(void)deleteWithAppId:(NSString *)appId
{
    NSString * deleteSql = @"delete from tulx where appid = ?";
    if ([_dataBase executeUpdate:deleteSql,appId]) {
        NSLog(@"取消收藏成功");
    }
}

-(NSMutableArray *)select{
    NSString * selectSql = @"select * from tulx";
    NSMutableArray * array = [[NSMutableArray alloc]init];
    FMResultSet * set = [_dataBase executeQuery:selectSql];
    while ([set next]) {
        BaseModel * model = [[BaseModel alloc]init];
        model.applicationId = [set stringForColumn:@"appid"];
        model.iconUrl = [set stringForColumn:@"iconurl"];
        model.name = [set stringForColumn:@"name"];
        [array addObject:model];
    }
    return array;
}

-(BOOL)selectWithAppId:(NSString *)appId
{
    NSString * selectSql = @"select * from tulx where appid = ?";
    FMResultSet * set = [_dataBase executeQuery:selectSql,appId];
    while ([set next]) {
        return YES;
    }
    return NO;
}

@end
