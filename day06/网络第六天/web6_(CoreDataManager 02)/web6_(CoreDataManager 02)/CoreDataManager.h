//
//  CoreDataManager.h
//  web6_(CoreDataManager 02)
//
//  Created by zhulei on 15/12/14.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Student.h"
#import "AppDelegate.h"
@interface CoreDataManager : NSObject

+(instancetype)zhulei;

/*!
 增加数据的方法
 */
-(void)insertDataWithImageData:(NSData *)imageData Name:(NSString *)name PhoneNum:(NSString *)number;

/*!
 返回数组的方法,并以这个数组作为下一页的数据源
 */
-(NSArray *)fetch;

/*!
 删除数据的方法
 */

-(void)deleteModelWithModel:(Student *)student;

-(void)update:(Student *)student;
@end
