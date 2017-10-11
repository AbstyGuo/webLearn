//
//  UpdateViewController.m
//  web6_(CoreDataManager 02)
//
//  Created by zhulei on 15/12/14.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "UpdateViewController.h"
#import "CoreDataManager.h"
@interface UpdateViewController (){
    
    UIImageView *_headerView;
    
    UITextField *_nameField;
    
    UITextField *_phoneField;
    
    NSData *_imageData;
}

@end

@implementation UpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    
}
-(void)creatUI{
    
    _headerView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 100)/2, 100, 100, 100)];
    
    _headerView.userInteractionEnabled = YES;
    
    _headerView.backgroundColor = [UIColor orangeColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    
    
    _imageData = self.student.headImageData;
    
    _headerView.image = [UIImage imageWithData:self.student.headImageData];
    
    [_headerView addGestureRecognizer:tap];
    
    [self.view addSubview:_headerView];
    
    
    _nameField =[[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, 220, 300, 30)];
    
    _nameField.borderStyle = UITextBorderStyleRoundedRect;
    
    _nameField.text = self.student.name;
    
    [self.view addSubview:_nameField];
    
    _phoneField =[[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, 270, 300, 30)];
    
    _phoneField.borderStyle = UITextBorderStyleRoundedRect;
    
    _phoneField.text = self.student.phoneNum;
    
    [self.view addSubview:_phoneField];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.frame = CGRectMake((self.view.frame.size.width - 100)/2, 320, 100, 30);
    
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:saveBtn];
    
}
-(void)save{
    //保存数据
    
    //先把键盘收回
    
    self.student.headImageData = _imageData;
    
    self.student.name = _nameField.text;
    
    self.student.phoneNum = _phoneField.text;
    
    //修改完成的方法必须写在重新赋值之后
    [[CoreDataManager zhulei]update:self.student];
    
    [self.view endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
//点击进入相册
-(void)tap:(UITapGestureRecognizer *)tap{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    
    picker.allowsEditing = NO;
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    _headerView.image = image;
    
    //image转化成NSData
    _imageData = UIImagePNGRepresentation(image);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    
}
@end
