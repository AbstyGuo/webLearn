//
//  ViewController.m
//  web3_(YCRefresh 03)
//
//  Created by zhulei on 15/12/9.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MyModel.h"
#import "MyTableViewCell.h"
#import "YCRefreshControl.h"//做刷新和加载用的头文件
#define REQUESTURL @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=%ld"
@interface ViewController (){
    
    
    UITableView *_tableView;
    
    NSMutableArray *_dataArray;
    
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
    
    [self creatTableView];
    
    [self creatData];
}
-(void)creatData{
    
    
    NSLog(@"%ld",_page);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:REQUESTURL,_page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSArray *array = [rootDic objectForKey:@"applications"];
        
        if (_isPulling == YES) {
            
            [_dataArray removeAllObjects];
        }
        
        for (NSDictionary *dic in array) {
            
            MyModel *model = [[MyModel alloc]init];
            
            model.iconUrl = [dic objectForKey:@"iconUrl"];
            
            model.name = [dic objectForKey:@"name"];
            
            model.applicationId = [dic objectForKey:@"applicationId"];
            
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
-(void)creatTableView{
    
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    _tableView.delegate =self;
    
    _tableView.dataSource = self;
    
    [_tableView yc_setRefreshAction:^{
     //刷新Block
        NSLog(@"刷新");
        
        _isPulling = YES;
        
        _page = 1;
        
        [self creatData];
        
    }];
    
    [_tableView yc_setLoadmoreAction:^{
     //上拉加载更多block
        NSLog(@"加载");
        
        
        _isPulling = NO;
        
        _page ++;
        
        [self creatData];
   
    }];
    
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    if (!cell) {
        
        cell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    
    
        MyModel *model = _dataArray[indexPath.row];
        
        [cell configCellWithModel:model];
   
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
