//
//  ViewController.m
//  web5_(AVAudioPlayer 01)
//
//  Created by zhulei on 15/12/11.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>//播放音频的头文件
@interface ViewController (){
    
    //播放器必须使用全局变量
    
    AVAudioPlayer *_player;//播放器
    
    UIProgressView *_progressView;//播放进度条
    
    NSTimer *_timer;//定时器,来时刻获取当前的播放时间
    
    
    UISlider *_progressSlider;//滑动进度条
    
   
    UISlider *_volumSlider;//声音进度条
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
  
    [super viewDidLoad];
    
    
    //如果要是播放本地的音频,需要把本地文件的路径转换成URL类型
    //如果要是播放网络的音频,需要把解析出来的URL传递过来
    
    //本地
    NSString *urlStr = [[NSBundle mainBundle]pathForResource:@"song1" ofType:@"mp3"];
    
    //把本地音频的路径转化成URL
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    
    //准备播放
    [_player prepareToPlay];
    
    NSArray *nameArray = @[@"播放",@"暂停"];
    
    for (int i = 0 ; i<nameArray.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        btn.frame = CGRectMake((self.view.frame.size.width - 300)/2, 100+i*(30+20), 300, 30);
        
        [btn setTitle:[NSString stringWithFormat:@"%@",nameArray[i]] forState:UIControlStateNormal];
        
        btn.tag = 100+i;
        
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }
    
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(10, 200, self.view.frame.size.width - 20, 10)];
    
    [self.view addSubview:_progressView];
    
    
    _progressSlider = [[UISlider alloc]initWithFrame:CGRectMake(10, 230, self.view.frame.size.width - 20, 10)];
    
    //添加一个滑动事件
    
    [_progressSlider addTarget:self action:@selector(getCurrentTime:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_progressSlider];
    
    
    _volumSlider = [[UISlider alloc]initWithFrame:CGRectMake(10, 270, self.view.frame.size.width - 20, 10)];
  
    [_volumSlider addTarget:self action:@selector(changeVolum:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_volumSlider];
}
-(void)click:(UIButton *)btn{
    
    if (btn.tag == 100) {
        //播放
        [_player play];
        
        //播放的时候,开始计时
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
    
    }else if (btn.tag == 101){
       
        //暂停播放
        [_player stop];
        
    }
}
-(void)changeVolum:(UISlider *)slider{
    
   _player.volume = slider.value;
}
-(void)getCurrentTime:(UISlider *)slider{
    
 _player.currentTime = slider.value*_player.duration;

}
-(void)changeProgress{
    
    //获取到当前播放时间,歌曲总时间 他们的商 就是当前播放进度
    
    //当前时间:
    CGFloat currentTime = _player.currentTime;
    
    //总时间:
    CGFloat totalTime = _player.duration;
    
    
   _progressView.progress = currentTime/totalTime;
    
    _progressSlider.value = currentTime/totalTime;

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
