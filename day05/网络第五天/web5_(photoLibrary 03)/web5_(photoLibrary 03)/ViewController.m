//
//  ViewController.m
//  web5_(photoLibrary 03)
//
//  Created by zhulei on 15/12/11.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    
    UIImageView *_headerView;
    
    UIImagePickerController *_picker;//图片选择器
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _headerView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 100)/2, (self.view.frame.size.height - 100)/2, 100, 100)];
    
    //把头像变圆
    _headerView.layer.cornerRadius = 50;
    
    _headerView.layer.masksToBounds = YES;
    
    _headerView.backgroundColor = [UIColor redColor];
    
    _headerView.userInteractionEnabled = YES;
    
    [self.view addSubview:_headerView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goIntoPhotoLibrary)];
    
    [_headerView addGestureRecognizer:tap];
    
}
-(void)goIntoPhotoLibrary{
 
    //点击进入相册 或者 调用相机
    
    _picker = [[UIImagePickerController alloc]init];
    
    //是否允许编辑
    _picker.allowsEditing = NO;
    
    //设置代理
    
    _picker.delegate = self;
    
    //把相册present出来
    
    [self presentViewController:_picker animated:YES completion:^{
        
    }];
    
}

#pragma mark --UIImagePickerDelegate--
//选择完图片后调用的方法,并且把选择的图片取回来
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //判断一下 照片是从相机照的还是相册选的
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        //从相册取的
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        _headerView.image = image;
        
    }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        //从相机照的
        
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        _headerView.image = image;
    }
    
    
    NSLog(@"照片取完了");
    
    //把相册dismis掉
   [picker dismissViewControllerAnimated:YES completion:^{
       
   }];
    
}
//取消选择图片调用的方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
