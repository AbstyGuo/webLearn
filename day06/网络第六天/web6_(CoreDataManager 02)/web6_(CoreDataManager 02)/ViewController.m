//
//  ViewController.m
//  web6_(CoreDataManager 02)
//
//  Created by zhulei on 15/12/14.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataManager.h"
#import "NextViewController.h"
@interface ViewController (){
    
    UIImageView *_headerView;
    
    UITextField *_nameField;
    
    UITextField *_phoneField;
    
    NSData *_imageData;
}

@end

@implementation ViewController

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
    
    [_headerView addGestureRecognizer:tap];
    
    [self.view addSubview:_headerView];
    
    
    _nameField =[[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, 220, 300, 30)];
    
    _nameField.borderStyle = UITextBorderStyleRoundedRect;
    
    _nameField.placeholder = @"请输入姓名";
    
    [self.view addSubview:_nameField];
    
    _phoneField =[[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, 270, 300, 30)];
    
    _phoneField.borderStyle = UITextBorderStyleRoundedRect;
    
    _phoneField.placeholder = @"请输入号码";
    
    [self.view addSubview:_phoneField];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.frame = CGRectMake((self.view.frame.size.width - 100)/2, 320, 100, 30);
    
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:saveBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [nextBtn setTitle:@"下一页" forState:UIControlStateNormal];
    nextBtn.frame = CGRectMake((self.view.frame.size.width - 100)/2, 370, 100, 30);
    
    [nextBtn addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nextBtn];
    
    

}
-(void)save{
 //保存数据
 
    //先把键盘收回
    [self.view endEditing:YES];
    
    [[CoreDataManager zhulei]insertDataWithImageData:_imageData Name:_nameField.text PhoneNum:_phoneField.text];
    
}
-(void)nextPage{
//下一页展示保存的数据
    
    NextViewController *next = [[NextViewController alloc]init];
    
    [self.navigationController pushViewController:next animated:YES];
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
