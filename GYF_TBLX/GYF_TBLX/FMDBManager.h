//
//  FMDBManager.h
//  LoveLimit
//
//  Created by MS on 15-12-22.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface FMDBManager : NSObject{
    FMDatabase * _dataBase;
}

+(instancetype)shareInstance;


-(void)insertDataWithAppId:(NSString *)appId IconUrl:(NSString *)iconUrl Name:(NSString *)name;


-(void)deleteWithAppId:(NSString *)appId;


-(NSMutableArray *)select;

-(BOOL)selectWithAppId:(NSString *)appId;

@end
