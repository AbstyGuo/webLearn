//
//  LeftTableViewController.m
//  web7_(IPD-UISplitController)
//
//  Created by zhulei on 15/12/15.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "LeftTableViewController.h"

@interface LeftTableViewController ()

@end

@implementation LeftTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"左视图";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
   
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate changeTextWithIndexPath:indexPath];
}

@end
