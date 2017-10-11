//
//  TBWLMotionEvent.h
//  TBWLMotionEvent
//
//  Created by chen lh on 16/4/17.
//  Copyright (c) 2016年 com.mapbar.wedrive.ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MFWeGestureRecognizerState) {
    
    MFWeGestureRecognizerStatePossible,   // the recognizer has not yet recognized its gesture, but may be evaluating touch events. this is the default state
    
    MFWeGestureRecognizerStateBegan,      // the recognizer has received touches recognized as the gesture. the action method will be called at the next turn of the run loop
    
    MFWeGestureRecognizerStateChanged,    // the recognizer has received touches recognized as a change to the gesture. the action method will be called at the next turn of the run loop
    
    MFWeGestureRecognizerStateEnded,      // the recognizer has received touches recognized as the end of the gesture. the action method will be called at the next turn of the run loop and the recognizer will be reset to UIGestureRecognizerStatePossible
    
    MFWeGestureRecognizerStateCancelled,  // the recognizer has received touches resulting in the cancellation of the gesture. the action method will be called at the next turn of the run loop. the recognizer will be reset to UIGestureRecognizerStatePossible
    
    MFWeGestureRecognizerStateFailed,     // the recognizer has received a touch sequence that can not be recognized as the gesture. the action method will not be called and the recognizer will be reset to UIGestureRecognizerStatePossible
    
    // Discrete Gestures – gesture recognizers that recognize a discrete event but do not report changes (for example, a tap) do not transition through the Began and Changed states and can not fail or be cancelled
    
    MFWeGestureRecognizerStateRecognized = MFWeGestureRecognizerStateEnded // the recognizer has received touches recognized as the gesture. the action method will be called at the next turn of the run loop and the recognizer will be reset to UIGestureRecognizerStatePossible
    
};

@interface TBWLMotionEvent : NSObject

- (id)initWithRootView:(UIView*)rootView;

- (void)start;
- (void)stop;

- (void)setMotionClass:(Class)motionClass;
- (void)processTapEventWithX:(NSInteger)x andY:(NSInteger)y
                    andState:(MFWeGestureRecognizerState)state andNumberOfTouches:(NSInteger)numberOfTouches;

@end
