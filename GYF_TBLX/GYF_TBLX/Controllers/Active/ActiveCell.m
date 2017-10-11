//
//  ActiveCell.m
//  GYF_TBLX
//
//  Created by MS on 15-12-25.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "ActiveCell.h"
#import "UIImageView+WebCache.h"
#import "FMDBManager.h"
#import "BaseModel.h"

@implementation ActiveCell
{
    CGFloat _wide;
    UIView * _view;
    BaseModel * _model;
    UIImageView * _selectView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _model = [[BaseModel alloc]init];
        self.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:235/255.f alpha:1];
        _wide = [UIScreen mainScreen].bounds.size.width;
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    _view = [[UIView alloc]initWithFrame:CGRectMake(10, 0,_wide-20, 190)];
    _view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, _wide-70, 30)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    _placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 60, _wide-130, 18)];
    _placeLabel.font = [UIFont systemFontOfSize:13];
    _placeLabel.textColor = [UIColor lightGrayColor];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 80, _wide-130, 18)];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor lightGrayColor];
    
    UILabel * costLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 100, 40, 18)];
    costLabel.text = @"费用：";
    costLabel.font = [UIFont systemFontOfSize:13];
    
    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 100, 100, 18)];
    _moneyLabel.font = [UIFont systemFontOfSize:13];
    _moneyLabel.textColor = [UIColor lightGrayColor];
    
    _smallImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 140, 40, 40)];
    
    _clubLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 150, 120, 20)];
    _clubLabel.font = [UIFont systemFontOfSize:13];
    _clubLabel.textColor = [UIColor lightGrayColor];
    
    _collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(_wide-70,0, 30, 30)];
    _selectView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30,30)];
    [_collectBtn addSubview:_selectView];
    [_collectBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    _bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_wide-150, 50, 120, 120)];
    
    [_view addSubview:_titleLabel];
    [_view addSubview:_timeLabel];
    [_view addSubview:_clubLabel];
    [_view addSubview:costLabel];
    [_view addSubview:_smallImageView];
    [_view addSubview:_bigImageView];
    [_view addSubview:_collectBtn];
    [_view addSubview:_moneyLabel];
    [_view addSubview:_placeLabel];
    [self.contentView addSubview:_view];
}

-(void)setContentWithDic:(NSDictionary *)dic{

    _model.applicationId = [NSString stringWithFormat:@"%@",dic[@"id"]];
    _model.name = [dic objectForKey:@"title"];
    _model.iconUrl = [dic objectForKey:@"cover"];
    
    _titleLabel.text = [dic objectForKey:@"title"];
    
    NSString * place = [NSString stringWithFormat:@"%@ - %@",dic[@"city"],dic[@"destination"]];
    _placeLabel.text = place;
    
    _moneyLabel.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"max_cost"]];
    
    NSArray * array = [dic objectForKey:@"tag"];
    for (int i = 0; i<array.count; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(5+i*(5+35), 35, 35, 18)];
        label.backgroundColor = [UIColor cyanColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = array[i];
        [_view addSubview:label];
    }
    if ([dic[@"period_desc"] isEqualToString:@""]) {
        NSString * date = [self getTimeStringWithSp:dic[@"start_time"]];
        _timeLabel.text = [NSString stringWithFormat:@"%@  行程%@天",date,dic[@"days"]];
    }else{
        _timeLabel.text = [NSString stringWithFormat:@"%@  行程%@天",dic[@"period_desc"],dic[@"days"]];
    }
    NSDictionary * clubDic = dic[@"club"];
    [_smallImageView sd_setImageWithURL:[NSURL URLWithString:clubDic[@"logo"]]];
    _clubLabel.text = clubDic[@"title"];
    
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"cover"]]];
    
    BOOL isCollect= [[FMDBManager shareInstance] selectWithAppId:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
    if (isCollect) {
        _selectView.image = [UIImage imageNamed:@"star_icon.png"];
    }else{
         _selectView.image = [UIImage imageNamed:@"star2_Gray.png"];
    }

}

-(void)click{
    BOOL isCollected = [[FMDBManager shareInstance] selectWithAppId:_model.applicationId];
    if (isCollected) {
        _selectView.image = [UIImage imageNamed:@"star2_Gray.png"];
        [[FMDBManager shareInstance] deleteWithAppId:_model.applicationId];

    }else{
        _selectView.image = [UIImage imageNamed:@"star_icon.png"];
        [[FMDBManager shareInstance] insertDataWithAppId:_model.applicationId IconUrl:_model.iconUrl Name:_model.name];
    }
}

-(NSString*)getTimeStringWithSp:(NSString *)sp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM月dd日"];
    //[formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:sp.doubleValue];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
