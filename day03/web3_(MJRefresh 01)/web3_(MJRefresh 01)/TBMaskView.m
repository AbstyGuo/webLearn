//
//  MaskView.m
//  iosNewNavi
//
//  Created by guoyf on 2016/10/27.
//  Copyright © 2016年 Mapbar Inc. All rights reserved.
//

#import "TBMaskView.h"
#import "TBWLMotionEvent.h"

@interface TBMaskView (){
    TBWLMotionEvent * _mo;
    CGFloat _width;
}
@end

@implementation TBMaskView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _mo = [[TBWLMotionEvent alloc] initWithRootView:self];
        _width = [UIScreen mainScreen].bounds.size.width/2;
        Class class = NSClassFromString(@"MPMapView");
        [_mo setMotionClass:[[class alloc]init]];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [_mo processTapEventWithX:point.x andY:point.y andState:MFWeGestureRecognizerStateBegan andNumberOfTouches:1];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [_mo processTapEventWithX:point.x andY:point.y andState:MFWeGestureRecognizerStateChanged andNumberOfTouches:1];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [_mo processTapEventWithX:point.x andY:point.y andState:MFWeGestureRecognizerStateEnded andNumberOfTouches:1];
}

@end
