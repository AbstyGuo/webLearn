//
//  MyController.m
//  GYF_TBLX
//
//  Created by MS on 15-12-25.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "MyController.h"
#import "FMDBManager.h"
#import "BaseModel.h"
#import "UIImageView+WebCache.h"

@interface MyController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _dataArray;
}

@end

@implementation MyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self readData];
}

-(void)readData{
    _dataArray = [[FMDBManager shareInstance] select];
    [_tableView reloadData];
}

-(void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80;
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
    }
    BaseModel * model = _dataArray[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    cell.textLabel.text = model.name;
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseModel * model = _dataArray[indexPath.row];
    [[FMDBManager shareInstance]deleteWithAppId:model.applicationId];
    [self readData];
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
