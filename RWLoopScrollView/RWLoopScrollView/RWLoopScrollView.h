//
//  RWLoopScrollView.h
//  Demo
//
//  Created by 许宗城 on 16/3/21.
//  Copyright © 2016年 许宗城. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RWLoopScrollView;
@protocol RWLoopScrollViewDelegate <NSObject>
@required
- (NSUInteger)numberOfContentInLoopScrollView:(RWLoopScrollView *)loopScrollView;
- (UIView *)contentViewInLoopScrollView:(RWLoopScrollView *)loopScrollView;
@optional
- (void)loopScrollView:(RWLoopScrollView *)loopScrollView prepareDisplayContentView:(UIView *)view forIndex:(NSUInteger)index;
- (void)loopScrollView:(RWLoopScrollView *)loopScrollView didTapViewForIndex:(NSUInteger)index;
- (void)loopScrollView:(RWLoopScrollView *)loopScrollView didScrollToViewAtIndex:(NSUInteger)index;
@end


@interface RWLoopScrollView : UIView

@property (weak, nonatomic) id<RWLoopScrollViewDelegate> delegate;

- (void)reload;

@end



