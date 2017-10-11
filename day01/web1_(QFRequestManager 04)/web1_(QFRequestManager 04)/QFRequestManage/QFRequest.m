//
//  QFRequest.m
//  web1_(QFRequestManager 04)
//
//  Created by MS on 15-12-7.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "QFRequest.h"
#import "NSString+Hashing.h"

@implementation QFRequest

-(void)startRequest
{
    //是否使用缓存
    //使用缓存
    if (_isCache) {
        //找到缓存路径
        NSString * path = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/%@",[_url MD5Hash]];
        
        NSFileManager * manager = [NSFileManager defaultManager];
        //如果缓存目录下有数据，那么取出来 并传给block
        if ([manager fileExistsAtPath:path]) {
            NSData * data = [NSData dataWithContentsOfFile:path];
            _finishBlock(data);
            return;
        }
    }
    //如果不使用缓存，那么就要进行网络请求了
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //做缓存
        if (self.isCache) {
             NSString * path = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/%@",[_url MD5Hash]];
            [data writeToFile:path atomically:YES];
        }
        _finishBlock(data);
        _faildBlock(error);
    }];
    [task resume];
}

@end
