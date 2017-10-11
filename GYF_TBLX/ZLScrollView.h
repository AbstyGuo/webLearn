//
//  ZLScrollView.h
//  ZLScrollView
//
//  Created by zhulei on 15/11/25.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZLScrollViewDelegate <NSObject>
/*!
 调用代理方法 传递点击图片事件 可以自行更改
 */
-(void)clickImageTag:(NSInteger)tag;

@end

@interface ZLScrollView : UIView<UIScrollViewDelegate>
@property (nonatomic,weak)id<ZLScrollViewDelegate>delegate;
/*!
 传图片名字数组或者网络图片URL生成的数组,IsFromWeb代表是否加载网络图片 PlaceHolderImage 代表占位图,如果没有传nil
 */
-(void)addImageArrayWithArray:(NSArray *)imageArray IsFromWeb:(BOOL)isFromWeb PlaceHolderImage:(UIImage *)image;
@end
