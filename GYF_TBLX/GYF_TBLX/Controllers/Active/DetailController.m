//
//  DetailController.m
//  GYF_TBLX
//
//  Created by MS on 15-12-25.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "DetailController.h"
#import "ActiveCell.h"
#import "AFNetworking.h"
#import "MJRefresh.h"

@interface DetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _dataArray;
    UISearchBar * _searchBar;
    BOOL _isPulling;
    NSInteger _page;
    UIButton * _canclBtn;
    UIView * _viewBar;
}

@end

@implementation DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _isPulling = NO;
    _page = 1;
    _viewBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    _viewBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_actionbar_320x64.png"]];
    [self.view addSubview:_viewBar];
    
    [self createTabelView];
    [self readData];
    [self createRefresh];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    _searchBar= [[UISearchBar alloc]initWithFrame:CGRectMake(20,25, self.view.frame.size.width-100, 30)];
    _canclBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 30, 40, 20)];
    [_canclBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_canclBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_canclBtn addTarget:self action:@selector(backtoSuper) forControlEvents:UIControlEventTouchUpInside];
    _searchBar.text = _name;

    [_viewBar addSubview:_searchBar];
    [_viewBar addSubview:_canclBtn];
    

}

-(void)backtoSuper{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createRefresh
{
    [_tableView addHeaderWithTarget:self action:@selector(pullRefresh)];
    [_tableView addFooterWithTarget:self action:@selector(pushRefresh)];
}

-(void)pushRefresh
{
    _isPulling = NO;
    _page++;
    [self readData];
}

-(void)pullRefresh
{
    _isPulling = YES;
    _page = 1;
    [self readData];
}

-(void)readData{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:_url,_page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray * array = [rootDic objectForKey:@"activities"];

        if (_isPulling == YES) {
            [_dataArray removeAllObjects];
        }
        for (NSDictionary * dic in array) {
            [_dataArray addObject:dic];
        }
        if (_isPulling ==YES) {
            [_tableView headerEndRefreshing];
        }else{
            [_tableView footerEndRefreshing];
        }
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



-(void)createTabelView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 200;
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActiveCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[ActiveCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    if(_dataArray.count > 0){
        [cell setContentWithDic:_dataArray[indexPath.row]];
    }
    
    return cell;

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
