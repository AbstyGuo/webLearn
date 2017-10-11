//
//  QFRequestManager.h
//  web1_(QFRequestManager 04)
//
//  Created by zhulei on 15/12/7.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QFRequest.h"
@interface QFRequestManager : NSObject
/*!
 网络请求
 url 接口网址
 isCache 是否做缓存
 finishblock 数据请求完成后回来的data
 failedblock 数据请求失败返回的错误原因
 */
+(void)requestWithUrl:(NSString *)url IsCache:(BOOL)isCache FinishBlock:(void(^)(NSData *data))finishBlock FailedBlock:(void(^)(NSError *error))failedBlock;
@end
