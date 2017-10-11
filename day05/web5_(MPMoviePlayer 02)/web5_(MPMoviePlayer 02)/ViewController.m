//
//  ViewController.m
//  web5_(MPMoviePlayer 02)
//
//  Created by MS on 15-12-11.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>//播放视频用的系统库

@interface ViewController ()
{
    MPMoviePlayerViewController * _player;//媒体播放控制器
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 30)];
    [btn setTitle:@"play" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

-(void)click
{
    //播放本地视频和网络视频
    NSString * path = [[NSBundle mainBundle]pathForResource:@"apple" ofType:@"mp4"];
    NSURL * url = [NSURL fileURLWithPath:path];
    
    //初始化
    _player = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    
//    设置属性
    //设置播放屏幕的尺寸
    _player.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    
    //准备播放
    [_player.moviePlayer prepareToPlay];
    //播放
    [_player.moviePlayer play];
    
    //把这个播放器的播放屏幕加载出来<一个是 present  一个是addsubview>
    [self.view addSubview:_player.view];
    
    //点击播放界面的done键，让播放界面消失
    //在点击done键和播放结束的时候，播放器都会收到一个系统发的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePlayView) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

-(void)removePlayView
{
    //1.把播放的屏幕消失
    [_player.view removeFromSuperview];
    
    //2.把通知移除
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
