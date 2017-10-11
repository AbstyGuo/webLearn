//
//  RightTableViewController.m
//  web7_(IPD-UISplitController)
//
//  Created by zhulei on 15/12/15.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "RightTableViewController.h"
@interface RightTableViewController (){
    
    //系统气泡<需要填充一个具体的选项内容>
    UIPopoverController *_popOver;
    
    NSString *_text;//全局的text 用来接收代理方法传过来的indexpath  并赋给当前页面的cell
}

@end

@implementation RightTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"右视图";
    
    [self creatRightTabbarItem];
    
    [self creatPopOver];
}
-(void)creatPopOver{
    
    //先实例化气泡的内容
    MyPopOverContentController *myPop = [[MyPopOverContentController alloc]init];
    
    myPop.delegate = self;
    
    //实例化气泡 并把气泡的内容视图存放进来
    _popOver = [[UIPopoverController alloc]initWithContentViewController:myPop];
    
    //设置气泡的实际大小<要根据内容来决定>
    
    [_popOver setPopoverContentSize:CGSizeMake(100, 132)];
    
}
-(void)changeTextWithIndexPath:(NSIndexPath *)indexPath{
    
    _text = [NSString stringWithFormat:@"%d",indexPath.row];
    
    //在获取到新数据的时候 tableview 要重新加载数据
    [self.tableView reloadData];
    
}
-(void)changeTextWithIndexPathRow:(NSIndexPath *)indexPath{
    
    _text = [NSString stringWithFormat:@"%d",indexPath.row];
    
    //在获取到新数据的时候 tableview 要重新加载数据
    [self.tableView reloadData];
}
-(void)creatRightTabbarItem{
 //创建导航栏右侧的按钮
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"pop" style:UIBarButtonItemStylePlain target:self action:@selector(click:)];
    
    self.navigationItem.rightBarButtonItem = right;
    
}
-(void)click:(UIBarButtonItem *)item{
   
    //按钮的点击事件儿<把选项框弹出来>
    
    //箭头方向永远和 气泡的弹出方向是相反的
    [_popOver presentPopoverFromBarButtonItem:item permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
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
    
    if(!cell){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    
    
    cell.textLabel.text = _text;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
