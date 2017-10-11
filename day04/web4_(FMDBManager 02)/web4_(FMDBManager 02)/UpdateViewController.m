//
//  UpdateViewController.m
//  web4_(FMDBManager 02)
//
//  Created by MS on 15-12-10.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "UpdateViewController.h"
#import "FMDBManager.h"

@interface UpdateViewController ()

@end

@implementation UpdateViewController

{
    UITextField * _nameField;
    UITextField * _passWord;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)createUI
{
    self.view.backgroundColor = [UIColor orangeColor];
    _nameField = [[UITextField alloc]initWithFrame:CGRectMake(120, 130, self.view.frame.size.width-150, 30)];
    _nameField.text = _nameText;
    
    _nameField.borderStyle = UITextBorderStyleRoundedRect;
    _passWord = [[UITextField alloc]initWithFrame:CGRectMake(120, 180, self.view.frame.size.width-150, 30)];
    _passWord.borderStyle = UITextBorderStyleRoundedRect;
    _passWord.text = _passWordText;
    _passWord.secureTextEntry = NO;
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(50,130, 60, 30)];
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(50, 180, 60, 30)];
    label1.text =@"用户名";
    label2.text = @"密码";
    
    UIButton * button1 = [[UIButton alloc]initWithFrame:CGRectMake(120, 250, 60, 30)];
    button1.tag = 20;
    UIButton * button2 = [[UIButton alloc]initWithFrame:CGRectMake(180, 250,100,40)];
    button2.tag = 21;
    [button2 setTitle:@"修改完成" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_nameField];
    [self.view addSubview:_passWord];
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:button2];
}

-(void)registerClick
{
    [[FMDBManager shareInstance]updateDateWithName:_nameField.text Age:_passWord.text LastName:self.nameText];
    //修改数据并返回上一页
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
