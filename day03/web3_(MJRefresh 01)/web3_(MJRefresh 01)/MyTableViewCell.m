//
//  MyTableViewCell.m
//  web1_(NSURLConnection 02)
//
//  Created by MS on 15-12-7.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "MyTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation MyTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)configCellWithModel:(MyModel *)model
{
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    _nameLabel.text = model.name;
    _idLabel.text = model.applicationId;
}

-(void)createUI
{
    //实例化cell里的控件
    self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 70)];
    [self.contentView addSubview:_iconView];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 200, 20)];
    _nameLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.contentView addSubview:_nameLabel];
    
    _idLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 50, 200, 20)];
    [self.contentView addSubview:_idLabel];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
