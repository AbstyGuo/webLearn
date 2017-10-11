//
//  ViewController.m
//  web5_(AVAudioPlayer 01)
//
//  Created by MS on 15-12-11.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>//播放音频的头文件

@interface ViewController ()
{
    //播放器必须使用全局变量
    AVAudioPlayer * _player;//播放器
    UIProgressView * _progressView;//播放进度条
    NSTimer * _timer;//时刻获取当前的播放时间、进度
    UISlider * _progressSlider;//滑动进度条
    UISlider * _volumSlider;//声音进度条
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //如果播放本地的音频，需要把本地文件的路径转换成URL类型
    //如果要是播放网络的音频，需要把解析出来的URL传递过来
    NSString * path = [[NSBundle mainBundle]pathForResource:@"song1" ofType:@"mp3"];
    NSURL * url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    
    //准备播放
    [_player prepareToPlay];
    
    [self createUI];
}

-(void)createUI
{
    NSArray * array = @[@"播放",@"暂停"];
    for (int i =0; i<2; i++) {
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, 100+i*(30+50), 300, 30)];
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[NSString stringWithFormat:@"%@",array[i]] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor redColor];
        [self.view addSubview:button];
    }
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(10, 250, self.view.frame.size.width-20, 10)];
    [self.view addSubview:_progressView];
    
    _progressSlider = [[UISlider alloc]initWithFrame:CGRectMake(10, 270, self.view.frame.size.width-20, 10)];
    //添加一个滑动事件
    [_progressSlider addTarget:self action:@selector(getCurrentTime) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_progressSlider];
    
    _volumSlider = [[UISlider alloc]initWithFrame:CGRectMake(10, 300, self.view.frame.size.width-20, 10)];
    [_volumSlider addTarget:self action:@selector(changeVolum) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_volumSlider];
}

-(void)buttonClicked:(UIButton *)button
{
    if (button.tag==100)
    {
        //播放
        [_player play];
        
        //播放的时候开始计时
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
    }else if(button.tag==101)
    {
        //暂停播放
        [_player stop];
    }
}

-(void)changeVolum
{
    _player.volume = _volumSlider.value;
}

-(void)getCurrentTime
{
    _player.currentTime = _progressSlider.value * _player.duration;
}

-(void)changeProgress
{
    //获取到当前播放时间，歌曲总时间，他们的商就是当前播放进度
    
    //当前时间
    CGFloat currentTime = _player.currentTime;
    
    //总时间
    CGFloat totalTime = _player.duration;
    
    _progressView.progress = currentTime/totalTime;
    _progressSlider.value = currentTime/totalTime;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
