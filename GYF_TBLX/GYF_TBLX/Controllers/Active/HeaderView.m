//
//  HeaderView.m
//  GYF_TBLX
//
//  Created by MS on 15-12-25.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "HeaderView.h"
#import "ZLScrollView.h"
#import "AFNetworking.h"
#import "DetailController.h"

@implementation HeaderView
{
    CGFloat _wide;
    NSMutableArray * _dataArray;
    UIView * _scrollView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _wide = [UIScreen mainScreen].bounds.size.width;
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
        [self readData];
    }
    return self;
}

-(void)readData{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://tubu.ibuzhai.com/rest/v3/advertisements?&position=%2C1&object_type=&app_version=4.2.0&api_version=1&device_type=2&destination=0" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray * array = [rootDic objectForKey:@"advertisements"];
        NSMutableArray * scrollArray = [[NSMutableArray alloc]init];
        for (NSDictionary * dic in array) {
            NSString * url = [dic objectForKey:@"share_pic"];
            [scrollArray addObject:url];
        }
        [self setScrollViewWithArray:scrollArray];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    

}

-(void)setScrollViewWithArray:(NSArray *)array{
    ZLScrollView * zl = [[ZLScrollView alloc]initWithFrame:CGRectMake(0, 0, _wide, 154)];
    [zl addImageArrayWithArray:array IsFromWeb:YES PlaceHolderImage:nil];
    [_scrollView addSubview:zl];    
}

-(void)createUI{
    _scrollView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _wide, 154)];
    MyButtons * myButtons = [[MyButtons alloc]initWithFrame:CGRectMake(0, 154, _wide,176)];
    myButtons.delegate = self;
    [self addSubview:_scrollView];
    [self addSubview:myButtons];
}

//    全部
#define QUANBU @"http://tubu.ibuzhai.com/rest/v3/activities?&page_size=20&cur_page=%ld&sort=0&keywords=&device_type=2&app_version=4.2.0&is_recent=0&api_version=1"
//    周末
#define ZHOUME @"http://tubu.ibuzhai.com/rest/v3/activities?&page_size=20&cur_page=%ld&sort=0&keywords=%E5%91%A8%E6%9C%AB&device_type=2&app_version=4.2.0&is_recent=0&api_version=1"
//    长线
#define CHANG @"http://tubu.ibuzhai.com/rest/v3/activities?&page_size=20&cur_page=%ld&sort=0&keywords=%E9%95%BF%E7%BA%BF&device_type=2&app_version=4.2.0&is_recent=0&api_version=1"
//    摄影
#define SHE @"http://tubu.ibuzhai.com/rest/v3/activities?&page_size=20&cur_page=%ld&sort=0&keywords=%E6%91%84%E5%BD%B1&device_type=2&app_version=4.2.0&is_recent=0&api_version=1"
//    入门
#define RUMEN @"http://tubu.ibuzhai.com/rest/v3/activities?&page_size=20&cur_page=%ld&sort=0&keywords=%E5%85%A5%E9%97%A8&device_type=2&app_version=4.2.0&is_recent=0&api_version=1"
//    进阶
#define JINJIE @"http://tubu.ibuzhai.com/rest/v3/activities?&page_size=20&cur_page=%ld&sort=0&keywords=%E8%BF%9B%E9%98%B6&device_type=2&app_version=4.2.0&is_recent=0&api_version=1"
//    露营
#define LUYIN @"http://tubu.ibuzhai.com/rest/v3/activities?&page_size=20&cur_page=%ld&sort=0&keywords=%E6%BA%AF%E6%BA%AA&device_type=2&app_version=4.2.0&is_recent=0&api_version=1"
//    亲子
#define QINZI @"http://tubu.ibuzhai.com/rest/v3/activities?&page_size=20&cur_page=%ld&sort=0&keywords=%E4%BA%B2%E5%AD%90&device_type=2&app_version=4.2.0&is_recent=0&api_version=1"

-(void)clickButtonWithButtonTag:(NSInteger)tag{
    NSArray * titleArray = @[@"全部",@"周末",@"长线",@"摄影",@"入门",@"进阶",@"露营",@"亲子"];
//    NSArray * urlArray = @[QUANBU,ZHOUME,CHANG,SHE,RUMEN,JINJIE,LUYIN,QINZI];
    DetailController * detail = [[DetailController alloc]init];
    detail.name = titleArray[tag-100];
    detail.url = QUANBU;
    
    [_delegate pushController:detail];
}


@end
