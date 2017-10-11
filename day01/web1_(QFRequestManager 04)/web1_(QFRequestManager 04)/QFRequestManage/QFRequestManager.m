//
//  QFRequestManager.m
//  web1_(QFRequestManager 04)
//
//  Created by MS on 15-12-7.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "QFRequestManager.h"


@implementation QFRequestManager

+(void)requestWithUrl:(NSString *)url IsCache:(BOOL)isCache FinishBlock:(void (^)(NSData *))finishBlock FailedBlock:(void (^)(NSError *))failedBlock
{
    //做网络请求和缓存
    QFRequest * request = [[QFRequest alloc]init];
    request.url = url;
    request.isCache = isCache;
    request.finishBlock = finishBlock;
    request.faildBlock = failedBlock;
    
    [request startRequest];
}

@end
