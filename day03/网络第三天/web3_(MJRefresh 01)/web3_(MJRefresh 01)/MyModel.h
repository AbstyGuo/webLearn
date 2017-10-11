//
//  MyModel.h
//  web3_(MJRefresh 01)
//
//  Created by zhulei on 15/12/9.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyModel : NSObject
//M里面的属性,要依据V里面的控件所需要的数据来拟订<属性命名要依据接口返回来的数据的key来命名>
//如果model里面的属性和系统的关键字冲突了,那么解决办法就是在model.m里面写上<例子如下>
//@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *iconUrl;//<V里面的IconView所需要的数据>

@property (nonatomic,copy)NSString *name;//<V里面的nameLabel需要的数据>

@property (nonatomic,copy)NSString *applicationId;//<V里面的IdLabel需要的数据>

@end
