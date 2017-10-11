//
//  SecondViewController.m
//  web4_(FMDBManager 02)
//
//  Created by zhulei on 15/12/10.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "SecondViewController.h"
#import "FMDBManager.h"
#import "Student.h"
#import "UpdateViewController.h"
@interface SecondViewController (){
    
    UITableView *_tableView;
    
    NSMutableArray *_dataArray;
}

@end


@implementation SecondViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //每次进入界面的时候,都重新获取数据
    
    _dataArray = [[FMDBManager shareInstance]select];
  
    [_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
   
    [self creatTableView];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
    }
    
    Student *student = _dataArray[indexPath.row];
    
    cell.textLabel.text = student.name;
    
    cell.detailTextLabel.text = student.age;
    
    return cell;
}
//tableview删除操作
//1.确定编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}
//2执行具体的操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*
     1.删除数据库
     2.删除数据源
     3.删除cell
     */
    
    
    //先获取到编辑的该行对应的model
    
    Student *student = _dataArray[indexPath.row];
    //1.
    [[FMDBManager shareInstance]deleteWithName:student.name];
    
    //2.
    [_dataArray removeObject:student];
    
    //3.
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"移除购物车";
}
//点击行进入编辑页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    UpdateViewController *upDate = [[UpdateViewController alloc]init];
    
    upDate.student = _dataArray[indexPath.row];
    
    [self.navigationController pushViewController:upDate animated:YES];
    
}
@end
