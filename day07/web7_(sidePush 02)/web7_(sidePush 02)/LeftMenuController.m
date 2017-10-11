//
//  LeftMenuController.m
//  web7_(sidePush 02)
//
//  Created by MS on 15-12-15.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "LeftMenuController.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface LeftMenuController ()
{
    NSMutableArray * _dataArray;
    AppDelegate * _delegate;
}
@end

@implementation LeftMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    _delegate = [UIApplication sharedApplication].delegate;
    _dataArray = [NSMutableArray arrayWithObjects:@"我的钱包",@"我的会员",@"扫一扫",@"设置", nil];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    cell.textLabel.text = _dataArray [indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //先会到原位
    [_delegate.DDController hideSideViewController:YES];
    
//    //点击cell先从left回到main，再从main跳到viewController里
//    [_delegate.DDController setRootViewController:_delegate.myNav];
    
    ViewController * vc = [[ViewController alloc]init];
    
    [_delegate.myNav pushViewController:vc animated:YES];
}

@end
