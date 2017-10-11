//
//  UpdateViewController.m
//  web4_(FMDBManager 02)
//
//  Created by zhulei on 15/12/10.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "UpdateViewController.h"
#import "FMDBManager.h"
@interface UpdateViewController (){
    
    UITextField *_nameField;
    
    UITextField *_passWordField;
}


@end

@implementation UpdateViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self creatUI];
    
}
-(void)creatUI{
    
    _nameField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, 150, 300, 40)];
    
    _nameField.borderStyle = UITextBorderStyleRoundedRect;
   
    _nameField.text = self.student.name;
    
    [self.view addSubview:_nameField];
    
    _passWordField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, 220, 300, 40)];
    
    _passWordField.borderStyle = UITextBorderStyleRoundedRect;
  
    
    _passWordField.text = self.student.age;
    
    [self.view addSubview:_passWordField];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    loginBtn.frame = CGRectMake((self.view.frame.size.width - 300)/2, 280, 300, 40);
    
    [loginBtn setTitle:@"修改完成" forState:UIControlStateNormal];
    
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginBtn];
    
}
-(void)login{
    
    //修改数据 并返回上一页
    
    [[FMDBManager shareInstance]updateDataWithName:_nameField.text Age:_passWordField.text LastName:self.student.name];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
