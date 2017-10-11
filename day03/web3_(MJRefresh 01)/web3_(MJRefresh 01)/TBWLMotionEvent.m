//
//  TBWLMotionEvent.m
//  TBWLMotionEvent
//
//  Created by chen lh on 16/4/17.
//  Copyright (c) 2016年 com.mapbar.wedrive.ios. All rights reserved.
//

//ios截屏控件处理
/********************************************************************
 UIView                              已实现
 UIControl                           已实现
 UIButton                            已实现    OK
 UITextField                         已实现    OK
 UISwitch                            已实现    OK
 UINavigationBar                     已实现
 UITableViewCell                     已实现
 UIScrollView                        已实现
 UITableView                         已实现
 UICollectionView                    已实现
 UITextView                          已实现
 UIAlertView                         不能投屏到车机，使用自定义AlertView替代
 UIActionSheet                       不能投屏到车机，使用自定义ActionSheet替代
 UIWebView                           因UIWebView中的控件太多导致无法车机操控，目前UIWebView页面的内容只能显示，车机不能操控
 UIImageView                         此控件不需要添加回控方法
 UILabel                             此控件不需要添加回控方法
 UITableViewHeaderFooterView         此控件不需要添加回控方法
 UISearchBar
 UIBarButtonItem
 UIMenuController
 UIViewController
 UIRefreshControl
 UIDatePicker
 UISlider
 UISegmentedControl
 UIPageControl
 UIStepper
 UIProgressView
 UIActivityIndicatorView
 UITabBar
 UIWindow
 UICollectionReusableView
 UIPickerView
 UIToolbar
 ********************************************************************/

#import "TBWLMotionEvent.h"

@interface TBWLMotionEvent ()
{
    //UIView *_mRootView;
    UIView *_startTouchView;
    UIView *_touchView;
    //    UIView* _pickView;
    UIView* _itemView;
    
    MFWeGestureRecognizerState _currentState;
    
    Class _motionClass;
    UITouch *_touchEv;
    
    NSInteger _startX; // 开始触摸点的x坐标
    NSInteger _endX; // 结束触摸点的x坐标
    NSInteger _startY; // 开始触摸点的y坐标
    NSInteger _endY; // 结束触摸点的y坐标
    NSInteger _differenceX; // 开始点与结束点x坐标的差距
    NSInteger _differenceY; // 开始点与结束点y坐标的差距
    BOOL _isVerticalMove;
    BOOL _isHorizontalMove;
    BOOL _isItemMove;
    
    CGFloat nCoordinatePoint_x;   //x坐标值
    CGFloat nCoordinatePoint_y;   //y坐标值
    
    UIEvent* pTouchEvent;
    
    CGFloat _DragValueX;
    CGFloat _DragValueY;
    CGPoint nStartPoint;
    
    CGFloat newValue;
    BOOL bIsSliderChange;     //UISlider是否可以改变
    
    BOOL nControlIsClick;
    //BOOL _isSingleTap;
    
    NSMutableArray* pSaveTableViewCellArray;
    
    CGPoint pTouchPoint;   //记录触摸点坐标
    UIWebView * nWebView;  //记录一次触摸的webView
    NSMutableSet* touchSet;//将每次点击创建的touch放入Set
    NSDictionary * scrDic; //记录一次触摸scrollView的平移手势信息
    
    UIEvent *_motionClassEvent;
    UITouch *_motionClassTouch;
    NSMutableSet *_motionClassSet;
    
    UIEvent *_keyboardEvent;
    UITouch *_keyboardTouch;
    NSMutableSet *_keyboardSet;
    UIView *_keyboardView;
}
@end

@implementation TBWLMotionEvent

- (id)initWithRootView:(UIView*)rootView
{
    self = [super init];
    
    //_mRootView = rootView;
    _touchEv = [[UITouch alloc] init];
    pTouchEvent = [[UIEvent alloc] init];
    touchSet = [[NSMutableSet alloc]init];
    
    
    _keyboardSet = [[NSMutableSet alloc]init];
    _keyboardTouch = [[UITouch alloc] init];
    
    
    _motionClassSet = [[NSMutableSet alloc]init];
    _motionClassTouch = [[UITouch alloc] init];
    
    
    bIsSliderChange = NO;
    nControlIsClick = NO;
    
    pSaveTableViewCellArray = [[NSMutableArray alloc] init];
    
    //[self writeToFile:@"**********************************MotionEvent****************************************"];
    
    return self;
}

- (void)setMotionClass:(Class)motionClass
{
    _motionClass = motionClass;
}

- (void)start
{
    
}

- (void)stop
{
    if (pSaveTableViewCellArray && pSaveTableViewCellArray.count > 0)
    {
        [pSaveTableViewCellArray removeAllObjects];
    }
}

- (UIView *)getCurrentView {
    return [[UIApplication sharedApplication] keyWindow];
}

- (UIView *)findKeyboard
{
    UIView *keyboardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [windows reverseObjectEnumerator])//逆序效率更高，因为键盘总在上方
    {
        keyboardView = [self findKeyboardInView:window];
        if (keyboardView)
        {
            //return keyboardView;
            return window;
        }
    }
    return nil;
}

- (UIView *)findKeyboardInView:(UIView *)view
{
    for (UIView *subView in [view subviews])
    {
        if (strstr(object_getClassName(subView), "UIKeyboard"))
        {
            return subView;
        }
        else
        {
            UIView *tempView = [self findKeyboardInView:subView];
            if (tempView)
            {
                return tempView;
            }
        }
    }
    return nil;
}

//获取当前事件和凌晨事件的时间戳
- (NSTimeInterval)dateSinceMiddleNight
{
    NSDate * nowdate = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString * nowString = [formatter stringFromDate:nowdate];
    NSDate * nightdate = [formatter dateFromString:nowString];
    return [nowdate timeIntervalSinceDate:nightdate];
}

-(void)uiCollectionKeyboardViewHandleFun:(UIView*)pUICollectionView withGestureRecognizer:(MFWeGestureRecognizerState)state withTouchPoint:(CGPoint)nPoint
{
    
    UIView *view = pUICollectionView;
    while (view && ![view isKindOfClass:[UICollectionView class]])
    {
        view = (UIView *)view.superview;
    }
    
    UICollectionView *pCollectionView = (UICollectionView *)view;
    
    switch (state)
    {
        case MFWeGestureRecognizerStateEnded:
        {
            UIWindow * window = (UIWindow*)[self findKeyboard];
            CGPoint location = [pCollectionView convertPoint:nPoint fromView:window];
            NSIndexPath * path = [pCollectionView indexPathForItemAtPoint:location];
            
            [pCollectionView selectItemAtIndexPath:path animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            [pCollectionView.delegate collectionView:pCollectionView didSelectItemAtIndexPath:path];
            
            break;
        }
        default:
            break;
    }
}

- (BOOL)checkKeyboardTouchStatus:(MFWeGestureRecognizerState)status point:(CGPoint)point
{
    UIView *keyboardWindow = [self findKeyboard];
    if (keyboardWindow) {
        UIView *keybo = [keyboardWindow hitTest:point withEvent:nil];
        if (keybo) {
            if (_keyboardView) {
                if (_keyboardView != keybo) {
                    if (_keyboardEvent) {
                        CGPoint zeroPt = CGPointMake(0, 0);
                        if (status == MFWeGestureRecognizerStateChanged) {
                            if ([_keyboardView isKindOfClass:NSClassFromString(@"UIInputSwitcherView")]) {
                                [_keyboardTouch setValue:[NSValue valueWithCGPoint:zeroPt] forKey:@"locationInWindow"];
                                [_keyboardTouch setValue:[NSValue valueWithCGPoint:zeroPt] forKey:@"previousLocationInWindow"];
                                [_keyboardTouch setValue:@(UITouchPhaseCancelled) forKey:@"phase"];
                                [_keyboardEvent setValue:@([self dateSinceMiddleNight]) forKey:@"timestamp"];
                                [_keyboardView touchesCancelled:_keyboardSet withEvent:_keyboardEvent];
                            } else {
                                [_keyboardTouch setValue:[NSValue valueWithCGPoint:zeroPt] forKey:@"locationInWindow"];
                                [_keyboardTouch setValue:[NSValue valueWithCGPoint:zeroPt] forKey:@"previousLocationInWindow"];
                                [_keyboardTouch setValue:@(UITouchPhaseMoved) forKey:@"phase"];
                                [_keyboardEvent setValue:@([self dateSinceMiddleNight]) forKey:@"timestamp"];
                                [_keyboardView touchesMoved:_keyboardSet withEvent:_keyboardEvent];
                            }
                        } else if (status == MFWeGestureRecognizerStateEnded) {
                            [_keyboardTouch setValue:[NSValue valueWithCGPoint:zeroPt] forKey:@"locationInWindow"];
                            [_keyboardTouch setValue:[NSValue valueWithCGPoint:zeroPt] forKey:@"previousLocationInWindow"];
                            [_keyboardTouch setValue:@(UITouchPhaseEnded) forKey:@"phase"];
                            [_keyboardEvent setValue:@([self dateSinceMiddleNight]) forKey:@"timestamp"];
                            [_keyboardView touchesEnded:_keyboardSet withEvent:_keyboardEvent];
                        }
                    }
                }
            }
            _keyboardView = keybo;
            if (status == MFWeGestureRecognizerStateBegan) {
                UITouch * touch =({
                    UITouch * tou = [[UITouch alloc]init];
                    
                    CGPoint locationInWindow = point;
                    CGPoint previousLocationInWindow = point;
                    [tou setValue:@(UITouchPhaseBegan) forKey:@"phase"];
                    [tou setValue:keyboardWindow forKey:@"window"];
                    [tou setValue:keybo forKey:@"view"];
                    [tou setValue:@(1) forKey:@"tapCount"];
                    [tou setValue:[NSValue valueWithCGPoint:locationInWindow] forKey:@"locationInWindow"];
                    [tou setValue:[NSValue valueWithCGPoint:previousLocationInWindow] forKey:@"previousLocationInWindow"];
                    tou;
                });
                
                _keyboardTouch = touch;
                
                id class = NSClassFromString(@"UITouchesEvent");
                _keyboardEvent = [[class alloc]init];
                
                if (_keyboardSet.count > 0) {
                    [_keyboardSet removeAllObjects];
                }
                [_keyboardSet addObject:touch];
                
                [_keyboardEvent setValue:_keyboardSet forKey:@"_touches"];
                [_keyboardEvent setValue:@([self dateSinceMiddleNight]) forKey:@"timestamp"];
                
                
            } else if (status == MFWeGestureRecognizerStateChanged) {
                if (_keyboardEvent) {
                    [_keyboardTouch setValue:[NSValue valueWithCGPoint:point] forKey:@"locationInWindow"];
                    [_keyboardTouch setValue:[NSValue valueWithCGPoint:point] forKey:@"previousLocationInWindow"];
                    [_keyboardTouch setValue:@(UITouchPhaseMoved) forKey:@"phase"];
                    [_keyboardEvent setValue:@([self dateSinceMiddleNight]) forKey:@"timestamp"];
                }
                
            } else {
                if (_keyboardEvent) {
                    [_keyboardTouch setValue:[NSValue valueWithCGPoint:point] forKey:@"locationInWindow"];
                    [_keyboardTouch setValue:[NSValue valueWithCGPoint:point] forKey:@"previousLocationInWindow"];
                    [_keyboardTouch setValue:@(UITouchPhaseEnded) forKey:@"phase"];
                    [_keyboardEvent setValue:@([self dateSinceMiddleNight]) forKey:@"timestamp"];
                }
            }
            
            if ([keybo isKindOfClass:[UIButton class]]) {
                [self uiButtonWidgetHandleFun:keybo withGestureRecognizer:status];
            } else if ([keybo.superview isKindOfClass:NSClassFromString(@"UIKeyboardCandidateBarCell")] || [keybo.superview isKindOfClass:NSClassFromString(@"UIKeyboardCandidateGridCell")] || [keybo.superview isKindOfClass:NSClassFromString(@"UIKBHandwritingCandidateViewCell")]) {
                [self uiCollectionKeyboardViewHandleFun:keybo.superview withGestureRecognizer:status withTouchPoint:point];
            } else {
                
                NSString * classStr = NSStringFromClass([keybo class]);
                CGFloat Device = [[UIDevice currentDevice].systemVersion floatValue];
                //屏蔽9.0以上手写
                if (Device >=9.0) {
                    if ([classStr containsString:@"Handwriting"]) {
                        return TRUE;
                    }
                }
                
                switch (status) {
                    case MFWeGestureRecognizerStateBegan:
                        [keybo touchesBegan:_keyboardSet withEvent:_keyboardEvent];
                        break;
                    case MFWeGestureRecognizerStateChanged:
                        [keybo touchesMoved:_keyboardSet withEvent:_keyboardEvent];
                        break;
                    case MFWeGestureRecognizerStateEnded:
                        [keybo touchesEnded:_keyboardSet withEvent:_keyboardEvent];
                        break;
                    default:
                        break;
                }
            }
            
            if (status == MFWeGestureRecognizerStateEnded) {
                _keyboardView = nil;
                //_keyboardSet = nil;
                _keyboardEvent = nil;
                //_keyboardTouch = nil;
            }
            return  TRUE;
        }
        else
        {
            if (_keyboardView) {
                if (_keyboardEvent) {
                    CGPoint zeroPt = CGPointMake(0, 0);
                    if (status == MFWeGestureRecognizerStateChanged) {
                        if ([_keyboardView isKindOfClass:NSClassFromString(@"UIInputSwitcherView")]) {
                            [_keyboardTouch setValue:[NSValue valueWithCGPoint:zeroPt] forKey:@"locationInWindow"];
                            [_keyboardTouch setValue:[NSValue valueWithCGPoint:zeroPt] forKey:@"previousLocationInWindow"];
                            [_keyboardTouch setValue:@(UITouchPhaseCancelled) forKey:@"phase"];
                            [_keyboardEvent setValue:@([self dateSinceMiddleNight]) forKey:@"timestamp"];
                            [_keyboardView touchesCancelled:_keyboardSet withEvent:_keyboardEvent];
                        } else {
                            [_keyboardTouch setValue:[NSValue valueWithCGPoint:zeroPt] forKey:@"locationInWindow"];
                            [_keyboardTouch setValue:[NSValue valueWithCGPoint:zeroPt] forKey:@"previousLocationInWindow"];
                            [_keyboardTouch setValue:@(UITouchPhaseMoved) forKey:@"phase"];
                            [_keyboardEvent setValue:@([self dateSinceMiddleNight]) forKey:@"timestamp"];
                            [_keyboardView touchesMoved:_keyboardSet withEvent:_keyboardEvent];
                        }
                    } else if (status == MFWeGestureRecognizerStateEnded) {
                        [_keyboardTouch setValue:[NSValue valueWithCGPoint:zeroPt] forKey:@"locationInWindow"];
                        [_keyboardTouch setValue:[NSValue valueWithCGPoint:zeroPt] forKey:@"previousLocationInWindow"];
                        [_keyboardTouch setValue:@(UITouchPhaseEnded) forKey:@"phase"];
                        [_keyboardEvent setValue:@([self dateSinceMiddleNight]) forKey:@"timestamp"];
                        [_keyboardView touchesEnded:_keyboardSet withEvent:_keyboardEvent];
                    }
                }
                _keyboardView = nil;
            }
            if (_keyboardEvent) {
                if (status == MFWeGestureRecognizerStateEnded) {
                    //_keyboardSet = nil;
                    _keyboardEvent = nil;
                    //_keyboardTouch = nil;
                }
                return TRUE;
            }
        }
    }
    return FALSE;
}

#pragma mark - 车机互联手势处理函数
- (void)processTapEventWithX:(NSInteger)x andY:(NSInteger)y andState:(MFWeGestureRecognizerState)state andNumberOfTouches:(NSInteger)numberOfTouches
{
    _currentState = state;
    pTouchPoint = CGPointMake(x, y);
    
    if ([self checkKeyboardTouchStatus:state point:pTouchPoint]) {
        return;
    }
    /*
     _touchView = nil;
     @try {
     UIView *mainView = [self getCurrentView];
     CALayer *layer = [mainView.layer hitTest:CGPointMake(x, y)];
     
     while(!layer.delegate && layer)
     {
     layer = layer.superlayer;
     }
     
     if (!layer || !layer.delegate)
     return;
     _touchView = [self findEventView:layer withMFWeGestureRecognizerState:state];
     }
     @catch (NSException *exception) {
     _touchView = nil;
     }
     @finally {
     
     }
     */
    
    _touchView = nil;
    if (state == MFWeGestureRecognizerStateBegan) {
        //因webview控件视图在车机点击有问题，以此添加@try @catch 语句防止webview崩溃
        _startTouchView = nil;
        [touchSet removeAllObjects];
        @try {
            UIView *mainView = [self getCurrentView];
            CALayer *layer = [mainView.layer hitTest:CGPointMake(x, y)];
            
            while(!layer.delegate && layer)
            {
                layer = layer.superlayer;
            }
            
            if (!layer || !layer.delegate)
                return;
            _touchView = [self findEventView:layer withMFWeGestureRecognizerState:state];
        }
        @catch (NSException *exception) {
            _touchView = nil;
        }
        @finally {
            
        }
    }
    else
    {
        //因webview控件视图在车机点击有问题，以此添加@try @catch 语句防止webview崩溃
        @try {
            UIView *mainView = [self getCurrentView];
            CALayer *layer = [mainView.layer hitTest:CGPointMake(x, y)];
            
            while(!layer.delegate && layer)
            {
                layer = layer.superlayer;
            }
            
            if (layer && layer.delegate)
            {
                _touchView = [self findEventView:layer withMFWeGestureRecognizerState:state];
            }
        }
        @catch (NSException *exception) {
            _touchView = nil;
        }
        @finally {
        }
        if (_startTouchView != _touchView) {
            _touchView = _startTouchView;
            _currentState = MFWeGestureRecognizerStateCancelled;
        }
    }
    
    if (!_touchView)
    {
        return;
    }
    
    //NSLog(@"_touchView=%@", _touchView);
    
    //自定义控件处理，趣驾导航中的地图，其他app可不用此对象motionClass
    if ([NSStringFromClass([_touchView class]) isEqualToString:@"MBMapView"])
    {
        if (_touchEv)
        {
            if (state == MFWeGestureRecognizerStateBegan)
            {
                _startTouchView = _touchView;
            }
            [self motionClassHandleFun:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
            if (state == MFWeGestureRecognizerStateEnded)
            {
                _startTouchView = nil;
            }
            return;
        }
    }
    
    //系统控件处理
    if (state == MFWeGestureRecognizerStateBegan)
    {
        _startTouchView = _touchView;
        
        //NSLog(@"_startTouchView=%@", _startTouchView);
        //[self writeToFile:[NSString stringWithFormat:@"_startTouchView=%@", _startTouchView]];
        //[self writeToFile:[NSString stringWithFormat:@"Down->x=%ld,y=%ld", (long)x, (long)y]];
        
        // 设置触摸初始点的坐标
        _startX = x;
        _startY = y;
        
        if([_touchView isKindOfClass:[UISlider class]])
        {
            [self uiSliderWidgetHandleFun:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
        else if ([_touchView isKindOfClass:[UICollectionViewCell class]])
        {
            /*
             CGPoint nCoordinatePoint = [self ControlViewStartCoordinate:_touchView];
             CGPoint lPoint = CGPointMake(pTouchPoint.x - nCoordinatePoint.x, pTouchPoint.y - nCoordinatePoint.y);
             UIView *hitView = [_touchView hitTest:lPoint withEvent:nil];
             NSLog(@"hitView=%@", hitView);
             */
            [self uiCollectionViewWidgetHandleFun:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
        else if ([_touchView isKindOfClass:[UITableViewCell class]])
        {
            [self uiTableViewWidgetHandleFun:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
        else if ([_touchView isKindOfClass:[UITextView class]])
        {
            [self uiTextViewWidgetHandleFun:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
        else if ([_touchView isKindOfClass:[UIWebView class]]){
            [self WebWidgetHandle:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
        else if ([_touchView isKindOfClass:[UIScrollView class]])
        {
            [self uiScrollViewWidgetHandleFun:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
        else if ([_touchView isKindOfClass:[UIButton class]])
        {
            [self uiButtonWidgetHandleFun:_touchView withGestureRecognizer:state];
        }
        else if ([_touchView isKindOfClass:[UIPickerView class]])
        {
            [self uiPickViewWidgetHandleFun:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
    }
    else if (state == MFWeGestureRecognizerStateChanged)
    {
        //[self writeToFile:[NSString stringWithFormat:@"Move->x=%ld,y=%ld", (long)x, (long)y]];
        if ([_touchView isKindOfClass:[UIWebView class]]){
            [self WebWidgetHandle:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
        else if([_touchView isKindOfClass:[UISlider class]])
        {
            [self uiSliderWidgetHandleFun:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
        else if ([_touchView isKindOfClass:[UIScrollView class]])
        {
            [self uiScrollViewWidgetHandleFun:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
        else if ([_touchView isKindOfClass:[UITableViewCell class]])
        {
            [self uiTableViewWidgetHandleFun:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
        else if ([_touchView isKindOfClass:[UIPickerView class]])
        {
            [self uiPickViewWidgetHandleFun:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
        else if ([_touchView isKindOfClass:[UIButton class]])
        {
            [self uiButtonWidgetHandleFun:_touchView withGestureRecognizer:state];
        }
        
        // 为下一次移动记录终点坐标
        _endX = x;
        _endY = y;
        
    }
    else if (state == MFWeGestureRecognizerStateEnded)
    {
        //[self writeToFile:[NSString stringWithFormat:@"Up->x=%ld,y=%ld", (long)x, (long)y]];
        // 记录触摸点结束时的坐标
        _endX = x;
        _endY = y;
        
        if([_touchView isKindOfClass:[UIWebView class]])
        {
            //NSLog(@"------------------0------------------");
            [self WebWidgetHandle:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
        else if([_touchView isKindOfClass:[UISwitch class]])
        {
            //NSLog(@"------------------1------------------");
            [self uiswitchWidgetHandleFun:_touchView withGestureRecognizer:state];
        }
        else if([_touchView isKindOfClass:[UISlider class]])
        {
            //NSLog(@"------------------2------------------");
            [self uiSliderWidgetHandleFun:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
        else if([_touchView isKindOfClass:[UIActionSheet class]])
        {
            //NSLog(@"------------------3------------------");
            UIActionSheet *pActionSheetView = (UIActionSheet *)_touchView;
            if (pActionSheetView && pActionSheetView.delegate) {
                if ([pActionSheetView.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)])
                {
                    [pActionSheetView.delegate actionSheet:pActionSheetView clickedButtonAtIndex:0];
                }
            }
        }
        else if([_touchView isKindOfClass:[UICollectionViewCell class]])
        {
            //NSLog(@"------------------4------------------");
            [self uiCollectionViewWidgetHandleFun:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
        else if ([_touchView isKindOfClass:[UITableViewCell class]])
        {
            //NSLog(@"------------------5------------------");
            [self uiTableViewWidgetHandleFun:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
        else if([_touchView isKindOfClass:[UITextView class]])
        {
            //NSLog(@"------------------6------------------");
            [self uiTextViewWidgetHandleFun:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
        else if ([_touchView isKindOfClass:[UIPickerView class]])
        {
            //NSLog(@"------------------7------------------");
            [self uiPickViewWidgetHandleFun:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
        else if ([_touchView isKindOfClass:[UIScrollView class]])
        {
            //NSLog(@"------------------8------------------");
            [self uiScrollViewWidgetHandleFun:_touchView withGestureRecognizer:state withTouchPoint:CGPointMake(x, y)];
        }
        else if([_touchView isKindOfClass:[UISegmentedControl class]])
        {
            //NSLog(@"------------------9------------------");
            [self uiSegmentedControlWidgetHandleFun:_touchView withGestureRecognizer:state];
        }
        else if([_touchView isKindOfClass:[UITextField class]])
        {
            //NSLog(@"------------------10------------------");
            [self uitextFieldWidgetHandleFun:_touchView withGestureRecognizer:state];
        }
        else if([_touchView isKindOfClass:[UINavigationBar class]])
        {
            //NSLog(@"------------------11------------------");
            [self uinavigationBarWidgetHandleFun:_touchView withGestureRecognizer:state];
        }
        else if ([_touchView isKindOfClass:[UIButton class]])
        {
            //NSLog(@"------------------12------------------");
            [self uiButtonWidgetHandleFun:_touchView withGestureRecognizer:state];
        }
        else if ([_touchView isKindOfClass:[UIControl class]])
        {
            //NSLog(@"------------------13------------------");
            [self uicontrolWidgetHandle:_touchView withGestureRecognizer:state];
        }
        else if([_touchView isKindOfClass:[UIView class]])
        {
            //NSLog(@"*****************2222222********************");
            [self viewWidgetHandleFun:_touchView withGestureRecognizer:state];
        }
        //一次触摸结束清除原有数据
        [touchSet removeAllObjects];
        nWebView = nil;
        scrDic = nil;
        _itemView = nil;
        _startTouchView = nil;
    }
}

/*
 - (void)writeToFile:(NSString*)str
 {
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"LauncherSDK"];
 
 NSFileManager *fileManager = [NSFileManager defaultManager];
 if (![fileManager fileExistsAtPath:logDirectory]) {
 [fileManager createDirectoryAtPath:logDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
 }
 
 NSString *logFilePath = [logDirectory stringByAppendingPathComponent:@"motionEvent.log"];
 NSString *data = [NSString stringWithFormat:@"%@ %@\n", [self getCurrentTime], str];
 
 if ([fileManager fileExistsAtPath:logFilePath]) {
 NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:logFilePath];
 [fileHandle seekToEndOfFile];
 [fileHandle writeData:[data dataUsingEncoding:NSUTF8StringEncoding]];
 [fileHandle closeFile];
 } else {
 [data writeToFile:logFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
 }
 }
 
 - (NSString*)getCurrentTime
 {
 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
 [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
 NSString *dateTime = [formatter stringFromDate:[NSDate date]];
 return dateTime;
 }
 */

#pragma mark - WeLink辅助函数
- (UIView*)findEventView:(CALayer*)layer withMFWeGestureRecognizerState:(MFWeGestureRecognizerState)nState
{
    UIView *view = (UIView *)layer.delegate;
    
    UIView *cellView = view;
    UIView *scrollView = view;
    UIView *pTempView = view;
    UIView *pTextField = view;
    UIView *pCollectionView = view;
    UIView *pBarButtonItemView = view;
    UIView *pActionSheetView = view;
    UIView* pSwitchView = view;
    UIView* pWebView = view;
    UIView* pTouchView = view;
    UIView* pSegmentedControl = view;
    UIView* pUITextView = view;
    UIView* pUISlider = view;
    
    UIView* pPickView = view;
    
    /**  webview的layer拿到的delegate是  WebActionDisablingCALayerDelegate  不依托于view */
    if (pWebView) {
        if ([pWebView isKindOfClass:NSClassFromString(@"WebActionDisablingCALayerDelegate")]) {
            UIWebView * webView = (UIWebView *)[self findWebView];
            if (webView) {
                return webView;
            }
        }
        //layer的delegate有的情况是UIWebBrowserView，所以加了这个方法，避免有些webView拿不到
        else {
            if ([pWebView respondsToSelector:@selector(superview)]) {
                // 遍历找到UIWebView
                while (pWebView && ![pWebView isKindOfClass:[UIWebView class]])
                {
                    pWebView = (UIView *)pWebView.superview;
                }
                if ([pWebView isKindOfClass:[UIWebView class]])
                {
                    return pWebView;
                }
            }
        }
    }
    
    // 遍历找到UISegmentedControl
    while (pSegmentedControl && ![pSegmentedControl isKindOfClass:[UISegmentedControl class]])
    {
        pSegmentedControl = (UIView *)pSegmentedControl.superview;
    }
    if ([pSegmentedControl isKindOfClass:[UISegmentedControl class]])
    {
        return pSegmentedControl;
    }
    
    
    // 遍历找到UITextField
    while (pTextField && ![pTextField isKindOfClass:[UITextField class]])
    {
        pTextField = (UIView *)pTextField.superview;
    }
    if ([pTextField isKindOfClass:[UITextField class]])
    {
        return pTextField;
    }
    
    // UISwitch
    while (pSwitchView && ![pSwitchView isKindOfClass:[UISwitch class]])
    {
        pSwitchView = (UIView *)pSwitchView.superview;
    }
    if ([pSwitchView isKindOfClass:[UISwitch class]])
    {
        return pSwitchView;
    }
    
    // UISlider
    while (pUISlider && ![pUISlider isKindOfClass:[UISlider class]])
    {
        pUISlider = (UIView *)pUISlider.superview;
    }
    if ([pUISlider isKindOfClass:[UISlider class]])
    {
        return pUISlider;
    }
    
    
    //UIButton
    while (pTempView && ![pTempView isKindOfClass:[UIButton class]])
    {
        pTempView = (UIView *)pTempView.superview;
    }
    
    if ([pTempView isKindOfClass:[UIButton class]])
    {
        UIControl *control = (UIControl *)layer.delegate;
        while (control && ![control respondsToSelector:@selector(actionsForTarget:forControlEvent:)]) {
            control = (UIControl *)control.superview;
        }
        return (UIButton*)control;
    }
    
    // 遍历找到UITableViewCell
    while (cellView && ![cellView isKindOfClass:[UITableViewCell class]])
    {
        cellView = (UIView *)cellView.superview;
    }
    if ([cellView isKindOfClass:[UITableViewCell class]]) {
        return cellView;
    }
    
    // 遍历找到UIPickerView
    while (pPickView && ![pPickView isKindOfClass:[UIPickerView class]])
    {
        pPickView = (UIView *)pPickView.superview;
    }
    if ([pPickView isKindOfClass:[UIPickerView class]]) {
        
        return pPickView;
    }
    
    //UIControl
    UIView *control = view;
    while (control && ![control isKindOfClass:[UIControl class]])
    {
        control = (UIControl *)control.superview;
    }
    if([control isKindOfClass:[UIControl class]])
    {
        if ([control respondsToSelector:@selector(actionsForTarget:forControlEvent:)])
        {
            return (UIView*)control;
        }
    }
    
    //_motionClass
    if (_motionClass && [view isKindOfClass:_motionClass]) {
        return view;
    }
    
    //UIActionSheet
    while (pActionSheetView && ![pActionSheetView isKindOfClass:[UIActionSheet class]])
    {
        pActionSheetView = (UIView *)pActionSheetView.superview;
    }
    if ([pActionSheetView isKindOfClass:[UIActionSheet class]])
    {
        return pActionSheetView;
    }
    
    //UITextView
    while (pUITextView && ![pUITextView isKindOfClass:[UITextView class]])
    {
        pUITextView = (UIView *)pUITextView.superview;
    }
    if ([pUITextView isKindOfClass:[UITextView class]])
    {
        return pUITextView;
    }
    
    //    //UIWebView
    //    while (pWebView && ![pWebView isKindOfClass:[UIWebView class]])
    //    {
    //        pWebView = (UIView *)pWebView.superview;
    //    }
    //    if ([pWebView isKindOfClass:[UIWebView class]])
    //    {
    //        NSString* pTempString = [NSString stringWithFormat:@"找到了 ---  UIWebView"];
    //        [_debugDelegate onDebugText:pTempString];
    //        return pWebView;
    //    }
    
    //UICollectionViewCell
    while (pCollectionView && ![pCollectionView isKindOfClass:[UICollectionViewCell class]])
    {
        pCollectionView = (UIView *)pCollectionView.superview;
    }
    if ([pCollectionView isKindOfClass:[UICollectionViewCell class]])
    {
        return pCollectionView;
    }
    
    // 遍历找到UIScrollView
    while (scrollView && ![scrollView isKindOfClass:[UIScrollView class]])
    {
        scrollView = (UIView *)scrollView.superview;
    }
    if ([scrollView isKindOfClass:[UIScrollView class]])
    {
        return scrollView;
    }
    
    //UINavigationBar
    while (pBarButtonItemView && ![pBarButtonItemView isKindOfClass:[UINavigationBar class]])
    {
        pBarButtonItemView = (UIView *)pBarButtonItemView.superview;
    }
    if ([pBarButtonItemView isKindOfClass:[UINavigationBar class]])
    {
        return pBarButtonItemView;
    }
    
    //uiview
    while (pTouchView && ![pTouchView isKindOfClass:[UIView class]])
    {
        pTouchView = (UIView *)pTouchView.superview;
    }
    if ([pTouchView isKindOfClass:[UIView class]])
    {
        return pTouchView;
    }
    
    return nil;
}

//UISlider处理函数
const int nSliderValue = -1;
-(void)uiSliderWidgetHandleFun:(UIView*)pUISlider withGestureRecognizer:(MFWeGestureRecognizerState)nGestureRecognizerState withTouchPoint:(CGPoint)nPoint
{
    UISlider *slider = (UISlider *)pUISlider;
    
    switch (nGestureRecognizerState) {
        case MFWeGestureRecognizerStateBegan:
        {
            _isVerticalMove = NO;
            _isHorizontalMove = NO;
            nStartPoint.x = nPoint.x;
            nStartPoint.y = nPoint.y;
            
            _itemView = nil;
            UIView *superView = pUISlider;
            while (superView && ([superView isKindOfClass:NSClassFromString(@"UITableViewWrapperView")] || ![superView isKindOfClass:[UIScrollView class]]))
            {
                superView = (UIView *)superView.superview;
            }
            if ([superView isKindOfClass:[UIScrollView class]])
            {
                _itemView = superView;
                [self controlDragAction:_itemView withPoint:nPoint withGestureRecognizer:nGestureRecognizerState];
            }
            
            if (slider.enabled == NO || slider.userInteractionEnabled == NO)
            {
                return;
            }
            
            //CGPoint nCoordinatePoint = [self ControlViewStartCoordinate:slider];
            //CGPoint touchPt = CGPointMake(nPoint.x - nCoordinatePoint.x, nCoordinatePoint.y);
            //CGPoint nPoint = CGPointMake(_endX - nCoordinatePoint.x, _endY - nCoordinatePoint.y);
            //NSLog(@"nCoordinatePoint=%@,nPoint=%@", NSStringFromCGPoint(nCoordinatePoint), NSStringFromCGPoint(nPoint));
            
            [_touchEv setValue:[NSNumber numberWithInt:1] forKey:@"tapCount"];
            [_touchEv setValue:pUISlider forKey:@"view"];
            [_touchEv setValue:[NSValue valueWithCGPoint:nPoint] forKey:@"locationInWindow"];
            
            [_touchEv setValue:@(UITouchPhaseBegan) forKey:@"phase"];
            [slider beginTrackingWithTouch:_touchEv withEvent:pTouchEvent];
            break;
        }
        case MFWeGestureRecognizerStateChanged:
        {
            if (_itemView) {
                if (_isHorizontalMove == NO && _isVerticalMove == NO) {
                    CGFloat touchSlop = [[UIScreen mainScreen] scale] * 8;
                    CGFloat yDiff = fabs(nPoint.y - nStartPoint.y);
                    CGFloat xDiff = fabs(nPoint.x - nStartPoint.x);
                    if (xDiff > touchSlop) {
                        _isHorizontalMove = YES;
                    } else if (yDiff > touchSlop) {
                        _isVerticalMove = YES;
                        if (slider.enabled != NO && slider.userInteractionEnabled != NO)
                        {
                            [slider cancelTrackingWithEvent:pTouchEvent];
                        }
                    }
                }
                if (_isHorizontalMove == YES) {
                    if (slider.enabled == NO || slider.userInteractionEnabled == NO)
                    {
                        return;
                    }
                    //CGPoint nCoordinatePoint = [self ControlViewStartCoordinate:slider];
                    //CGPoint touchPt = CGPointMake(nPoint.x - nCoordinatePoint.x, nCoordinatePoint.y);
                    [_touchEv setValue:[NSNumber numberWithInt:1] forKey:@"tapCount"];
                    [_touchEv setValue:pUISlider forKey:@"view"];
                    [_touchEv setValue:[NSValue valueWithCGPoint:nPoint] forKey:@"locationInWindow"];
                    [_touchEv setValue:@(UITouchPhaseMoved) forKey:@"phase"];
                    [slider continueTrackingWithTouch:_touchEv withEvent:pTouchEvent];
                } else if (_isVerticalMove == YES) {
                    [self controlDragAction:_itemView withPoint:nPoint withGestureRecognizer:nGestureRecognizerState];
                }
            } else {
                if (slider.enabled == NO || slider.userInteractionEnabled == NO)
                {
                    return;
                }
                //CGPoint nCoordinatePoint = [self ControlViewStartCoordinate:slider];
                //CGPoint touchPt = CGPointMake(nPoint.x - nCoordinatePoint.x, nCoordinatePoint.y);
                [_touchEv setValue:[NSNumber numberWithInt:1] forKey:@"tapCount"];
                [_touchEv setValue:pUISlider forKey:@"view"];
                [_touchEv setValue:[NSValue valueWithCGPoint:nPoint] forKey:@"locationInWindow"];
                [_touchEv setValue:@(UITouchPhaseMoved) forKey:@"phase"];
                [slider continueTrackingWithTouch:_touchEv withEvent:pTouchEvent];
            }
            break;
        }
        case MFWeGestureRecognizerStateEnded:
        {
            if (_itemView) {
                if (_isHorizontalMove == YES) {
                    if (slider.enabled == NO || slider.userInteractionEnabled == NO)
                    {
                        return;
                    }
                    //CGPoint nCoordinatePoint = [self ControlViewStartCoordinate:slider];
                    //CGPoint touchPt = CGPointMake(nPoint.x - nCoordinatePoint.x, nCoordinatePoint.y);
                    [_touchEv setValue:[NSNumber numberWithInt:1] forKey:@"tapCount"];
                    [_touchEv setValue:pUISlider forKey:@"view"];
                    [_touchEv setValue:[NSValue valueWithCGPoint:nPoint] forKey:@"locationInWindow"];
                    [_touchEv setValue:@(UITouchPhaseEnded) forKey:@"phase"];
                    [slider endTrackingWithTouch:_touchEv withEvent:pTouchEvent];
                } else if (_isVerticalMove == YES) {
                    [self controlDragAction:_itemView withPoint:nPoint withGestureRecognizer:nGestureRecognizerState];
                }
            } else {
                if (slider.enabled == NO || slider.userInteractionEnabled == NO)
                {
                    return;
                }
                //CGPoint nCoordinatePoint = [self ControlViewStartCoordinate:slider];
                //CGPoint touchPt = CGPointMake(nPoint.x - nCoordinatePoint.x, nCoordinatePoint.y);
                [_touchEv setValue:[NSNumber numberWithInt:1] forKey:@"tapCount"];
                [_touchEv setValue:pUISlider forKey:@"view"];
                [_touchEv setValue:[NSValue valueWithCGPoint:nPoint] forKey:@"locationInWindow"];
                [_touchEv setValue:@(UITouchPhaseEnded) forKey:@"phase"];
                [slider continueTrackingWithTouch:_touchEv withEvent:pTouchEvent];
            }
            _isVerticalMove = NO;
            _isHorizontalMove = NO;
            nStartPoint.x = 0;
            nStartPoint.y = 0;
            break;
        }
        default:
        {
            break;
        }
    }
    
    if (TRUE) {
        return;
    }
    
    id target;
    NSEnumerator *enumerator = [slider.allTargets objectEnumerator];
    target = [enumerator nextObject];
    
    //slider每个值的宽度（高度）
    CGFloat nTempValue = 0.0;
    
    BOOL bHorz = YES;
    if (slider.bounds.size.width < slider.bounds.size.height)
        bHorz = NO;
    if (bHorz)
    {
        if (nPoint.x < slider.frame.origin.x)
        {
            nPoint.x  = slider.frame.origin.x;
        }
        int nValueX = nPoint.x - slider.frame.origin.x;
        newValue = nValueX / slider.bounds.size.width;
        
        nTempValue = slider.bounds.size.width / slider.maximumValue;
    }
    else
    {
        if (nPoint.y < slider.frame.origin.y)
        {
            nPoint.y  = slider.frame.origin.y;
        }
        int nValueY = nPoint.y - slider.frame.origin.y;
        newValue = nValueY / slider.bounds.size.height;
        
        nTempValue = slider.bounds.size.height / slider.maximumValue;
    }
    
    switch (nGestureRecognizerState) {
        case MFWeGestureRecognizerStateBegan:
        {
            int nSliderNumber = (newValue * slider.maximumValue) - slider.value;
            if ((nSliderValue * nTempValue) < nSliderNumber && nSliderNumber < (abs(nSliderValue) * nTempValue))    //-1 —— 1 是一个临界点,表示开始按下slider控件的时候判断按下的点和slider的初始值是否相近，如果大于这个临界点则表示按下的点和slider的初始值相差很多，那么则不执行后续的操作
            {
                bIsSliderChange = YES;
                NSArray *ToucheDownActions = [slider actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
                if (ToucheDownActions && ToucheDownActions.count > 0)
                {
                    NSString *selectorName = [ToucheDownActions objectAtIndex:0];
                    [target performSelectorOnMainThread:NSSelectorFromString(selectorName) withObject:slider waitUntilDone:NO];
                }
            }
            else
            {
                bIsSliderChange = NO;
            }
            
        }
            break;
        case MFWeGestureRecognizerStateChanged:
        {
            if (bIsSliderChange == YES)
            {
                slider.value = newValue * slider.maximumValue;
                NSArray *TouchChangedActions = [slider actionsForTarget:target forControlEvent:UIControlEventValueChanged];
                if (TouchChangedActions && TouchChangedActions.count > 0)
                {
                    NSString *selectorName = [TouchChangedActions objectAtIndex:0];
                    [target performSelectorOnMainThread:NSSelectorFromString(selectorName) withObject:slider waitUntilDone:NO];
                }
            }
        }
            break;
        case MFWeGestureRecognizerStateEnded:
        {
            if (bIsSliderChange == YES)
            {
                slider.value = newValue * slider.maximumValue;
                NSArray *ToucheDownActions = [slider actionsForTarget:target forControlEvent:UIControlEventTouchDown];
                if (ToucheDownActions && ToucheDownActions.count > 0)
                {
                    NSString *selectorName = [ToucheDownActions objectAtIndex:0];
                    [target performSelectorOnMainThread:NSSelectorFromString(selectorName) withObject:slider waitUntilDone:NO];
                }
                
                NSArray *ToucheUpInsideActions = [slider actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
                if (ToucheUpInsideActions && ToucheUpInsideActions.count > 0)
                {
                    NSString *selectorName = [ToucheUpInsideActions objectAtIndex:0];
                    [target performSelectorOnMainThread:NSSelectorFromString(selectorName) withObject:slider waitUntilDone:NO];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

//UICollectionView及UICollectionViewCell处理函数
-(void)uiCollectionViewWidgetHandleFun:(UIView*)pUICollectionView withGestureRecognizer:(MFWeGestureRecognizerState)nGestureRecognizerState withTouchPoint:(CGPoint)nPoint
{
    
    UIView *view = pUICollectionView;
    while (view && ![view isKindOfClass:[UICollectionView class]])
    {
        view = (UIView *)view.superview;
    }
    
    UICollectionView *pCollectionView = (UICollectionView *)view;
    
    [self controlDragAction:pCollectionView withPoint:nPoint withGestureRecognizer:nGestureRecognizerState];
    switch (nGestureRecognizerState)
    {
        case MFWeGestureRecognizerStateBegan:
        {
            break;
        }
        case MFWeGestureRecognizerStateChanged:
        {
            
        }
            break;
        case MFWeGestureRecognizerStateEnded:
        {
            if (nControlIsClick == NO)
            {
                return;
            }
            UICollectionViewCell *collectionviewcell = (UICollectionViewCell *)pUICollectionView;
            
            if ([pCollectionView.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
                NSIndexPath * indexPath = [pCollectionView indexPathForCell:collectionviewcell];
                [pCollectionView.delegate collectionView:pCollectionView didSelectItemAtIndexPath:indexPath];
            }else{
                
                NSMutableArray *pCollectionviewcellArray = [NSMutableArray arrayWithArray:collectionviewcell.contentView.subviews];
                for (UIView* pSubView in pCollectionviewcellArray)
                {
                    /*
                     NSLog(@"pSubView=%@", pSubView);
                     if ([pSubView isKindOfClass:[UIAlertController class]]) {
                     NSLog(@"--------333333333-------");
                     }
                     if ([pSubView isKindOfClass:[UIAlertAction class]]) {
                     NSLog(@"--------444444444-------");
                     }
                     */
                    if ([pSubView isKindOfClass:[UIButton class]])
                    {
                        UIControl *control = (UIControl*)pSubView;
                        id target;
                        NSEnumerator *enumerator = [control.allTargets objectEnumerator];
                        target = [enumerator nextObject];
                        
                        NSArray* buttonTouchUpInside = [control actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
                        
                        if (buttonTouchUpInside && buttonTouchUpInside.count > 0)
                        {
                            NSString *selectorName = [buttonTouchUpInside objectAtIndex:0];
                            [target performSelectorOnMainThread:NSSelectorFromString(selectorName) withObject:control waitUntilDone:NO];
                        }
                        break;
                    }
                    else if ([pSubView isKindOfClass:NSClassFromString(@"_UIAlertControllerActionView")])
                    {
                        /*
                         NSLog(@"pSubView=%@", pSubView);
                         if ([pCollectionView.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
                         NSIndexPath * indexPath = [pCollectionView indexPathForCell:collectionviewcell];
                         NSLog(@"indexPath=%ld", (long)indexPath.row);
                         [pCollectionView.delegate collectionView:pCollectionView didSelectItemAtIndexPath:indexPath];
                         }
                         */
                        break;
                    }
                }
                
            }
        }
            break;
            
        default:
            break;
    }
}

//PickView处理函数
-(void)uiPickViewWidgetHandleFun:(UIView*)pPickView withGestureRecognizer:(MFWeGestureRecognizerState)nGestureRecognizerState withTouchPoint:(CGPoint)nPoint{
    nCoordinatePoint_x = 0.0;
    nCoordinatePoint_y = 0.0;
    UIPickerView * pickView = (UIPickerView *)pPickView;
    CGPoint nCoordinatePoint = [self ControlViewStartCoordinate:pickView];
    UITableViewCell *cell;
    UITableView *tableView;
    if (_itemView && [_itemView isKindOfClass:[UITableViewCell class]]) {
        cell = (UITableViewCell *)_itemView;
    } else {
        CGPoint lPoint = CGPointMake(nPoint.x - nCoordinatePoint.x, nPoint.y - nCoordinatePoint.y);
        UIView *hitView = [pickView hitTest:lPoint withEvent:nil];
        cell = (UITableViewCell *)hitView;
        _itemView = cell;
    }
    
    UIView *view = cell;
    while (view && ![view isKindOfClass:[UITableView class]])
    {
        view = (UIView *)view.superview;
    }
    tableView = (UITableView *)view;
    
    [self controlDragAction:tableView withPoint:nPoint withGestureRecognizer:nGestureRecognizerState];
    switch (nGestureRecognizerState)
    {
        case MFWeGestureRecognizerStateBegan:
            break;
        case MFWeGestureRecognizerStateChanged:
            break;
        case MFWeGestureRecognizerStateEnded:
        {
            if (nControlIsClick) {
                if (tableView.delegate && [tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
                {
                    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
                    [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
                }
            }else{
                if (tableView.delegate && [tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
                {
                    CGPoint currentPoint = CGPointMake(nCoordinatePoint.x+tableView.frame.origin.x + 5, nCoordinatePoint.y+pickView.frame.size.height/2);
                    CGPoint runPoint = [tableView convertPoint:currentPoint fromView:[self getCurrentView]];
                    NSIndexPath * indexPath = [tableView indexPathForRowAtPoint:runPoint];
                    [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
                }
            }
        }
            break;
        default:
            break;
    }
    
}

//UITableView及UITableViewCell处理函数
-(void)uiTableViewWidgetHandleFun:(UIView*)pUITableView withGestureRecognizer:(MFWeGestureRecognizerState)nGestureRecognizerState withTouchPoint:(CGPoint)nPoint
{
    UITableViewCell *cell = (UITableViewCell *)pUITableView;
    UIView *view = pUITableView;
    while (view && ![view isKindOfClass:[UITableView class]])
    {
        view = (UIView *)view.superview;
    }
    
    UITableView *tableView = (UITableView *)view;
    [self controlDragAction:tableView withPoint:nPoint withGestureRecognizer:nGestureRecognizerState];
    switch (nGestureRecognizerState)
    {
        case MFWeGestureRecognizerStateBegan:
        {
            _itemView = nil;
            CGPoint nCoordinatePoint = [self ControlViewStartCoordinate:pUITableView];
            CGPoint nSelfPoint = CGPointMake(nStartPoint.x - nCoordinatePoint.x, nStartPoint.y - nCoordinatePoint.y);
            _itemView = [pUITableView hitTest:nSelfPoint withEvent:nil];
            if (_itemView && [_itemView isKindOfClass:[UIButton class]]) {
                [self uiButtonWidgetHandleFun:_itemView withGestureRecognizer:nGestureRecognizerState];
            }
            break;
        }
        case MFWeGestureRecognizerStateChanged:
        {
            if (_itemView && [_itemView isKindOfClass:[UIButton class]]) {
                if (nControlIsClick == NO) {
                    _currentState = MFWeGestureRecognizerStateCancelled;
                    [self uiButtonWidgetHandleFun:_itemView withGestureRecognizer:nGestureRecognizerState];
                }
            }
            break;
        }
        case MFWeGestureRecognizerStateEnded:
        {
            if (_itemView && [_itemView isKindOfClass:[UIButton class]]) {
                if (nControlIsClick == NO) {
                    _currentState = MFWeGestureRecognizerStateCancelled;
                }
                else
                {
                    nControlIsClick = NO;
                }
                [self uiButtonWidgetHandleFun:_itemView withGestureRecognizer:nGestureRecognizerState];
            }
            if (nControlIsClick)
            {
                BOOL bIsDataSourceCanEdit = NO;
                if (tableView.dataSource && [tableView.dataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
                    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
                    bIsDataSourceCanEdit = [tableView.dataSource tableView:tableView canEditRowAtIndexPath:indexPath];
                }
                
                if (bIsDataSourceCanEdit == YES)
                {
                    UITableViewCellEditingStyle nCellStyle = cell.editingStyle;
                    if (nCellStyle == UITableViewCellEditingStyleNone)
                    {
                        if (!pSaveTableViewCellArray || pSaveTableViewCellArray.count <= 0)
                        {
                            if (tableView.delegate && [tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
                            {
                                NSIndexPath *indexPath = [tableView indexPathForCell:cell];
                                [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
                                
                                [pSaveTableViewCellArray addObject:cell];
                            }
                        }
                        else
                        {
                            BOOL bIsFound = NO;
                            for (UIView* pTempView in pSaveTableViewCellArray)
                            {
                                if (pTempView == cell)
                                {
                                    if (tableView.delegate && [tableView.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
                                    {
                                        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
                                        [tableView.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
                                        [pSaveTableViewCellArray removeObject:pTempView];
                                        bIsFound = YES;
                                        break;
                                    }
                                }
                            }
                            
                            if (bIsFound == NO)
                            {
                                if (tableView.delegate && [tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
                                {
                                    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
                                    [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
                                    
                                    [pSaveTableViewCellArray addObject:cell];
                                }
                            }
                            
                        }
                        
                    }
                    else if(nCellStyle == UITableViewCellEditingStyleDelete)
                    {
                        if (tableView.dataSource && [tableView.dataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
                            NSIndexPath *indexPath = [tableView indexPathForCell:cell];
                            [tableView.dataSource tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
                        }
                        
                        
                    }
                    else if(nCellStyle == UITableViewCellEditingStyleInsert)
                    {
                        if (tableView.dataSource && [tableView.dataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
                            NSIndexPath *indexPath = [tableView indexPathForCell:cell];
                            [tableView.dataSource tableView:tableView commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:indexPath];
                        }
                    }
                    
                }
                else
                {
                    if (!pSaveTableViewCellArray || pSaveTableViewCellArray.count <= 0)
                    {
                        if (tableView.delegate && [tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
                        {
                            NSIndexPath *indexPath = [tableView indexPathForCell:cell];
                            [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
                            
                            [pSaveTableViewCellArray addObject:cell];
                        }
                    }
                    else
                    {
                        BOOL bIsFound = NO;
                        for (UIView* pTempView in pSaveTableViewCellArray)
                        {
                            if (pTempView == cell)
                            {
                                if (tableView.delegate && [tableView.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
                                {
                                    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
                                    [tableView.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
                                    [pSaveTableViewCellArray removeObject:pTempView];
                                    bIsFound = YES;
                                    break;
                                }
                            }
                        }
                        
                        if (bIsFound == NO)
                        {
                            if (tableView.delegate && [tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
                            {
                                NSIndexPath *indexPath = [tableView indexPathForCell:cell];
                                [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
                                
                                [pSaveTableViewCellArray addObject:cell];
                            }
                        }
                        
                    }
                    
                }
            }
            nStartPoint.x = 0.0;
            nStartPoint.y = 0.0;
            break;
        }
        default:
            break;
    }
}

//uiTextView控件处理函
-(void)uiTextViewWidgetHandleFun:(UIView*)pUITextView withGestureRecognizer:(MFWeGestureRecognizerState)nGestureRecognizerState withTouchPoint:(CGPoint)nPoint
{
    
    UITextView *pTextView = (UITextView *)pUITextView;
    [self controlDragAction:pTextView withPoint:nPoint withGestureRecognizer:nGestureRecognizerState];
    switch (nGestureRecognizerState) {
        case MFWeGestureRecognizerStateBegan:
            break;
        case MFWeGestureRecognizerStateChanged:
            break;
        case MFWeGestureRecognizerStateEnded:
            
            if (nControlIsClick)
            {
                //NSLog(@"weLink--------- pTextView --------- 点击了");
                if (pTextView.delegate && [pTextView.delegate respondsToSelector:@selector(textViewDidBeginEditing:)])
                {
                    [pTextView.delegate textViewDidBeginEditing:pTextView];
                    
                }
                else if (pTextView.delegate && [pTextView.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)])
                {
                    if ([pTextView.delegate textViewShouldBeginEditing:pTextView])
                    {
                        [pTextView.delegate textViewShouldBeginEditing:pTextView];
                    }
                }
            }
            
            break;
        default:
            break;
    }
}

//UIScrollView处理函数
-(void)uiScrollViewWidgetHandleFun:(UIView*)pUIScrollView withGestureRecognizer:(MFWeGestureRecognizerState)nGestureRecognizerState withTouchPoint:(CGPoint)nPoint
{
    UIScrollView *scrllV = (UIScrollView *)pUIScrollView;
    [self controlDragAction:scrllV withPoint:nPoint withGestureRecognizer:nGestureRecognizerState];
    
    switch (nGestureRecognizerState) {
        case MFWeGestureRecognizerStateBegan:
            break;
        case MFWeGestureRecognizerStateChanged:
            break;
        case MFWeGestureRecognizerStateEnded:
        {
            if (nControlIsClick == NO) {
                if (scrllV.delegate && [scrllV.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
                    [scrllV.delegate scrollViewDidEndDragging:scrllV willDecelerate:NO];
                }
            }
            
        }
            break;
        default:
            break;
    }
}

//UIButton处理函数
-(void)uiButtonWidgetHandleFun:(UIView*)pUIButton withGestureRecognizer:(MFWeGestureRecognizerState)nGestureRecognizerState
{
    switch (nGestureRecognizerState) {
        case MFWeGestureRecognizerStateBegan:
        {
            UIButton *btn = (UIButton*)pUIButton;
            if (btn.highlighted != YES) {
                btn.highlighted = YES;
            }
        }
            break;
        case MFWeGestureRecognizerStateChanged:
        {
            if (_currentState == MFWeGestureRecognizerStateCancelled) {
                UIButton *btn = (UIButton*)pUIButton;
                if (btn.highlighted == YES) {
                    btn.highlighted = NO;
                }
            } else if (_currentState == MFWeGestureRecognizerStateChanged) {
                UIButton *btn = (UIButton*)pUIButton;
                if (btn.highlighted != YES) {
                    btn.highlighted = YES;
                }
            }
        }
            break;
        case MFWeGestureRecognizerStateEnded:
        {
            UIButton *btn = (UIButton*)pUIButton;
            btn.highlighted = NO;
            if (_currentState == MFWeGestureRecognizerStateCancelled) {
                return;
            }
            UIControl *control = (UIControl*)pUIButton;
            id target;
            NSEnumerator *enumerator = [control.allTargets objectEnumerator];
            target = [enumerator nextObject];
            NSArray *buttonToucheDownActions = [control actionsForTarget:target forControlEvent:UIControlEventTouchDown];
            if (buttonToucheDownActions && buttonToucheDownActions.count > 0)
            {
                NSString *selectorName = [buttonToucheDownActions objectAtIndex:0];
                
                [target performSelectorOnMainThread:NSSelectorFromString(selectorName) withObject:control waitUntilDone:NO];
            }
            
            NSArray* buttonValueChangedActions = [control actionsForTarget:target forControlEvent:UIControlEventValueChanged];
            if (buttonValueChangedActions && buttonValueChangedActions.count > 0)
            {
                NSString *selectorName = [buttonValueChangedActions objectAtIndex:0];
                
                [target performSelectorOnMainThread:NSSelectorFromString(selectorName) withObject:control waitUntilDone:NO];
            }
            
            NSArray* buttonTouchUpInside = [control actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
            
            if (buttonTouchUpInside && buttonTouchUpInside.count > 0)
            {
                NSString *selectorName = [buttonTouchUpInside objectAtIndex:0];
                if (btn.enabled != NO) {
                    
                    [target performSelectorOnMainThread:NSSelectorFromString(selectorName) withObject:control waitUntilDone:NO];
                }
                
            }
            
        }
            break;
            
        default:
            break;
    }
}

//UISegmentedControl控件处理函
-(void)uiSegmentedControlWidgetHandleFun:(UIView*)pUISegmentedControl withGestureRecognizer:(MFWeGestureRecognizerState)nGestureRecognizerState
{
    if (_currentState == MFWeGestureRecognizerStateCancelled) {
        return;
    }
    UISegmentedControl* pSegment = (UISegmentedControl*)pUISegmentedControl;
    CGPoint clientPoint = [pSegment convertPoint:CGPointMake(_endX, _endY) fromView:pUISegmentedControl];
    NSInteger result = clientPoint.x / (pSegment.bounds.size.width / pSegment.numberOfSegments);
    //因下标从0开始，故减1
    [pSegment setSelectedSegmentIndex:(result - 1)];
    
    UIControl *control = (UIControl*)pUISegmentedControl;
    id target;
    NSEnumerator *enumerator = [control.allTargets objectEnumerator];
    target = [enumerator nextObject];
    
    NSArray* pChangedActions = [control actionsForTarget:target forControlEvent:UIControlEventValueChanged];
    if (pChangedActions && pChangedActions.count > 0)
    {
        NSString *selectorName = [pChangedActions objectAtIndex:0];
        [target performSelectorOnMainThread:NSSelectorFromString(selectorName) withObject:control waitUntilDone:NO];
    }
}

//UITextField控件处理函
-(void)uitextFieldWidgetHandleFun:(UIView*)pUITextField withGestureRecognizer:(MFWeGestureRecognizerState)nGestureRecognizerState
{
    if (_currentState == MFWeGestureRecognizerStateCancelled || nGestureRecognizerState != MFWeGestureRecognizerStateEnded) {
        return;
    }
    UITextField *pTextField = (UITextField *)pUITextField;
    
    if (![pTextField isFirstResponder])
    {
        [pTextField becomeFirstResponder];
    }
    
    //    if (pTextField.delegate && [pTextField.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)])
    //    {
    //        [_debugDelegate onDebugText:@"UITextField 111"];
    //        [pTextField.delegate textFieldShouldBeginEditing:pTextField];
    //    }
    //    if (pTextField.delegate && [pTextField.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
    //    {
    //        [_debugDelegate onDebugText:@"UITextField 222"];
    //        [pTextField.delegate textFieldDidBeginEditing:pTextField];
    //    }
    //    if (pTextField.delegate && [pTextField.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)])
    //    {
    //        [_debugDelegate onDebugText:@"UITextField 333"];
    //        [pTextField.delegate textFieldShouldEndEditing:pTextField];
    //    }
    //    if (pTextField.delegate && [pTextField.delegate respondsToSelector:@selector(textFieldDidEndEditing:)])
    //    {
    //        [_debugDelegate onDebugText:@"UITextField 444"];
    //        [pTextField.delegate textFieldDidEndEditing:pTextField];
    //    }
    //    if (pTextField.delegate && [pTextField.delegate respondsToSelector:@selector(textFieldShouldClear:)])
    //    {
    //        [_debugDelegate onDebugText:@"UITextField 555"];
    //        [pTextField.delegate textFieldShouldClear:pTextField];
    //    }
    //    if (pTextField.delegate && [pTextField.delegate respondsToSelector:@selector(textFieldShouldReturn:)])
    //    {
    //        [_debugDelegate onDebugText:@"UITextField 666"];
    //        [pTextField.delegate textFieldShouldReturn:pTextField];
    //    }
    
}

//UISwitch
-(void)uiswitchWidgetHandleFun:(UIView*)pUISwitch withGestureRecognizer:(MFWeGestureRecognizerState)nGestureRecognizerState
{
    if (_currentState == MFWeGestureRecognizerStateCancelled) {
        return;
    }
    UISwitch* pSwitch = (UISwitch*)pUISwitch;
    pSwitch.on = !(pSwitch.on);
    UIControl *control = (UIControl*)pUISwitch;
    id target;
    NSEnumerator *enumerator = [control.allTargets objectEnumerator];
    target = [enumerator nextObject];
    
    NSArray* pSwitchValueChangedActions = [control actionsForTarget:target forControlEvent:UIControlEventValueChanged];
    if (pSwitchValueChangedActions && pSwitchValueChangedActions.count > 0)
    {
        NSString *selectorName = [pSwitchValueChangedActions objectAtIndex:0];
        [target performSelectorOnMainThread:NSSelectorFromString(selectorName) withObject:control waitUntilDone:NO];
    }
}

//UINavigationBar控件处理函数
-(void)uinavigationBarWidgetHandleFun:(UIView*)pUINavigationBar withGestureRecognizer:(MFWeGestureRecognizerState)nGestureRecognizerState
{
    UINavigationBar* pNavigationBar = (UINavigationBar*)pUINavigationBar;
    
    NSArray* pItemsArray = [NSArray arrayWithArray:pNavigationBar.items];
    
    if (pItemsArray && pItemsArray.count > 0)
    {
        UINavigationItem* pNavigationItem = [pItemsArray objectAtIndex:0];
        if (pNavigationItem)
        {
            //说明点击的是左边的barItem
            if(_endX < [UIScreen mainScreen].bounds.size.width / 4)
            {
                UIBarButtonItem* pSubBarBackButtonItem = pNavigationItem.backBarButtonItem;
                if (pSubBarBackButtonItem)
                {
                    if (pSubBarBackButtonItem.customView && [pSubBarBackButtonItem.customView isKindOfClass:[UIButton class]])
                    {
                        UIButton *btn = (UIButton*)(pSubBarBackButtonItem.customView);
                        btn.highlighted = NO;
                        id target;
                        NSEnumerator *enumerator = [btn.allTargets objectEnumerator];
                        target = [enumerator nextObject];
                        NSArray *buttonToucheDownActions = [btn actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
                        if (buttonToucheDownActions && buttonToucheDownActions.count > 0)
                        {
                            NSString *selectorName = [buttonToucheDownActions objectAtIndex:0];
                            [target performSelectorOnMainThread:NSSelectorFromString(selectorName) withObject:btn waitUntilDone:NO];
                        }
                        
                    }
                    else
                    {
                        for(UINavigationItem* pNavigationItem in pItemsArray)
                        {
                            if (pNavigationItem)
                            {
                                if (pNavigationBar && pNavigationBar.delegate)
                                {
                                    [pNavigationBar.delegate navigationBar:pNavigationBar shouldPopItem:pNavigationItem];
                                }
                            }
                        }
                    }
                }
                else
                {
                    UIBarButtonItem* pLeftBarButtonItems = pNavigationItem.leftBarButtonItem;
                    if (pLeftBarButtonItems)
                    {
                        if (pLeftBarButtonItems.customView && [pLeftBarButtonItems.customView isKindOfClass:[UIButton class]])
                        {
                            UIButton *btn = (UIButton*)(pLeftBarButtonItems.customView);
                            btn.highlighted = NO;
                            //UIControl *control = (UIControl*)_touchView;
                            id target;
                            NSEnumerator *enumerator = [btn.allTargets objectEnumerator];
                            target = [enumerator nextObject];
                            NSArray *buttonToucheDownActions = [btn actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
                            if (buttonToucheDownActions && buttonToucheDownActions.count > 0)
                            {
                                NSString *selectorName = [buttonToucheDownActions objectAtIndex:0];
                                [target performSelectorOnMainThread:NSSelectorFromString(selectorName) withObject:btn waitUntilDone:NO];
                            }
                            
                        }
                        else
                        {
                            for(UINavigationItem* pNavigationItem in pItemsArray)
                            {
                                if (pNavigationItem)
                                {
                                    if (pNavigationBar && pNavigationBar.delegate)
                                    {
                                        [pNavigationBar.delegate navigationBar:pNavigationBar shouldPopItem:pNavigationItem];
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if(_endX > [UIScreen mainScreen].bounds.size.width / 4 * 3)  //右边的barItem
            {
                UIBarButtonItem* pRightBarButtonItems = pNavigationItem.leftBarButtonItem;
                if (pRightBarButtonItems)
                {
                    if (pRightBarButtonItems.customView && [pRightBarButtonItems.customView isKindOfClass:[UIButton class]])
                    {
                        UIButton *btn = (UIButton*)(pRightBarButtonItems.customView);
                        btn.highlighted = NO;
                        id target;
                        NSEnumerator *enumerator = [btn.allTargets objectEnumerator];
                        target = [enumerator nextObject];
                        NSArray *buttonToucheDownActions = [btn actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
                        if (buttonToucheDownActions && buttonToucheDownActions.count > 0)
                        {
                            NSString *selectorName = [buttonToucheDownActions objectAtIndex:0];
                            [target performSelectorOnMainThread:NSSelectorFromString(selectorName) withObject:btn waitUntilDone:NO];
                        }
                    }
                }
            }
            else
            {
                for (UINavigationItem* pNaviBarSubItem in pItemsArray)
                {
                    UIView* pNaviBarTitleView = pNaviBarSubItem.titleView;
                    if (pNaviBarTitleView)
                    {
                        nCoordinatePoint_x = 0.0;
                        nCoordinatePoint_y = 0.0;
                        CGPoint nCoordinatePoint = [self ControlViewStartCoordinate:pNaviBarTitleView];
                        
                        CGPoint nPoint = CGPointMake(_endX - nCoordinatePoint.x, _endY - nCoordinatePoint.y);
                        
                        
                        for (UIView* pNaviBarSubButton in pNaviBarTitleView.subviews)
                        {
                            if ([pNaviBarSubButton isKindOfClass:[UIButton class]])
                            {
                                bool bIsContains = CGRectContainsPoint(pNaviBarSubButton.frame, nPoint);
                                
                                if (bIsContains)
                                {
                                    UIButton *btn = (UIButton*)(pNaviBarSubButton);
                                    btn.highlighted = NO;
                                    id target;
                                    NSEnumerator *enumerator = [btn.allTargets objectEnumerator];
                                    target = [enumerator nextObject];
                                    NSArray *buttonToucheDownActions = [btn actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
                                    if (buttonToucheDownActions && buttonToucheDownActions.count > 0)
                                    {
                                        NSString *selectorName = [buttonToucheDownActions objectAtIndex:0];
                                        [target performSelectorOnMainThread:NSSelectorFromString(selectorName) withObject:btn waitUntilDone:NO];
                                    }
                                    return;
                                }
                                
                                
                            }
                        }
                    }
                    
                }
            }
        }
    }
    else
    {
        if (!pItemsArray)
        {
            return;
        }
    }
}

//UIControl控件处理函数
-(void)uicontrolWidgetHandle:(UIView*)pUIControl withGestureRecognizer:(MFWeGestureRecognizerState)state
{
    nCoordinatePoint_x = 0.0;
    nCoordinatePoint_y = 0.0;
    NSMutableString* pActionString = [NSMutableString string];
    
    UIControl *control = (UIControl*)pUIControl;
    id target;
    NSEnumerator *enumerator = [control.allTargets objectEnumerator];
    target = [enumerator nextObject];
    
    CGPoint nCoordinatePoint = [self ControlViewStartCoordinate:control];
    CGPoint nPoint = CGPointMake(_endX - nCoordinatePoint.x, _endY - nCoordinatePoint.y);
    
    if (control.enabled == YES)
    {
        /*
         int nNumber = 0;
         for (UIView* pContainView in control.subviews)
         {
         bool bIsContains = CGRectContainsPoint(pContainView.frame, nPoint);
         if (!bIsContains)
         {
         nNumber++;
         }
         else
         {
         break;
         }
         }
         if (nNumber >= control.subviews.count)
         {
         return;
         }
         UIView* pSubView = [control.subviews objectAtIndex:nNumber];
         */
        
        UIView* pSubView = [pUIControl hitTest:nPoint withEvent:nil];
        
        if (pSubView)
        {
            NSArray* pGesture = [pSubView gestureRecognizers];
            /*
             if ([pSubView isKindOfClass:NSClassFromString(@"UIPickerTableViewWrapperCell")]) {
             return;
             }
             */
            if (pGesture && pGesture.count >= 1)
            {
                NSString* pGestureString = [NSString stringWithString:[[pGesture objectAtIndex:0] description]];
                if (pGestureString && pGestureString.length > 1)
                {
                    pGestureString = [pGestureString stringByReplacingOccurrencesOfString:@"<" withString:@""];
                    pGestureString = [pGestureString stringByReplacingOccurrencesOfString:@">" withString:@""];
                    pGestureString = [pGestureString stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    NSArray* pSubArray = [pGestureString componentsSeparatedByString:@";"];
                    if (pSubArray && pSubArray.count >= 1)
                    {
                        NSString* pGestureStatusString = [pSubArray objectAtIndex:0];
                        
                        if ([pGestureStatusString hasPrefix:@"UITapGestureRecognizer"])
                        {
                            NSString* pTargetString = nil;
                            NSMutableString* pMutableString = [NSMutableString string];
                            for (int i = 0; i < pSubArray.count; i++)
                            {
                                
                                NSString* pSubString = [pSubArray objectAtIndex:i];
                                if ([pSubString hasPrefix:@"target"]) {
                                    pTargetString = pSubString;
                                    break;
                                }
                            }
                            if(pTargetString && pTargetString.length > 1)
                            {
                                NSArray* pTempArray = [pTargetString componentsSeparatedByString:@","];
                                if (pTempArray && pTempArray.count >= 1)
                                {
                                    for (int j = 0; j < pTempArray.count; j++)
                                    {
                                        NSString* pSubString = [pTempArray objectAtIndex:j];
                                        if ([pSubString hasPrefix:@"target"]) {
                                            [pMutableString setString:pSubString];
                                            NSRange nRange = [pSubString rangeOfString:@"action"];
                                            if (nRange.location < pSubString.length && nRange.length > 0)
                                            {
                                                [pActionString setString:[pMutableString substringFromIndex:(nRange.location + nRange.length + 1)]];
                                            }
                                            break;
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
            
            if (pActionString && pActionString.length > 1)
            {
                [control performSelectorOnMainThread:NSSelectorFromString(pActionString) withObject:[pGesture objectAtIndex:0] waitUntilDone:NO];
                
            }
            else
            {
                NSArray *pValueChangedActions = [control actionsForTarget:target forControlEvent:UIControlEventValueChanged];
                if (pValueChangedActions && pValueChangedActions.count > 0)
                {
                    [_touchEv setValue:[NSNumber numberWithInt:1] forKey:@"tapCount"];
                    [_touchEv setValue:_touchView forKey:@"view"];
                    [_touchEv setValue:[NSValue valueWithCGPoint:CGPointMake(_endX, _endY)] forKey:@"locationInWindow"];
                    [control endTrackingWithTouch:_touchEv withEvent:nil];
                    
                    NSString *selectorName = [pValueChangedActions objectAtIndex:0];
                    [target performSelectorOnMainThread:NSSelectorFromString(selectorName) withObject:control waitUntilDone:NO];
                }
            }
        }
    }
}

#pragma mark - 控件处理函数
//视图控件处理函数  UIView
-(void)viewWidgetHandleFun:(UIView*)pView withGestureRecognizer:(MFWeGestureRecognizerState)nGestureRecognizerState
{
    if (_currentState == MFWeGestureRecognizerStateCancelled) {
        return;
    }
    
    //    pView = [pView.window hitTest:pTouchPoint withEvent:nil];
    
    //sel
    NSMutableString* pActionString = [NSMutableString string];
    //target
    NSMutableString* pWelinkTargetString = [NSMutableString string];
    
    if (pView)
    {
        NSArray* pGesture = [pView gestureRecognizers];
        //NSLog(@"pGesture=%@", pGesture);
        //NSLog(@"\n view pGesture ===== %@\n\n\n",pGesture.description);
        if (pGesture && pGesture.count >= 1)
        {
            NSString* pGestureString = [NSString stringWithString:[[pGesture objectAtIndex:0] description]];
            //NSLog(@"\n view pGestureString ===== %@\n\n\n",pGestureString);
            
            if (pGestureString && pGestureString.length > 1)
            {
                pGestureString = [pGestureString stringByReplacingOccurrencesOfString:@"<" withString:@""];
                pGestureString = [pGestureString stringByReplacingOccurrencesOfString:@">" withString:@""];
                pGestureString = [pGestureString stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                NSArray* pSubArray = [pGestureString componentsSeparatedByString:@";"];
                
                if (pSubArray && pSubArray.count >= 1)
                {
                    NSString* pGestureStatusString = [pSubArray objectAtIndex:0];
                    //Tap GestureRecognizer
                    if ([pGestureStatusString hasPrefix:@"UITapGestureRecognizer"])
                    {
                        NSMutableString* pTargetString = [NSMutableString string];
                        for (int i = 0; i < pSubArray.count; i++)
                        {
                            NSString* pSubString = [pSubArray objectAtIndex:i];
                            if ([pSubString hasPrefix:@"target="]) {
                                NSRange nTargetRange = [pSubString rangeOfString:@"target="];
                                if(nTargetRange.location < pSubString.length && nTargetRange.length > 1)
                                {
                                    [pTargetString setString:[pSubString substringFromIndex:(nTargetRange.location + nTargetRange.length)]];
                                }
                                break;
                            }
                        }
                        if(pTargetString && pTargetString.length > 1)
                        {
                            NSString* pTargetSubString = [pTargetString stringByReplacingOccurrencesOfString:@"(" withString:@""];
                            pTargetSubString = [pTargetSubString stringByReplacingOccurrencesOfString:@")" withString:@""];
                            
                            
                            NSArray* pTempArray = [pTargetSubString componentsSeparatedByString:@","];
                            if (pTempArray && pTempArray.count >= 1)
                            {
                                for (int j = 0; j < pTempArray.count; j++)
                                {
                                    NSString* pSubString = [pTempArray objectAtIndex:j];
                                    
                                    if ([pSubString hasPrefix:@"action="]) {
                                        NSRange nRange = [pSubString rangeOfString:@"action="];
                                        if (nRange.location < pSubString.length && nRange.length > 0)
                                        {
                                            [pActionString setString:[pSubString substringFromIndex:(nRange.location + nRange.length)]];
                                        }
                                    }
                                    else if([pSubString hasPrefix:@"target="])
                                    {
                                        NSRange nRange = [pSubString rangeOfString:@"target="];
                                        if (nRange.location < pSubString.length && nRange.length > 0)
                                        {
                                            NSString* pTempTarStr = [pSubString substringFromIndex:(nRange.location + nRange.length)];
                                            
                                            NSRange nHexRange = [pTempTarStr rangeOfString:@"0x"];
                                            
                                            if (nHexRange.location < pTempTarStr.length && nHexRange.length > 1)
                                            {
                                                [pWelinkTargetString setString:[pTempTarStr substringFromIndex:(nHexRange.location)]];
                                            }
                                            else
                                            {
                                                [pWelinkTargetString setString:pTempTarStr];
                                            }
                                            
                                        }
                                        
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
            
            //            NSLog(@"ActionString ===== %@\n\n\n ",pActionString);
            //            NSLog(@"pWelinkTargetString ===== %@\n\n\n ",pWelinkTargetString);
            
            //第一种方式
            /*
             客户端中UIView添加手势UIGestureRecognizer，车机端点击view时的手势实现逻辑
             （1）找到操作的视图；
             （2）判断该视图是否实现了手势响应函数；如果现实则告诉手机响应，如果没有实现，则去父视图查找
             （3）如果视图没有实现手势响应函数，则去视图控制器中查找
             */
            
            //            BOOL bIsAction = NO;
            //            if (pActionString && pActionString.length > 1 && pWelinkTargetString && pWelinkTargetString.length > 1)
            //            {
            //                if([pView respondsToSelector:NSSelectorFromString(pActionString)])
            //                {
            //                    bIsAction = YES;
            //                    NSLog(@"111111111111111111111111111111\n\n\n ");
            //                    [pView performSelectorOnMainThread:NSSelectorFromString(pActionString) withObject:(UIGestureRecognizer*)([pGesture objectAtIndex:0]) waitUntilDone:NO];
            //                }
            //                else
            //                {
            //                    UIView* pGesSuperView = pView.superview;
            //
            //                    if (pGesSuperView && [pGesSuperView respondsToSelector:NSSelectorFromString(pActionString)])
            //                    {
            //                        NSLog(@"222222222222222222222222 \n\n\n ");
            //                        bIsAction = YES;
            //                        [pGesSuperView performSelectorOnMainThread:NSSelectorFromString(pActionString) withObject:(UIGestureRecognizer*)([pGesture objectAtIndex:0]) waitUntilDone:NO];
            //
            //                    }
            //
            //
            //
            //                }
            //
            //                if (!bIsAction)
            //                {
            //                    UIViewController* pViewController = [self findWidgetViewController:pView];
            //                    if (pViewController)
            //                    {
            //                        NSLog(@"3333333333333333333\n\n\n ");
            //                        [pViewController performSelectorOnMainThread:NSSelectorFromString(pActionString) withObject:pWelinkTargetString waitUntilDone:NO];
            //                    }
            //                }
            //            }
            
            //第二种方式，第二种方式更优化
            /*
             客户端中UIView添加手势UIGestureRecognizer，车机端点击view时的手势实现逻辑
             （1）找到视图所在的视图控制器,判断视图控制器是否实现手势响应方法，如果实现则运行；
             （2）如果视图控制器没有实现手势响应函数，则查找点击的视图及所有父视图，直到视图控制器的根视图，并添加到数组中，最后从视图数组中查找哪个视图实现了本视图的手势响应，查找到就响应
             */
            
            
            UIViewController* pViewController = [self findWidgetViewController:pView];
            if (pViewController)
            {
                if (!pActionString && pActionString.length <= 0) {
                    return;
                }
                if ([pViewController respondsToSelector:NSSelectorFromString(pActionString)])
                {
                    //NSLog(@"---UIViewController action----\n\n\n ");
                    [pViewController performSelectorOnMainThread:NSSelectorFromString(pActionString) withObject:pWelinkTargetString waitUntilDone:NO];
                }
                else
                {
                    NSMutableArray* pViewArray = [NSMutableArray array];
                    UIView* pRootView = pViewController.view;
                    
                    UIView* pTempView = pView;
                    while (pRootView != pTempView)
                    {
                        [pViewArray addObject:pTempView];
                        pTempView = pTempView.superview;
                    }
                    
                    //NSLog(@"pViewArray ======== %@",pViewArray.description);
                    
                    if (pViewArray && pViewArray.count >= 1)
                    {
                        for (UIView* ppView in pViewArray)
                        {
                            if (ppView && [ppView respondsToSelector:NSSelectorFromString(pActionString)])
                            {
                                //NSLog(@"ppView ======== %@",ppView.description);
                                [ppView performSelectorOnMainThread:NSSelectorFromString(pActionString) withObject:(UIGestureRecognizer*)([pGesture objectAtIndex:0]) waitUntilDone:NO];
                                break;
                            }
                        }
                    }
                }
            }
        }
        else
        {
            if (pView.superview)
            {
                [self viewWidgetHandleFun:pView.superview withGestureRecognizer:nGestureRecognizerState];
            }
        }
    }
}

//web控件响应函数
-(void)WebWidgetHandle:(UIView*)pWebView withGestureRecognizer:(MFWeGestureRecognizerState)nGestureRecognizerState withTouchPoint:(CGPoint)nPoint{
    
    UIWebView * web = (UIWebView *)pWebView;
    //拿到web中用到的两个视图
    UIScrollView * pScrollView = web.scrollView;
    UIView * pBrowserView;
    
    //遍历拿到UIWebBrowserView
    for (UIView * brow in pScrollView.subviews) {
        if ([brow isKindOfClass:NSClassFromString(@"UIWebBrowserView")]) {
            pBrowserView = brow;
            break;
        }
    }
    
    CGPoint locationInWindow = nPoint;
    CGPoint previousLocationInWindow = CGPointMake(_endX, _endY);
    
    [_touchEv setValue:[NSValue valueWithCGPoint:locationInWindow] forKey:@"locationInWindow"];
    [_touchEv setValue:[NSValue valueWithCGPoint:previousLocationInWindow] forKey:@"previousLocationInWindow"];
    
    NSArray * bGestureArray = [pBrowserView gestureRecognizers];
    if (pBrowserView && bGestureArray.count>0)
    {
        //webview的点击手势方法和target是固定的，所以不再调用截取字符串方法
        NSString * actionString  = @"_singleTapRecognized:";
        NSInteger index = [self gainIndexForView:pBrowserView withActionString:actionString];
        UITapGestureRecognizer * gesTap;
        if (index>=0) {
            gesTap = bGestureArray[index];
        }
        
        NSString * scrActString = @"handlePan:";
        NSInteger panIndex = [self gainIndexForView:pScrollView withActionString:scrActString];
        UIPanGestureRecognizer * scrPan;
        if (panIndex>=0) {
            scrPan = pScrollView.gestureRecognizers[panIndex];
            scrPan.maximumNumberOfTouches = 1;
            scrPan.minimumNumberOfTouches = 1;
        }
        
        //创建判断移动和点击的变量
        static BOOL panStatus;
        //状态开始
        if (nGestureRecognizerState == MFWeGestureRecognizerStateBegan) {
            
            //创建touch对象
            //change和end的时候，进行赋值
            [_touchEv setValue:web.window forKey:@"window"];
            [_touchEv setValue:pBrowserView forKey:@"view"];
            [_touchEv setValue:@([NSDate timeIntervalSinceReferenceDate]) forKey:@"timestamp"];
            [_touchEv setValue:@(1) forKey:@"tapCount"];
            [_touchEv setValue:[NSValue valueWithCGPoint:locationInWindow] forKey:@"locationInWindow"];
            [_touchEv setValue:[NSValue valueWithCGPoint:locationInWindow] forKey:@"previousLocationInWindow"];
            [_touchEv setValue:@(UITouchPhaseBegan) forKey:@"phase"];
            
            //将touch对象放到集合中去
            [touchSet addObject:_touchEv];
            
            panStatus = NO;
            
            //记录起始点坐标
            nStartPoint.x = nPoint.x;
            nStartPoint.y = nPoint.y;
            
            //点击手势
            if ([gesTap respondsToSelector:@selector(touchesBegan:withEvent:)]) {
                [gesTap performSelector:@selector(touchesBegan:withEvent:) withObject:touchSet withObject:pTouchEvent];
            }
            
            //平移手势
            if ([scrPan respondsToSelector:@selector(touchesBegan:withEvent:)]) {
                [scrPan performSelector:@selector(touchesBegan:withEvent:) withObject:touchSet withObject:pTouchEvent];
            }
            //记录状态结束点坐标
            _endX = nPoint.x;
            _endY = nPoint.y;
        }
        //状态改变
        else if (nGestureRecognizerState == MFWeGestureRecognizerStateChanged){
            
            [_touchEv setValue:@(UITouchPhaseMoved) forKey:@"phase"];
            [scrPan setTranslation:CGPointMake(nPoint.x - _endX, nPoint.y - _endY) inView:pScrollView];
            
            
            //NSString *jsn = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f)item.parentNode",nPoint.x,nPoint.y];
            //NSString * tagName = [web stringByEvaluatingJavaScriptFromString:jsn];
            //NSLog(@"%@",tagName);
            
            if ([scrPan respondsToSelector:@selector(touchesMoved:withEvent:)]) {
                [scrPan performSelector:@selector(touchesMoved:withEvent:) withObject:touchSet withObject:nil];
            }
            
            if (scrPan) {
                if ([pScrollView respondsToSelector:NSSelectorFromString(scrActString)]) {
                    [pScrollView performSelectorOnMainThread:NSSelectorFromString(scrActString) withObject:scrPan waitUntilDone:NO];
                }
            }
            
            //如果位移点发生变化将布尔置为yes
            if (_endY != nPoint.y || _endX != nPoint.x) {
                _endY = nPoint.y;
                _endX = nPoint.x;
                panStatus = YES;
            }
        }
        else if (nGestureRecognizerState == MFWeGestureRecognizerStateEnded){
            
            [_touchEv setValue:@(UITouchPhaseEnded) forKey:@"phase"];
            [scrPan setTranslation:CGPointMake(0, 0) inView:pScrollView];
            
            //将手势touchEnd，结束点击
            if ([scrPan respondsToSelector:@selector(touchesEnded:withEvent:)]) {
                [scrPan performSelector:@selector(touchesEnded:withEvent:) withObject:touchSet withObject:nil];
            }
            
            //如果没有发生改变，响应点击手势
            if(!panStatus)
            {
                NSString *jsn = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName",nPoint.x,nPoint.y];
                NSString * tagName = [web stringByEvaluatingJavaScriptFromString:jsn];
                if (tagName.length > 0 && ![tagName isEqualToString:@"LI"]&&![tagName isEqualToString:@"INPUT"]&&![tagName isEqualToString:@"IFRAME"]) {
                    NSString * inpS = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).click({clientX:%f,clientY:%f})",nPoint.x,nPoint.y,nPoint.x,nPoint.y];
                    [web stringByEvaluatingJavaScriptFromString:inpS];
                    
                }else{
                    //对点击手势进行判断，确定浏览器是否响应事件
                    if ([gesTap respondsToSelector:@selector(touchesEnded:withEvent:)]) {
                        [gesTap performSelector:@selector(touchesEnded:withEvent:) withObject:touchSet withObject:nil];
                    }
                }
            }else{
                
                if (scrPan) {
                    if ([pScrollView respondsToSelector:NSSelectorFromString(scrActString)]) {
                        [pScrollView performSelectorOnMainThread:NSSelectorFromString(scrActString) withObject:scrPan waitUntilDone:NO];
                    }
                }
            }
            
        }
    }
}


//控件滑动响应（包括UIScrollView、UITableView、UICollectionView、UITextView）
-(void)controlDragAction:(UIView*)pControlView withPoint:(CGPoint)nPoint withGestureRecognizer:(MFWeGestureRecognizerState)nGestureRecognizerState
{
#if 0  //手势滑动
    static BOOL isDelay=NO;
    if ([pControlView isKindOfClass:[UIScrollView class]])
    {
        UIScrollView* pTempDragView = (UIScrollView*)pControlView;
        
        NSArray* gestures = [pControlView gestureRecognizers];
        if (gestures) {
            UIPanGestureRecognizer *panGes;
            UIGestureRecognizer * delayGes;
            for (UIGestureRecognizer* ges in gestures) {
                if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
                    panGes = (UIPanGestureRecognizer*)ges;
                    
                }else if ([ges isKindOfClass:NSClassFromString(@"UIScrollViewDelayedTouchesBeganGestureRecognizer")]){
                    delayGes = ges;
                }
            }
            
            if (panGes) {
                NSString * scrActString = @"handlePan:";
                NSString * delayActString = @"delayed;";
                panGes.maximumNumberOfTouches = 1;
                panGes.minimumNumberOfTouches = 1;
                
                CGPoint locationInWindow = nPoint;
                CGPoint previousLocationInWindow = CGPointMake(_endX, _endY);
                
                if (nGestureRecognizerState == MFWeGestureRecognizerStateBegan) {
                    [_touchEv setValue:pControlView.window forKey:@"window"];
                    [_touchEv setValue:pControlView forKey:@"view"];
                    [_touchEv setValue:@([NSDate timeIntervalSinceReferenceDate]) forKey:@"timestamp"];
                    [_touchEv setValue:@(1) forKey:@"tapCount"];
                    [_touchEv setValue:[NSValue valueWithCGPoint:locationInWindow] forKey:@"locationInWindow"];
                    [_touchEv setValue:[NSValue valueWithCGPoint:previousLocationInWindow] forKey:@"previousLocationInWindow"];
                    [_touchEv setValue:@(UITouchPhaseBegan) forKey:@"phase"];
                    
                    //将touch对象放到集合中去
                    [touchSet addObject:_touchEv];
                    
                    //平移手势
                    if ([panGes respondsToSelector:@selector(touchesBegan:withEvent:)]) {
                        [panGes performSelector:@selector(touchesBegan:withEvent:) withObject:touchSet withObject:pTouchEvent];
                    }
                    
                    _endX = nPoint.x;
                    _endY = nPoint.y;
                }
                //状态改变
                else if (nGestureRecognizerState == MFWeGestureRecognizerStateChanged){
                    
                    [_touchEv setValue:@(UITouchPhaseMoved) forKey:@"phase"];
                    [_touchEv setValue:[NSValue valueWithCGPoint:locationInWindow] forKey:@"locationInWindow"];
                    [_touchEv setValue:[NSValue valueWithCGPoint:previousLocationInWindow] forKey:@"previousLocationInWindow"];
                    [_touchEv setValue:@([NSDate timeIntervalSinceReferenceDate]) forKey:@"timestamp"];
                    [panGes setTranslation:CGPointMake(nPoint.x - _endX, nPoint.y - _endY) inView:pControlView];
                    
                    if ([panGes respondsToSelector:@selector(touchesMoved:withEvent:)]) {
                        [panGes performSelector:@selector(touchesMoved:withEvent:) withObject:touchSet withObject:nil];
                    }
                    
                    if ([pTempDragView respondsToSelector:NSSelectorFromString(scrActString)]) {
                        [pTempDragView performSelectorOnMainThread:NSSelectorFromString(scrActString) withObject:panGes waitUntilDone:NO];
                    }
                    
                    //如果位移点发生变化将布尔置为yes
                    if (_endY != nPoint.y || _endX != nPoint.x) {
                        _endY = nPoint.y;
                        _endX = nPoint.x;
                        if (isDelay) {
                            if ([delayGes respondsToSelector:@selector(touchesEnded:withEvent:)]) {
                                [delayGes performSelector:@selector(touchesEnded:withEvent:) withObject:touchSet withObject:nil];
                            }
                            if ([pTempDragView respondsToSelector:NSSelectorFromString(delayActString)]) {
                                [pTempDragView performSelectorOnMainThread:NSSelectorFromString(delayActString) withObject:@NO waitUntilDone:NO];
                            }
                            isDelay = NO;
                        }
                        
                    }else{
                        if (delayGes) {
                            if ([delayGes respondsToSelector:@selector(touchesBegan:withEvent:)]) {
                                [delayGes performSelector:@selector(touchesBegan:withEvent:) withObject:touchSet withObject:pTouchEvent];
                                isDelay = YES;
                            }
                            if ([pTempDragView respondsToSelector:NSSelectorFromString(delayActString)]) {
                                [pTempDragView performSelectorOnMainThread:NSSelectorFromString(delayActString) withObject:@YES waitUntilDone:NO];
                            }
                        }
                    }
                }
                else if (nGestureRecognizerState == MFWeGestureRecognizerStateEnded){
                    isDelay = NO;
                    [_touchEv setValue:@(UITouchPhaseEnded) forKey:@"phase"];
                    [_touchEv setValue:[NSValue valueWithCGPoint:locationInWindow] forKey:@"locationInWindow"];
                    [_touchEv setValue:[NSValue valueWithCGPoint:previousLocationInWindow] forKey:@"previousLocationInWindow"];
                    [_touchEv setValue:@([NSDate timeIntervalSinceReferenceDate]) forKey:@"timestamp"];
                    //[panGes setTranslation:CGPointMake(0, 0) inView:pControlView];
                    
                    //将手势touchEnd，结束点击
                    if ([panGes respondsToSelector:@selector(touchesEnded:withEvent:)]) {
                        [panGes performSelector:@selector(touchesEnded:withEvent:) withObject:touchSet withObject:nil];
                    }
                }
                return;
            }
        }
    }
#elif 0 //scrollView滑动
    if ([pControlView isKindOfClass:[UIScrollView class]])
    {
        UIScrollView* pTempDragView = (UIScrollView*)pControlView;
        CGSize nViewContentSize = pTempDragView.contentSize;
        CGRect nViewBound = pTempDragView.bounds;
        BOOL isVertical = FALSE;
        BOOL isHorizontal = FALSE;
        if (!pTempDragView.alwaysBounceHorizontal && !pTempDragView.alwaysBounceVertical) {
            isVertical = TRUE;
            isHorizontal = TRUE;
            if (nViewContentSize.width == 0) {
                isHorizontal = FALSE;
            }
            if (nViewContentSize.height == 0) {
                isVertical = FALSE;
            }
        } else {
            if (pTempDragView.alwaysBounceVertical) {
                isVertical = TRUE;
                if (nViewContentSize.height == 0) {
                    isVertical = FALSE;
                }
            }
            if (pTempDragView.alwaysBounceHorizontal) {
                isHorizontal = TRUE;
                if (nViewContentSize.width == 0) {
                    isHorizontal = FALSE;
                }
            }
        }
        if (nGestureRecognizerState == MFWeGestureRecognizerStateBegan)
        {
            //nControlIsClick = NO;
            nControlIsClick = YES;
            
            _differenceX = 0;
            _differenceY = 0;
            _DragValueX = pTempDragView.contentOffset.x;
            _DragValueY = pTempDragView.contentOffset.y;
            
            nStartPoint.x = nPoint.x;
            nStartPoint.y = nPoint.y;
        }
        else if(nGestureRecognizerState == MFWeGestureRecognizerStateChanged)
        {
            _differenceX = _startX - nPoint.x;
            _differenceY = _startY - nPoint.y;
            
            _startX = nPoint.x;
            _startY = nPoint.y;
            
            if (nControlIsClick != NO) {
                CGFloat touchSlop = [[UIScreen mainScreen] scale] * 8;
                CGFloat yDiff = fabs(nPoint.y - nStartPoint.y);
                CGFloat xDiff = fabs(nPoint.x - nStartPoint.x);
                if (yDiff > touchSlop) {
                    nControlIsClick = NO;
                }
                if (xDiff > touchSlop) {
                    nControlIsClick = NO;
                }
            }
            
            if (nControlIsClick == NO) {
                if (isHorizontal)
                {
//                    if (pTempDragView.contentOffset.x + nViewBound.size.width + _differenceX >= nViewContentSize.width)
//                    {
//                        _DragValueX = nViewContentSize.width - (pTempDragView.contentOffset.x + nViewBound.size.width + _differenceX - nViewContentSize.width);
//                    }
//                    else if (pTempDragView.contentOffset.x + _differenceX <= 0)
//                    {
//                        _DragValueX = 0;
//                    }
//                    else
//                    {
//                        _DragValueX += _differenceX;
//                    }
                    _DragValueX += _differenceX;
//                    if (_DragValueX < 0)
//                    {
//                        _DragValueX = 0;
//                    }
//                    else if(_DragValueX >= nViewContentSize.width - nViewBound.size.width)
//                    {
//                        _DragValueX = nViewContentSize.width - nViewBound.size.width;
//                    }
//                    
//                    if (nViewContentSize.width <= nViewBound.size.width)
//                    {
//                        _DragValueX = 0;
//                    }
                }
                if (isVertical)
                {
//                    if (pTempDragView.contentOffset.y + nViewBound.size.height + _differenceY >= nViewContentSize.height)
//                    {
//                        _DragValueY = nViewContentSize.height - (pTempDragView.contentOffset.y + nViewBound.size.height + _differenceY - nViewContentSize.height);
//                    }
//                    else if (pTempDragView.contentOffset.y + _differenceY <= 0)
//                    {
//                        _DragValueY = 0;
//                    }
//                    else
//                    {
//                        _DragValueY += _differenceY;
//                    }
                    _DragValueY += _differenceY;

                    
//                    if (_DragValueY < 0)
//                    {
//                        _DragValueY = 0;
//                    }
//                     if(_DragValueY >= nViewContentSize.height - nViewBound.size.height)
//                    {
//                        _DragValueY = nViewContentSize.height - nViewBound.size.height;
//                    }
                    
//                    if (nViewContentSize.height <= nViewBound.size.height)
//                    {
//                        _DragValueY = 0;
//                    }
                }
                
                CGPoint contentOffset = CGPointMake(_DragValueX, _DragValueY);
                pTempDragView.contentOffset = contentOffset;
            }
        }
        else if(nGestureRecognizerState == MFWeGestureRecognizerStateEnded)
        {
            _differenceX = _startX - nPoint.x;
            _differenceY = _startY - nPoint.y;
            
            if (nControlIsClick != NO) {
                CGFloat touchSlop = [[UIScreen mainScreen] scale] * 8;
                CGFloat yDiff = fabs(nPoint.y - nStartPoint.y);
                CGFloat xDiff = fabs(nPoint.x - nStartPoint.x);
                if (yDiff > touchSlop || xDiff > touchSlop) {
                    nControlIsClick = NO;
                }
            }
            
            /*
             if(((_endX - nStartPoint.x <= 1 ) && (_endX - nStartPoint.x >= -1 ))  && ((_endY - nStartPoint.y <= 1) && (_endY - nStartPoint.y >= -1 )))
             {
             nControlIsClick = YES;
             }
             */
            if (nControlIsClick == NO) {
                if (isHorizontal)
                {
//                    if (pTempDragView.contentOffset.x + nViewBound.size.width + _differenceX >= nViewContentSize.width)
//                    {
//                        _DragValueX = nViewContentSize.width - (pTempDragView.contentOffset.x + nViewBound.size.width + _differenceX - nViewContentSize.width);
//                    }
//                    else if (pTempDragView.contentOffset.x + _differenceX <= 0)
//                    {
//                        _DragValueX = 0;
//                    }
//                    else
//                    {
                        _DragValueX += _differenceX;
//                    }
                    
//                    if (_DragValueX < 0)
//                    {
//                        _DragValueX = 0;
//                    }
//                    else if(_DragValueX >= nViewContentSize.width - nViewBound.size.width)
//                    {
//                        _DragValueX = nViewContentSize.width - nViewBound.size.width;
//                    }
//                    
//                    
//                    if (nViewContentSize.width <= nViewBound.size.width)
//                    {
//                        _DragValueX = 0;
//                    }
                    
                    CGFloat segX = (int)(_DragValueX / pTempDragView.frame.size.width) * pTempDragView.frame.size.width;
                    _DragValueX = segX;
                    if (nStartPoint.x - nPoint.x > pTempDragView.frame.size.width / 3) {
                        _DragValueX = segX + pTempDragView.frame.size.width;
                    } else if (nPoint.x - nStartPoint.x > pTempDragView.frame.size.width / 3) {
                        _DragValueX = segX - pTempDragView.frame.size.width;
                    }
//                    if (_DragValueX < 0)
//                    {
//                        _DragValueX = 0;
//                    }
//                    else if(_DragValueX >= nViewContentSize.width - nViewBound.size.width)
//                    {
//                        _DragValueX = nViewContentSize.width - nViewBound.size.width;
//                    }
                }
                if (isVertical)
                {
//                    if (pTempDragView.contentOffset.y + nViewBound.size.height + _differenceY >= nViewContentSize.height)
//                    {
//                        _DragValueY = nViewContentSize.height - (pTempDragView.contentOffset.y + nViewBound.size.height + _differenceY - nViewContentSize.height);
//                    }
//                    else if (pTempDragView.contentOffset.y + _differenceY <= 0)
//                    {
//                        _DragValueY = 0;
//                    }
//                    else
//                    {
                        _DragValueY += _differenceY;
//                    }
                    
//                    if (_DragValueY < 0)
//                    {
//                        _DragValueY = 0;
//                    }
//                    else if(_DragValueY >= nViewContentSize.height - nViewBound.size.height)
//                    {
//                        _DragValueY = nViewContentSize.height - nViewBound.size.height;
//                    }
//                    
//                    
//                    if (nViewContentSize.height <= nViewBound.size.height)
//                    {
//                        _DragValueY = 0;
//                    }
                }
                
                if (isHorizontal) {
                    [UIView animateWithDuration:0.25 animations:^{
                        pTempDragView.contentOffset = CGPointMake(_DragValueX, _DragValueY);
                    }];
                } else {
                    CGPoint contentOffset = CGPointMake(_DragValueX, _DragValueY);
                    pTempDragView.contentOffset = contentOffset;
                }
            }
            
            _startX = 0;
            _startY = 0;
            _endX = 0;
            _endY = 0;
        }
    }

#else //两个合并做
    if ([pControlView isKindOfClass:[UIScrollView class]])
    {
        UIScrollView* pTempDragView = (UIScrollView*)pControlView;
        CGSize nViewContentSize = pTempDragView.contentSize;
        CGRect nViewBound = pTempDragView.bounds;
        NSArray* gestures = [pControlView gestureRecognizers];
        BOOL isVertical = FALSE;
        BOOL isHorizontal = FALSE;
        
        if (!pTempDragView.alwaysBounceHorizontal && !pTempDragView.alwaysBounceVertical) {
            isVertical = TRUE;
            isHorizontal = TRUE;
            if (nViewContentSize.width == 0) {
                isHorizontal = FALSE;
            }
            if (nViewContentSize.height == 0) {
                isVertical = FALSE;
            }
        } else {
            if (pTempDragView.alwaysBounceVertical) {
                isVertical = TRUE;
                if (nViewContentSize.height == 0) {
                    isVertical = FALSE;
                }
            }
            if (pTempDragView.alwaysBounceHorizontal) {
                isHorizontal = TRUE;
                if (nViewContentSize.width == 0) {
                    isHorizontal = FALSE;
                }
            }
        }
        
        if (gestures) {
            //移动手势控制滑动开始和结束
            UIPanGestureRecognizer *panGes;
            
            for (UIGestureRecognizer* ges in gestures) {
                if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
                    panGes = (UIPanGestureRecognizer*)ges;
                    break;
                }
            }
            
            if (panGes) {
                NSString * scrActString = @"handlePan:";
                panGes.maximumNumberOfTouches = 1;
                panGes.minimumNumberOfTouches = 1;
                
                //设置平移手势坐标
                CGPoint locationInWindow = nPoint;
                CGPoint previousLocationInWindow = CGPointMake(_endX, _endY);

                [_touchEv setValue:[NSValue valueWithCGPoint:locationInWindow] forKey:@"locationInWindow"];
                [_touchEv setValue:[NSValue valueWithCGPoint:previousLocationInWindow] forKey:@"previousLocationInWindow"];
                
                if (nGestureRecognizerState == MFWeGestureRecognizerStateBegan) {
                    
                    nControlIsClick = YES; //记录点击还是滑动
                    
                    _differenceX = 0;  //记录移动点x
                    _differenceY = 0;  //记录移动点y
                    _DragValueX = pTempDragView.contentOffset.x; //记录偏移量x
                    _DragValueY = pTempDragView.contentOffset.y; //记录偏移量y
                    
                    //touch赋值
                    [_touchEv setValue:pControlView.window forKey:@"window"];
                    [_touchEv setValue:pControlView forKey:@"view"];
                    [_touchEv setValue:@(1) forKey:@"tapCount"];
                    [_touchEv setValue:@(UITouchPhaseBegan) forKey:@"phase"];
                    [_touchEv setValue:@([NSDate timeIntervalSinceReferenceDate]) forKey:@"timestamp"];
                    
                    [_touchEv setValue:[NSValue valueWithCGPoint:locationInWindow] forKey:@"locationInWindow"];
                    [_touchEv setValue:[NSValue valueWithCGPoint:locationInWindow] forKey:@"previousLocationInWindow"];
                    
                    //将touch对象放到集合中去
                    [touchSet addObject:_touchEv];
                    
                    //平移手势
                    if ([panGes respondsToSelector:@selector(touchesBegan:withEvent:)]) {
                        [panGes performSelector:@selector(touchesBegan:withEvent:) withObject:touchSet withObject:pTouchEvent];
                    }
                    NSLog(@"touchesBegan %@",_touchEv);
                    //记录起始点坐标
                    nStartPoint.x = nPoint.x;
                    nStartPoint.y = nPoint.y;
                    
                    _endX = nPoint.x;   //记录上一次移动点位坐标x
                    _endY = nPoint.y;   //记录上一次移动点位坐标y
                
                }
                //状态改变
                else if (nGestureRecognizerState == MFWeGestureRecognizerStateChanged){
                    
                    _differenceX = _endX - nPoint.x; //当前点距上一点的x位置
                    _differenceY = _endY - nPoint.y; //当前点距上一点的y位置
                    _endX = nPoint.x;
                    _endY = nPoint.y;
                    
                    if (nControlIsClick != NO) {
                        CGFloat touchSlop = [[UIScreen mainScreen] scale] * 8;
                        //通过绝对路径范围判读是点击还是滑动
                        CGFloat yDiff = fabs(nPoint.y - nStartPoint.y);
                        CGFloat xDiff = fabs(nPoint.x - nStartPoint.x);
                        if (yDiff > touchSlop) {
                            nControlIsClick = NO;
                        }
                        if (xDiff > touchSlop) {
                            nControlIsClick = NO;
                        }
                    }
                    
                    //如果是滑动执行滑动
                    if (nControlIsClick == NO) {
                        if (isHorizontal)
                        {
                            if (pTempDragView.contentOffset.x + nViewBound.size.width > nViewContentSize.width)
                            {
                                _DragValueX = _DragValueX + _differenceX/(pTempDragView.contentOffset.x+nViewBound.size.width-nViewContentSize.width);
                            }
                            else if (pTempDragView.contentOffset.x < 0)
                            {
                                _DragValueX = _DragValueX+_differenceX/(0-pTempDragView.contentOffset.x);
                            }
                            else
                            {
                                _DragValueX += _differenceX;
                            }
                        }
                        if (isVertical)
                        {
                            if (pTempDragView.contentOffset.y + nViewBound.size.height > nViewContentSize.height)
                            {
                                _DragValueY = _DragValueY + _differenceY/(pTempDragView.contentOffset.y+nViewBound.size.height-nViewContentSize.height);
                            }
                            else if (pTempDragView.contentOffset.y <0)
                            {
                                _DragValueY = _DragValueY+_differenceY/(0-pTempDragView.contentOffset.y);
                            }
                            else
                            {
                                _DragValueY += _differenceY;
                            }
                        }
                        
                        CGPoint contentOffset = CGPointMake(_DragValueX, _DragValueY);
                        pTempDragView.contentOffset = contentOffset;
                        [_touchEv setValue:@(UITouchPhaseMoved) forKey:@"phase"];
                        
                        if ([panGes respondsToSelector:@selector(touchesMoved:withEvent:)]) {
                            [panGes performSelector:@selector(touchesMoved:withEvent:) withObject:touchSet withObject:nil];
                        }
                        if (panGes) {
                            if ([pControlView respondsToSelector:NSSelectorFromString(scrActString)]) {
                                [pControlView performSelectorOnMainThread:NSSelectorFromString(scrActString) withObject:panGes waitUntilDone:NO];
                            }
                        }
                    }
                    
                }
                else if (nGestureRecognizerState == MFWeGestureRecognizerStateEnded){
                    
                    [_touchEv setValue:@(UITouchPhaseEnded) forKey:@"phase"];
//                    [_touchEv setValue:[NSValue valueWithCGPoint:locationInWindow] forKey:@"locationInWindow"];
//                    [_touchEv setValue:[NSValue valueWithCGPoint:locationInWindow] forKey:@"previousLocationInWindow"];
                    
                    //将手势touchEnd，结束点击
                    if ([panGes respondsToSelector:@selector(touchesEnded:withEvent:)]) {
                        [panGes performSelector:@selector(touchesEnded:withEvent:) withObject:touchSet withObject:nil];
                    }
                    
                    NSLog(@"touchesEnd %@",_touchEv);;
                }
                _startX = 0;
                _startY = 0;
                _endX = 0;
                _endY = 0;
            }
        }
    }
#endif
}

//控件视图在主视图中的坐标值
-(CGPoint) ControlViewStartCoordinate:(UIView*)pSubControlView
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [pSubControlView convertRect:pSubControlView.bounds toView:window];
    nCoordinatePoint_y = rect.origin.y;
    nCoordinatePoint_x = rect.origin.x;
    return CGPointMake(nCoordinatePoint_x, nCoordinatePoint_y);
    /*
     UIWindow *window = [[UIApplication sharedApplication] keyWindow];
     UIView* pMainControlView = window.rootViewController.view;
     
     nCoordinatePoint_y = 0.0;
     nCoordinatePoint_x = 0.0;
     
     if (!pSubControlView || !pMainControlView)
     {
     return CGPointZero;
     }
     
     BOOL bIsFindView = NO;
     for(UIView* pSubTempView in pMainControlView.subviews)
     {
     if (pSubControlView == pSubTempView)
     {
     //[_debugDelegate onDebugText:@"-----找到了控件视图--------"];
     bIsFindView = YES;
     nCoordinatePoint_x += pSubTempView.frame.origin.x;
     nCoordinatePoint_y += pSubTempView.frame.origin.y;
     
     return CGPointMake(nCoordinatePoint_x, nCoordinatePoint_y);
     }
     }
     if (!bIsFindView)
     {
     nCoordinatePoint_x += pSubControlView.frame.origin.x;
     nCoordinatePoint_y += pSubControlView.frame.origin.y;
     if (pSubControlView.superview)
     {
     [self ControlViewStartCoordinate:pSubControlView.superview];
     }
     
     }
     return CGPointMake(nCoordinatePoint_x, nCoordinatePoint_y);
     */
}

- (UIViewController*)findWidgetViewController:(UIView*)view
{
    for (UIView* next = view; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

//MotionClass处理函数
-(void)motionClassHandleFun:(UIView*)pMotionClass withGestureRecognizer:(MFWeGestureRecognizerState)nGestureRecognizerState withTouchPoint:(CGPoint)nPonit
{
    
#pragma mark 原来写的
#if 0  //原来写法
    [_touchEv setValue:[NSNumber numberWithInt:1] forKey:@"tapCount"];
    [_touchEv setValue:pMotionClass forKey:@"view"];
    [_touchEv setValue:[NSValue valueWithCGPoint:nPonit] forKey:@"locationInWindow"];
    
    /*
     switch (nGestureRecognizerState) {
     case WeGestureRecognizerStateBegan:
     [_touchEv setValue:@(UITouchPhaseBegan) forKey:@"phase"];
     break;
     case WeGestureRecognizerStateChanged:
     [_touchEv setValue:@(UITouchPhaseMoved) forKey:@"phase"];
     break;
     case WeGestureRecognizerStateEnded:
     [_touchEv setValue:@(UITouchPhaseEnded) forKey:@"phase"];
     break;
     default:
     break;
     }
     */
    
    NSSet *set = [NSSet setWithObjects:_touchEv, nil];
    
    switch (nGestureRecognizerState) {
        case MFWeGestureRecognizerStateBegan:
        {
            [pMotionClass touchesBegan:set withEvent:pTouchEvent];
            
            
            UITouch * touch =({
                UITouch * tou = [[UITouch alloc]init];
                
                CGPoint locationInWindow = nPonit;
                CGPoint previousLocationInWindow = nPonit;
                [tou setValue:@(UITouchPhaseBegan) forKey:@"phase"];
                [tou setValue:[[UIApplication sharedApplication] keyWindow] forKey:@"window"];
                [tou setValue:@([NSDate timeIntervalSinceReferenceDate]) forKey:@"timestamp"];
                [tou setValue:pMotionClass forKey:@"view"];
                [tou setValue:@(1) forKey:@"tapCount"];
                [tou setValue:[NSValue valueWithCGPoint:locationInWindow] forKey:@"locationInWindow"];
                [tou setValue:[NSValue valueWithCGPoint:previousLocationInWindow] forKey:@"previousLocationInWindow"];
                tou;
            });
            _motionClassTouch = touch;
            
            id class = NSClassFromString(@"UITouchesEvent");
            _motionClassEvent = [[class alloc] init];
            
            if (_motionClassSet && _motionClassSet.count > 0) {
                [_motionClassSet removeAllObjects];
            }
            [_motionClassSet addObject:_motionClassTouch];
            
            
            [_motionClassEvent setValue:_motionClassSet forKey:@"_touches"];
            [_motionClassEvent setValue:@([self dateSinceMiddleNight]) forKey:@"timestamp"];
            NSArray* pGestures = [pMotionClass gestureRecognizers];
            if (pGestures && pGestures.count > 0)
            {
                int count = (int)pGestures.count;
                for (int i = 0; i < count; i++) {
                    UIGestureRecognizer *recognizer = [pGestures objectAtIndex:i];
                    
                    @try {
                        if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]/* || [recognizer isKindOfClass:[UIPanGestureRecognizer class]]*/) {
                            if ([recognizer respondsToSelector:@selector(touchesBegan:withEvent:)]) {
                                [recognizer performSelector:@selector(touchesBegan:withEvent:) withObject:_motionClassSet withObject:pTouchEvent];
                            }
                        }
                        else if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
                            if ([recognizer respondsToSelector:@selector(touchesBegan:withEvent:)]) {
                                [recognizer performSelector:@selector(touchesBegan:withEvent:) withObject:_motionClassSet withObject:pTouchEvent];
                            }
                        }
                    } @catch (NSException *exception) {
                        
                    } @finally {
                        
                    }
                }
            }
            break;
        }
        case MFWeGestureRecognizerStateChanged:
        {
            [pMotionClass touchesMoved:set withEvent:pTouchEvent];
            
            if (_motionClassEvent) {
                [_motionClassTouch setValue:[NSValue valueWithCGPoint:nPonit] forKey:@"locationInWindow"];
                [_motionClassTouch setValue:[NSValue valueWithCGPoint:nPonit] forKey:@"previousLocationInWindow"];
                [_motionClassTouch setValue:@(UITouchPhaseMoved) forKey:@"phase"];
                [_motionClassEvent setValue:@([self dateSinceMiddleNight]) forKey:@"timestamp"];
                NSArray* pGestures = [pMotionClass gestureRecognizers];
                if (pGestures && pGestures.count > 0)
                {
                    int count = (int)pGestures.count;
                    for (int i = 0; i < count; i++) {
                        UIGestureRecognizer *recognizer = [pGestures objectAtIndex:i];
                        
                        @try {
                            if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]/* || [recognizer isKindOfClass:[UIPanGestureRecognizer class]]*/) {
                                if ([recognizer respondsToSelector:@selector(touchesMoved:withEvent:)]) {
                                    [recognizer performSelector:@selector(touchesMoved:withEvent:) withObject:_motionClassSet withObject:nil];
                                }
                            }
                            else if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
                                if ([recognizer respondsToSelector:@selector(touchesMoved:withEvent:)]) {
                                    [recognizer performSelector:@selector(touchesMoved:withEvent:) withObject:_motionClassSet withObject:nil];
                                }
                            }
                        } @catch (NSException *exception) {
                            
                        } @finally {
                            
                        }
                    }
                }
            }
            break;
        }
        case MFWeGestureRecognizerStateEnded:
        {
            [pMotionClass touchesEnded:set withEvent:pTouchEvent];
            
            if (_motionClassEvent) {
                [_motionClassTouch setValue:[NSValue valueWithCGPoint:nPonit] forKey:@"locationInWindow"];
                [_motionClassTouch setValue:[NSValue valueWithCGPoint:nPonit] forKey:@"previousLocationInWindow"];
                [_motionClassTouch setValue:@(UITouchPhaseEnded) forKey:@"phase"];
                [_motionClassEvent setValue:@([self dateSinceMiddleNight]) forKey:@"timestamp"];
                NSArray* pGestures = [pMotionClass gestureRecognizers];
                if (pGestures && pGestures.count > 0)
                {
                    UILongPressGestureRecognizer *lpGR;
                    UITapGestureRecognizer *tapGR;
                    UITapGestureRecognizer *tap2GR;
                    int count = (int)pGestures.count;
                    for (int i = 0; i < count; i++) {
                        UIGestureRecognizer *recognizer = [pGestures objectAtIndex:i];
                        @try {
                            if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]/* || [recognizer isKindOfClass:[UIPanGestureRecognizer class]]*/) {
                                lpGR = (UILongPressGestureRecognizer*)recognizer;
                            }
                            else if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
                                NSString *descStr = [recognizer description];
                                if ([descStr containsString:@"numberOfTapsRequired = 2"]) {
                                    tap2GR = (UITapGestureRecognizer*)recognizer;
                                } else {
                                    tapGR = (UITapGestureRecognizer*)recognizer;
                                }
                            }
                        } @catch (NSException *exception) {
                        } @finally {
                        }
                    }
                    BOOL isCancelTap = NO;
                    if (lpGR) {
                        if ([lpGR state] == UIGestureRecognizerStateBegan) {
                            isCancelTap = YES;
                        }
                        if ([lpGR respondsToSelector:@selector(touchesEnded:withEvent:)]) {
                            [lpGR performSelector:@selector(touchesEnded:withEvent:) withObject:_motionClassSet withObject:nil];
                        }
                    }
                    if (isCancelTap == YES) {
                        [_motionClassTouch setValue:@(UITouchPhaseCancelled) forKey:@"phase"];
                        if (tapGR) {
                            if ([tapGR respondsToSelector:@selector(touchesCancelled:withEvent:)]) {
                                [tapGR performSelector:@selector(touchesCancelled:withEvent:) withObject:_motionClassSet withObject:nil];
                            }
                        }
                        if (tap2GR) {
                            if ([tap2GR respondsToSelector:@selector(touchesCancelled:withEvent:)]) {
                                [tap2GR performSelector:@selector(touchesCancelled:withEvent:) withObject:_motionClassSet withObject:nil];
                            }
                        }
                    } else {
                        if (tapGR) {
                            if ([tapGR respondsToSelector:@selector(touchesEnded:withEvent:)]) {
                                [tapGR performSelector:@selector(touchesEnded:withEvent:) withObject:_motionClassSet withObject:nil];
                            }
                        }
                        if (tap2GR) {
                            if ([tap2GR respondsToSelector:@selector(touchesEnded:withEvent:)]) {
                                [tap2GR performSelector:@selector(touchesEnded:withEvent:) withObject:_motionClassSet withObject:nil];
                            }
                        }
                    }
                }
                //                _motionClassEvent = nil;
                //                _motionClassTouch = nil;
                //                _motionClassSet = nil;
            }
            break;
        }
        default:
            break;
    }
    
#else  // 更新写法
#pragma mark 更新写法
    
    switch (nGestureRecognizerState) {
        case MFWeGestureRecognizerStateBegan:
        {
            UITouch * touch =({
                UITouch * tou = [[UITouch alloc]init];
                
                CGPoint locationInWindow = nPonit;
                CGPoint previousLocationInWindow = nPonit;
                [tou setValue:@(UITouchPhaseBegan) forKey:@"phase"];
                [tou setValue:[[UIApplication sharedApplication] keyWindow] forKey:@"window"];
                [tou setValue:pMotionClass forKey:@"view"];
                [tou setValue:@([NSDate timeIntervalSinceReferenceDate]) forKey:@"timestamp"];
                [tou setValue:@(1) forKey:@"tapCount"];
                [tou setValue:[NSValue valueWithCGPoint:locationInWindow] forKey:@"locationInWindow"];
                [tou setValue:[NSValue valueWithCGPoint:previousLocationInWindow] forKey:@"previousLocationInWindow"];
                tou;
            });
            _motionClassTouch = touch;
            if (_motionClassSet && _motionClassSet.count > 0) {
                [_motionClassSet removeAllObjects];
            }
            [_motionClassSet addObject:_motionClassTouch];
            
            [_motionClassEvent setValue:_motionClassSet forKey:@"_touches"];
            [_motionClassEvent setValue:@([self dateSinceMiddleNight]) forKey:@"timestamp"];
            
            [pMotionClass touchesBegan:_motionClassSet withEvent:_motionClassEvent];
            
            NSArray* pGestures = [pMotionClass gestureRecognizers];
            if (pGestures && pGestures.count > 0)
            {
                int count = (int)pGestures.count;
                for (int i = 0; i < count; i++) {
                    UIGestureRecognizer *recognizer = [pGestures objectAtIndex:i];
                    
                    @try {
                        if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]/* || [recognizer isKindOfClass:[UIPanGestureRecognizer class]]*/) {
                            if ([recognizer respondsToSelector:@selector(touchesBegan:withEvent:)]) {
                                [recognizer performSelector:@selector(touchesBegan:withEvent:) withObject:_motionClassSet withObject:pTouchEvent];
                            }
                        }
                        else if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
                            if ([recognizer respondsToSelector:@selector(touchesBegan:withEvent:)]) {
                                [recognizer performSelector:@selector(touchesBegan:withEvent:) withObject:_motionClassSet withObject:pTouchEvent];
                            }
                        }
                    } @catch (NSException *exception) {
                        
                    } @finally {
                        
                    }
                }
            }
            break;
        }
        case MFWeGestureRecognizerStateChanged:
        {
            if (_motionClassTouch) {
                [_motionClassTouch setValue:[NSValue valueWithCGPoint:nPonit] forKey:@"locationInWindow"];
                [_motionClassTouch setValue:[NSValue valueWithCGPoint:nPonit] forKey:@"previousLocationInWindow"];
                [_motionClassTouch setValue:@(UITouchPhaseMoved) forKey:@"phase"];
                
                [pMotionClass touchesMoved:_motionClassSet withEvent:_motionClassEvent];
                
                NSArray* pGestures = [pMotionClass gestureRecognizers];
                if (pGestures && pGestures.count > 0)
                {
                    int count = (int)pGestures.count;
                    for (int i = 0; i < count; i++) {
                        UIGestureRecognizer *recognizer = [pGestures objectAtIndex:i];
                        
                        @try {
                            if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]/* || [recognizer isKindOfClass:[UIPanGestureRecognizer class]]*/) {
                                if ([recognizer respondsToSelector:@selector(touchesMoved:withEvent:)]) {
                                    [recognizer performSelector:@selector(touchesMoved:withEvent:) withObject:_motionClassSet withObject:nil];
                                }
                            }
                            else if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
                                if ([recognizer respondsToSelector:@selector(touchesMoved:withEvent:)]) {
                                    [recognizer performSelector:@selector(touchesMoved:withEvent:) withObject:_motionClassSet withObject:nil];
                                }
                            }
                        } @catch (NSException *exception) {
                            
                        } @finally {
                            
                        }
                    }
                }
            }
            
        }
            break;
        case MFWeGestureRecognizerStateEnded:
        {
            if (_motionClassTouch) {
                [_motionClassTouch setValue:[NSValue valueWithCGPoint:nPonit] forKey:@"locationInWindow"];
                [_motionClassTouch setValue:[NSValue valueWithCGPoint:nPonit] forKey:@"previousLocationInWindow"];
                [_motionClassTouch setValue:@(UITouchPhaseEnded) forKey:@"phase"];
                
                [pMotionClass touchesEnded:_motionClassSet withEvent:_motionClassEvent];
                
                NSArray* pGestures = [pMotionClass gestureRecognizers];
                if (pGestures && pGestures.count > 0)
                {
                    UILongPressGestureRecognizer *lpGR;
                    UITapGestureRecognizer *tapGR;
                    UITapGestureRecognizer *tap2GR;
                    int count = (int)pGestures.count;
                    for (int i = 0; i < count; i++) {
                        UIGestureRecognizer *recognizer = [pGestures objectAtIndex:i];
                        @try {
                            if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]/* || [recognizer isKindOfClass:[UIPanGestureRecognizer class]]*/) {
                                lpGR = (UILongPressGestureRecognizer*)recognizer;
                            }
                            else if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
                                NSString *descStr = [recognizer description];
                                if ([descStr containsString:@"numberOfTapsRequired = 2"]) {
                                    tap2GR = (UITapGestureRecognizer*)recognizer;
                                } else {
                                    tapGR = (UITapGestureRecognizer*)recognizer;
                                }
                            }
                        } @catch (NSException *exception) {
                        } @finally {
                        }
                    }
                    BOOL isCancelTap = NO;
                    if (lpGR) {
                        if ([lpGR state] == UIGestureRecognizerStateBegan) {
                            isCancelTap = YES;
                        }
                        if ([lpGR respondsToSelector:@selector(touchesEnded:withEvent:)]) {
                            [lpGR performSelector:@selector(touchesEnded:withEvent:) withObject:_motionClassSet withObject:nil];
                        }
                    }
                    if (isCancelTap == YES) {
                        [_motionClassTouch setValue:@(UITouchPhaseCancelled) forKey:@"phase"];
                        if (tapGR) {
                            if ([tapGR respondsToSelector:@selector(touchesCancelled:withEvent:)]) {
                                [tapGR performSelector:@selector(touchesCancelled:withEvent:) withObject:_motionClassSet withObject:nil];
                            }
                        }
                        if (tap2GR) {
                            if ([tap2GR respondsToSelector:@selector(touchesCancelled:withEvent:)]) {
                                [tap2GR performSelector:@selector(touchesCancelled:withEvent:) withObject:_motionClassSet withObject:nil];
                            }
                        }
                    } else {
                        if (tapGR) {
                            if ([tapGR respondsToSelector:@selector(touchesEnded:withEvent:)]) {
                                [tapGR performSelector:@selector(touchesEnded:withEvent:) withObject:_motionClassSet withObject:nil];
                            }
                        }
                        if (tap2GR) {
                            if ([tap2GR respondsToSelector:@selector(touchesEnded:withEvent:)]) {
                                [tap2GR performSelector:@selector(touchesEnded:withEvent:) withObject:_motionClassSet withObject:nil];
                            }
                        }
                    }
                }
                //                _motionClassEvent = nil;
                //                _motionClassTouch = nil;
                //                _motionClassSet = nil;
            }
            break;
        }
        default:
            break;
    }
#endif
}

#pragma mark - 获取子视图中的webview
- (UIView *)findWebView
{
    //一次触摸中的webview存在，直接返回，不再寻找
    if (nWebView) {
        return nWebView;
    }
    UIView *webView = nil;
    //取到最上层控制器，遍历子视图，寻找包含触屏点的webview
    UIViewController * topVC = [self topViewController];
    for (UIView * view in topVC.view.subviews)
    {
        webView = [self findWebViewInView:view];
        if (webView)
        {
            nWebView = (UIWebView *)webView;
            return webView;
        }
    }
    return nil;
}

//循环遍历寻找包含触屏的的webView
- (UIView *)findWebViewInView:(UIView *)view
{
    CGRect pPoint = [view.superview convertRect:view.frame toView:view.window];
    CGPoint point = CGPointMake(pTouchPoint.x-pPoint.origin.x, pTouchPoint.y-pPoint.origin.y);
    if ([view.layer containsPoint:point]&&[view isKindOfClass:[UIWebView class]])
    {
        return view;
    }
    for (UIView *subView in [view subviews])
    {
        UIView *tempView = [self findWebViewInView:subView];
        if (tempView)
        {
            return tempView;
        }
    }
    return nil;
}

#pragma mark  获取最上层控制器
- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nav = (UINavigationController*)rootViewController;
        //        return [self topViewControllerWithRootViewController:nav.visibleViewController];
        return [self topViewControllerWithRootViewController:nav.topViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


#pragma mark - 获取手势（web手势有多种，传递需要手势，返回手势内容字典）
-(NSDictionary *)gainGesture:(NSString *)gesture AndActionForView:(UIView *)pView{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    NSArray* pGesture = [pView gestureRecognizers];
    int index;
    if (pGesture && pGesture.count >= 1)
    {
        for (index = 0; index < pGesture.count; index ++) {
            //获取手势描述
            NSString* pGestureString = [NSString stringWithString:[[pGesture objectAtIndex:index] description]];
            
            if (pGestureString && pGestureString.length > 1)
            {
                pGestureString = [pGestureString stringByReplacingOccurrencesOfString:@"<" withString:@""];
                pGestureString = [pGestureString stringByReplacingOccurrencesOfString:@">" withString:@""];
                pGestureString = [pGestureString stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                NSArray* pSubArray = [pGestureString componentsSeparatedByString:@";"];
                if (pSubArray && pSubArray.count >= 1)
                {
                    NSString* pGestureStatusString = [pSubArray objectAtIndex:0];
                    //Tap GestureRecognizer
                    if ([pGestureStatusString hasPrefix:gesture])
                    {
                        [dic setValue:pGestureStatusString forKey:@"pGestureStatusString"];
                        NSMutableString* pTargetString = [NSMutableString string];
                        for (int i = 0; i < pSubArray.count; i++)
                        {
                            NSString* pSubString = [pSubArray objectAtIndex:i];
                            if ([pSubString hasPrefix:@"target="]) {
                                NSRange nTargetRange = [pSubString rangeOfString:@"target="];
                                if(nTargetRange.location < pSubString.length && nTargetRange.length > 1)
                                {
                                    [pTargetString setString:[pSubString substringFromIndex:(nTargetRange.location + nTargetRange.length)]];
                                }
                                break;
                            }
                        }
                        if(pTargetString && pTargetString.length > 1)
                        {
                            NSString* pTargetSubString = [pTargetString stringByReplacingOccurrencesOfString:@"(" withString:@""];
                            pTargetSubString = [pTargetSubString stringByReplacingOccurrencesOfString:@")" withString:@""];
                            
                            
                            NSArray* pTempArray = [pTargetSubString componentsSeparatedByString:@","];
                            if (pTempArray && pTempArray.count >= 1)
                            {
                                for (int j = 0; j < pTempArray.count; j++)
                                {
                                    NSString* pSubString = [pTempArray objectAtIndex:j];
                                    
                                    if ([pSubString hasPrefix:@"action="]) {
                                        NSRange nRange = [pSubString rangeOfString:@"action="];
                                        if (nRange.location < pSubString.length && nRange.length > 0)
                                        {
                                            NSString * pActionString = [pSubString substringFromIndex:(nRange.location + nRange.length)];
                                            [dic setValue:pActionString forKey:@"pActionString"];
                                            
                                        }
                                    }
                                    else if([pSubString hasPrefix:@"target="])
                                    {
                                        NSRange nRange = [pSubString rangeOfString:@"target="];
                                        if (nRange.location < pSubString.length && nRange.length > 0)
                                        {
                                            NSString* pTempTarStr = [pSubString substringFromIndex:(nRange.location + nRange.length)];
                                            
                                            NSRange nHexRange = [pTempTarStr rangeOfString:@"0x"];
                                            
                                            if (nHexRange.location < pTempTarStr.length && nHexRange.length > 1)
                                            {
                                                [dic setValue:[pTempTarStr substringFromIndex:(nHexRange.location)] forKey:@"pTargetString"];
                                            }
                                            else
                                            {
                                                [dic setValue:pTempTarStr forKey:@"pTargetString"];
                                            }
                                            
                                        }
                                        
                                    }
                                }
                                
                            }
                        }
                        //UIWebBrower含多个Tap手势，要取到单击手势，只能通过actiong来筛选了
                        if ([dic[@"pActionString"] isEqualToString:@"_singleTapRecognized:"]) {
                            //找到数据，记录在数组中坐标，跳出循环
                            dic[@"index"] = @(index);
                            break;
                        }
                        //平移手势，同上，通过action找到对应手势
                        else if ([dic[@"pActionString"] isEqualToString:@"handlePan:"]){
                            dic[@"index"] = @(index);
                            break;
                        }
                    }
                }
            }
        }
    }
    return dic;
}

-(NSInteger)gainIndexForView:(UIView *)pView withActionString:(NSString *)actionString{
    NSArray* pGestures = [pView gestureRecognizers];
    int index;
    if (pGestures && pGestures.count >= 1)
    {
        for (index = 0; index < pGestures.count; index ++) {
            //获取手势描述
            NSString* pGestureString = [[pGestures objectAtIndex:index] description];
            
            //webbrowser多个手势含singleTap方法，通过判断must来获取准确手势
            if ([pGestureString containsString:@"must-fail-for"]&&[pGestureString containsString:actionString]) {
                
                NSRange rangeM = [pGestureString rangeOfString:@"must-fail-for"];
                NSRange rangeA = [pGestureString rangeOfString:actionString];
                if (rangeM.location > rangeA.location) {
                    return index;
                }
                
            }else if ([pGestureString containsString:actionString]){
                return index;
            }
        }
    }
    return -1;
}


//#pragma mark - SEL多参数和返回值的处理
//-(id)target:(id)target performSelector:(SEL)selector parameters:(NSArray *)parameters{
//
//    NSMethodSignature *signature = [target methodSignatureForSelector: selector];
//    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature: signature];
//
//    [invocation setSelector: selector];
//
//    [invocation setTarget: target];
//    NSUInteger i = 1;
//    for (id object in parameters) {
//        [invocation setArgument:(void *)&object atIndex:++i];
//    }
//    id result;
//    [invocation invoke];
//
////    [invocation getReturnValue: &result];
//
//    return result;
//}

@end
