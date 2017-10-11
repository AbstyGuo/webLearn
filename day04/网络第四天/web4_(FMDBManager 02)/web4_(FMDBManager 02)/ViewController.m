//
//  ViewController.m
//  web4_(FMDBManager 02)
//
//  Created by zhulei on 15/12/10.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "ViewController.h"
#import "FMDBManager.h"
#import "SecondViewController.h"
@interface ViewController (){
    
    UITextField *_nameField;
    
    UITextField *_passWordField;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    [self creatUI];
    
}
-(void)creatUI{
    
    _nameField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, 150, 300, 40)];
    
    _nameField.borderStyle = UITextBorderStyleRoundedRect;
    
    _nameField.placeholder = @"请输入用户名";
    
    [self.view addSubview:_nameField];
    
    _passWordField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, 220, 300, 40)];
    
    _passWordField.borderStyle = UITextBorderStyleRoundedRect;
    _passWordField.secureTextEntry = YES;
    
    _passWordField.placeholder = @"请输入密码";
    
    [self.view addSubview:_passWordField];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    loginBtn.frame = CGRectMake((self.view.frame.size.width - 300)/2, 280, 300, 40);
    
    [loginBtn setTitle:@"保 存" forState:UIControlStateNormal];
    
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginBtn];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    registerBtn.frame = CGRectMake((self.view.frame.size.width - 300)/2, 330, 300, 40);
    
    [registerBtn setTitle:@"下一页" forState:UIControlStateNormal];
    
    [registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:registerBtn];
}
-(void)login{
   
    //保存数据
   
    [[FMDBManager shareInstance]insertDataWithName:_nameField.text PassWord:_passWordField.text];

    
}
-(void)registerClick{
    //跳转到下级页面查看保存的数据
  
    SecondViewController *second = [[SecondViewController alloc]init];
    
    [self.navigationController pushViewController:second animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
