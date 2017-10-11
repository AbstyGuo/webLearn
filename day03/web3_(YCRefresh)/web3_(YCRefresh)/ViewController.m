//
//  ViewController.m
//  web3_(YCRefresh)
//
//  Created by MS on 15-12-9.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "ViewController.h"
#import "YCRefreshControl.h"//做刷新和加载用的头文件
#import "AFNetworking.h"
#import "MyModel.h"
#import "MyTableViewCell.h"
#define REQUESTURL @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=%ld"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _dataArray;
    NSInteger _page;//用来控制接口的page参数
    BOOL _isPulling;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isPulling = NO;
    _page = 1;
    _dataArray = [[NSMutableArray alloc]init];
    [self createTableView];
    [self createData];
}

-(void)createData
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:REQUESTURL,_page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray * array = rootDic[@"applications"];
        if (_isPulling == YES) {
            [_dataArray removeAllObjects];
        }
        for (NSDictionary * dic in array) {
            MyModel * model = [[MyModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        if (_isPulling == YES) {
            [_tableView yc_endRefresh];
        }else{
            [_tableView yc_endLoadmore];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 90;
    [_tableView yc_setRefreshAction:^{
        //刷新block
        _isPulling = YES;
        _page = 1;
        [self createData];
        
    }];
    [_tableView yc_setLoadmoreAction:^{
        //加载更多block
        _isPulling = NO;
        _page++;
        [self createData];
    }];
    
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    MyModel * model = _dataArray[indexPath.row];
    [cell configCellWithModel:model];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
