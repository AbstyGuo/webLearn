//
//  MyTableViewCell.h
//  web1_(NSURLConnection 02)
//
//  Created by zhulei on 15/12/7.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyModel.h"
@interface MyTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *iconView;

@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UILabel *idLabel;
//这个方法里面的参数类型一定要和调用这个方法的时候,传递过来的值的类型一致
-(void)configCellWithModel:(MyModel *)model;


@end
