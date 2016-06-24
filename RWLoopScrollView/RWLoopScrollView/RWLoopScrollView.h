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
- (NSInteger)numberOfContentInLoopScrollView:(RWLoopScrollView *)loopScrollView;
- (UIView *)contentViewInLoopScrollView:(RWLoopScrollView *)loopScrollView;
@optional
- (void)loopScrollView:(RWLoopScrollView *)loopScrollView prepareDisplayContentView:(UIView *)view forIndex:(NSInteger)index;
- (void)loopScrollView:(RWLoopScrollView *)loopScrollView didTapViewForIndex:(NSInteger)index;
- (void)loopScrollView:(RWLoopScrollView *)loopScrollView didScrollToViewAtIndex:(NSInteger)index;
@end


@interface RWLoopScrollView : UIView

@property (weak, nonatomic) id<RWLoopScrollViewDelegate> delegate;

- (void)reload;

@end



