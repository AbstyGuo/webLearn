//
//  ViewController.m
//  web4_(FMDBManager 02)
//
//  Created by MS on 15-12-10.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "ViewController.h"
#import "FMDBManager.h"
#import "SecondViewController.h"

@interface ViewController ()
{
    UITextField * _nameField;
    UITextField * _passWord;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)createUI
{
    self.view.backgroundColor = [UIColor orangeColor];
    _nameField = [[UITextField alloc]initWithFrame:CGRectMake(120, 130, self.view.frame.size.width-150, 30)];
    _nameField.placeholder =@"请输入用户名";
    
    _nameField.borderStyle = UITextBorderStyleRoundedRect;
    _passWord = [[UITextField alloc]initWithFrame:CGRectMake(120, 180, self.view.frame.size.width-150, 30)];
    _passWord.borderStyle = UITextBorderStyleRoundedRect;
    _passWord.placeholder =@"请输入密码";
    _passWord.secureTextEntry = YES;
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(50,130, 60, 30)];
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(50, 180, 60, 30)];
    label1.text =@"用户名";
    label2.text = @"密码";
    
    UIButton * button1 = [[UIButton alloc]initWithFrame:CGRectMake(120, 250, 60, 30)];
    button1.tag = 20;
    UIButton * button2 = [[UIButton alloc]initWithFrame:CGRectMake(220, 250, 60, 30)];
    button2.tag = 21;
    [button1 setTitle:@"保存" forState:UIControlStateNormal];
    [button2 setTitle:@"下一页" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [button1 addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_nameField];
    [self.view addSubview:_passWord];
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:button1];
    [self.view addSubview:button2];
}

-(void)login
{
    //进入下一页
    SecondViewController * sec = [[SecondViewController alloc]init];
    [self.navigationController pushViewController:sec animated:YES];
}

-(void)registerClick
{
    //保存数据
    [[FMDBManager shareInstance] insertDataWithName:_nameField.text PassWord:_passWord.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
