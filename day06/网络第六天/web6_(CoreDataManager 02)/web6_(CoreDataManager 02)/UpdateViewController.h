//
//  UpdateViewController.h
//  web6_(CoreDataManager 02)
//
//  Created by zhulei on 15/12/14.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
@interface UpdateViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong)Student *student;
@end
