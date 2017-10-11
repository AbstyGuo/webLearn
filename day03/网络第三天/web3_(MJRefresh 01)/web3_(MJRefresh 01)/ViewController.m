//
//  ViewController.m
//  web3_(MJRefresh 01)
//
//  Created by zhulei on 15/12/9.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MyTableViewCell.h"
#import "MyModel.h"
#import "MJRefresh.h"
#define REQUESTURL @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=%ld"
@interface ViewController (){
    
    UITableView *_tableView;
    
    NSMutableArray *_dataArray;
    
    NSInteger _page;//用来操控接口里面的page参数
    
    
    BOOL _isPulling;//用来判断当前的刷新状态是下拉还是上拉加载,如果是下拉,清空数据源
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isPulling = NO;
    //数据源的初始化<如果做刷新功能,那么数据源的初始化一定不能写在请求数据的方法里面>
    _dataArray = [[NSMutableArray alloc]init];

    _page = 1;
    
    [self creatTableView];
    
    [self creatData];
    
    [self creatRefresh];
}

//给tableview加上下拉刷新和上拉加载更多的UI效果
-(void)creatRefresh{
    
    //给tableview的头 添加一个刷新UI效果和刷新要执行的方法
    [_tableView addHeaderWithTarget:self action:@selector(pullRrefresh)];
    
    [_tableView addFooterWithTarget:self action:@selector(pushRefresh)];
}
-(void)pullRrefresh{
    
    NSLog(@"下啦刷新");
   
    _isPulling = YES;
    //重新请求一遍第一页的数据
    _page = 1;

    [self creatData];
    
}
-(void)pushRefresh{
    
    _isPulling = NO;
    
    _page ++;
    
    [self creatData];
}
-(void)creatTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
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
   
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}
-(void)creatData{
    
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

//            model.iconUrl = [dic objectForKey:@"iconUrl"];
//            
//            model.name = [dic objectForKey:@"name"];
//            
//            model.applicationId = [dic objectForKey:@"applicationId"];
            
           //如果采用这种给model赋值的方法,那么就要去model.m里实现一个方法
            [model setValuesForKeysWithDictionary:dic];
            
            
            
            [_dataArray addObject:model];
        }
        
        
        if (_isPulling == YES) {
            
            //请求完数据后,结束头部刷新的UI效果
            [_tableView headerEndRefreshing];

        }else{
            //请求完数据后,结束尾部刷新的UI效果
            [_tableView footerEndRefreshing];
        }
        [_tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
