//
//  NextViewController.m
//  web6_(CoreDataManager 02)
//
//  Created by zhulei on 15/12/14.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "NextViewController.h"
#import "CoreDataManager.h"
#import "UpdateViewController.h"
@interface NextViewController (){
    
    NSMutableArray *_dataArray;
    
    UITableView *_tableView;
}

@end

@implementation NextViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSArray *array = [[CoreDataManager zhulei]fetch];
    
    _dataArray = [NSMutableArray arrayWithArray:array];
    
    [_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
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
    
    
    Student *student = _dataArray [indexPath.row];
    
    //先把二进制图片转换成image
    cell.imageView.image = [UIImage imageWithData:student.headImageData];
    
    cell.textLabel.text = student.name;
    
    cell.detailTextLabel.text = student.phoneNum;
    return cell;

}

//滑动删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*
     1.删除数据库对应的模型
     2.删除数据源对应的模型
     3.删除cell
     */
    
    Student *student = _dataArray[indexPath.row];
    
    [[CoreDataManager zhulei]deleteModelWithModel:student];
    
    [_dataArray removeObject:student];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UpdateViewController *update =[[UpdateViewController alloc]init];
    
    update.student = _dataArray[indexPath.row];
    
    [self.navigationController pushViewController:update animated:YES];
}
@end
