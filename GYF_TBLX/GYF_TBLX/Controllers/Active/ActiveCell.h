//
//  ActiveCell.h
//  GYF_TBLX
//
//  Created by MS on 15-12-25.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActiveCell : UITableViewCell

@property(nonatomic,strong) UILabel * titleLabel;
@property(nonatomic,strong) UILabel * placeLabel;
@property(nonatomic,strong) UILabel * timeLabel;
@property(nonatomic,strong) UILabel * moneyLabel;
@property(nonatomic,strong) UILabel * clubLabel;
@property(nonatomic,strong) UIImageView * smallImageView;
@property(nonatomic,strong) UIImageView * bigImageView;
@property(nonatomic,strong) UIButton * collectBtn;
@property(nonatomic,assign) BOOL * isCollect;

-(void)setContentWithDic:(NSDictionary *)dic;

@end
