//
//  QFRequestManager.m
//  web1_(QFRequestManager 04)
//
//  Created by zhulei on 15/12/7.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "QFRequestManager.h"

@implementation QFRequestManager
+(void)requestWithUrl:(NSString *)url IsCache:(BOOL)isCache FinishBlock:(void(^)(NSData *data))finishBlock FailedBlock:(void(^)(NSError *error))failedBlock{
  
    //做网络请求和缓存
    
    QFRequest *request = [[QFRequest alloc]init];
    
    request.url = url;
    
    request.isCache = isCache;
    
    request.finishBlock = finishBlock;
    
    request.failedBlock = failedBlock;
    
    [request startRequest];
    
}

@end
