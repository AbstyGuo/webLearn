//
//  MyPopOverContentController.m
//  web7_(IPD-UISplitController)
//
//  Created by zhulei on 15/12/15.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "MyPopOverContentController.h"

@interface MyPopOverContentController ()

@end

@implementation MyPopOverContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
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
    
    //点击cell的时候 调用代理方法 给参数传值
    
    [self.delegate changeTextWithIndexPathRow:indexPath];
}

@end
