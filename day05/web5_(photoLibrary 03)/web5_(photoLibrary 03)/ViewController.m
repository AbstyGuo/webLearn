//
//  ViewController.m
//  web5_(photoLibrary 03)
//
//  Created by MS on 15-12-11.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImageView * _headerView;
    UIImagePickerController * _picker;//图片选择器
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    _headerView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-100)/2,(self.view.frame.size.height-100)/2, 100, 100)];
    _headerView.layer.cornerRadius = 50;
    _headerView.layer.masksToBounds = YES;
    _headerView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_headerView];
    
    _headerView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goIntoPhotoLibrary)];
    [_headerView addGestureRecognizer:tap];
}

-(void)goIntoPhotoLibrary
{
    //点击进入相册或者调用相机
    _picker = [[UIImagePickerController alloc]init];
    _picker.allowsEditing = YES;//是否允许编辑
    
    //设置代理
    _picker.delegate = self;
    //把相册pre出来
    [self presentViewController:_picker animated:YES completion:^{
        
    }];
}

//选择完图片后调用的方法，并且把选择的图片取回来
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //判断一下照片是从相机照的还是相册选的
    if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        
        UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        _headerView.image = image;
    //把相册dis调
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    NSLog(@"%@",info);
    }
    else if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //从相机取的
        UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        _headerView.image = image;
    }
}

//取消选择图片调用的方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
