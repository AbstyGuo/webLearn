//
//  ActiveController.m
//  GYF_TBLX
//
//  Created by MS on 15-12-25.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "ActiveController.h"
#import "AFNetworking.h"
#import "HeaderView.h"
#import "ActiveCell.h"
#import "FMDBManager.h"
#import "MJRefresh.h"
#define URL @"http://tubu.ibuzhai.com/rest/v3/activity/hot?&app_version=4.2.0&page_size=20&api_version=1&page=%ld&device_type=2"

@interface ActiveController ()<UITableViewDataSource,UITableViewDelegate,HeaderDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _dataArray;
    NSInteger _page;
    BOOL _isPulling;
}

@end

@implementation ActiveController

- (void)viewDidLoad {
    _dataArray = [[NSMutableArray alloc]init];
    _isPulling = NO;
    _page = 1;
    [super viewDidLoad];
    [self setNavgationBar];
    [self createTableView];
    [self readData];
    [self createRefresh];
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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

-(void)readData{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * dic = @{@"mobile":texfield.text,@"password":text};
    
    [manager POST:[NSString stringWithFormat:@"%@/%@",baseurl,@"world"] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSDictionary * rootDic = [NSJSONSerialization ]
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
    [manager GET:[NSString stringWithFormat:URL,_page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

-(void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 200;
    [self.view addSubview: _tableView];
}

-(void)setNavgationBar{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_actionbar_320x64.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"活动";
    self.navigationController.navigationBar.titleTextAttributes =@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    UIImage * rightImage = [[UIImage imageNamed:@"icon_actionbar_search_44x44"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:rightImage style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    label.text = @"全国";
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textColor = [UIColor whiteColor];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(40,0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"icon_downarrow_15x15.png"] forState:UIControlStateNormal];
    [leftView addSubview:label];
    [leftView addSubview:button];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark - tableView协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActiveCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[ActiveCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    if(_dataArray.count > 0){
        [cell setContentWithDic:_dataArray[indexPath.row]];
    }

    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        HeaderView * headView = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 330)];
        headView.delegate = self;
        return headView;
    }else{
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 25)];
        view.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:235/255.f alpha:1];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10,0, self.view.frame.size.width-20, 24)];
        label.text = @"  热门活动";
        label.backgroundColor = [UIColor whiteColor];
        [view addSubview:label];
        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 330;
    }else{
        return 25;
    }
}

-(void)pushController:(UIViewController *)controller
{
    [self.navigationController pushViewController:controller animated:YES];
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
