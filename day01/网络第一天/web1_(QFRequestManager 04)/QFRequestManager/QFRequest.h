//
//  QFRequest.h
//  web1_(QFRequestManager 04)
//
//  Created by zhulei on 15/12/7.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QFRequest : NSObject

@property (nonatomic,copy)NSString *url;

@property (nonatomic,assign)BOOL isCache;

@property (nonatomic,copy)void(^finishBlock)(NSData *);

@property (nonatomic,copy)void(^failedBlock)(NSError *);

-(void)startRequest;
@end
