//
//  SecondViewController.m
//  web4_(FMDBManager 02)
//
//  Created by MS on 15-12-10.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "SecondViewController.h"
#import "FMDBManager.h"
#import "StudentModel.h"
#import "UpdateViewController.h"

@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _dataArray;
}
@end

@implementation SecondViewController

-(void)viewWillAppear:(BOOL)animated
{
    //每次进入界面的时候，都重新获取数据
    [super viewWillAppear:animated];
    _dataArray = [[FMDBManager shareInstance]select];
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    [self createTableView];
}

-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"student"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"student"];
    }
    StudentModel * stu = _dataArray[indexPath.row];
    cell.textLabel.text = stu.name;
    cell.detailTextLabel.text = stu.age;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UpdateViewController * uvc = [[UpdateViewController alloc]init];
    StudentModel * stu = _dataArray[indexPath.row];
    uvc.nameText = stu.name;
    uvc.passWordText = stu.age;
    [self.navigationController pushViewController:uvc animated:YES];
}

//tableView操作
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//确定编辑操作
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//执行具体的操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     1、删除数据库
     2、删除数据源
     3、删除cell
     */
    
    //先获取到编辑的该行对应的model
    StudentModel * stu = _dataArray[indexPath.row];
    //1、
    [[FMDBManager shareInstance]deleteWithName:stu.name];
    //2、
    [_dataArray removeObject:stu];
    //3、
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
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
