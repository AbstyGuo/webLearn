//
//  ViewController.m
//  web5_(MPMoviePlayer 02)
//
//  Created by zhulei on 15/12/11.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>//播放视频用的系统库
@interface ViewController (){
    
    //媒体播放控制器
    MPMoviePlayerViewController *_player;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    playBtn.frame = CGRectMake(100, 100, 100, 30);
    
    [playBtn setTitle:@"play" forState:UIControlStateNormal];
    
    [playBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:playBtn];
}
-(void)click{
    
    
    NSString *urlStr = [[NSBundle mainBundle]pathForResource:@"apple" ofType:@"mp4"];
    
    NSURL *url = [NSURL fileURLWithPath:urlStr];
   
    //播放本地视频 和 网络视频
    _player = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    
    //设置属性
    //设置播放屏幕的尺寸
    _player.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    
    
    //准备播放
    [_player.moviePlayer prepareToPlay];
    //播放
    [_player.moviePlayer play];
    
    
    //把这个播放器的播放屏幕加载出来<一个present 一个是addsubview>
    
    [self.view addSubview:_player.view];
    
    //点击播放界面的done键,让播放页面消失
    
    //在点击done键和播放结束的时候,播放器都会收到一个系统发的通知
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removePlayerView) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}
-(void)removePlayerView{
    
    //1.把播放屏幕消失掉
    [_player.view removeFromSuperview];
    
    //2.把通知移除掉
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
