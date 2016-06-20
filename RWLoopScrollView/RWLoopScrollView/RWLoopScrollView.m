//
//  RWLoopScrollView.m
//  Demo
//
//  Created by 许宗城 on 16/3/21.
//  Copyright © 2016年 许宗城. All rights reserved.
//

#import "RWLoopScrollView.h"
#import <objc/runtime.h>


static void *kRWLoopScrollViewContainerAssociateKey = &kRWLoopScrollViewContainerAssociateKey;

@interface RWLoopScrollView () <UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) UIView *leftContainer;
@property (weak, nonatomic) UIView *midContainer;
@property (weak, nonatomic) UIView *rightContainer;

@property (assign, nonatomic) NSUInteger numberOfContent;

@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) NSInteger previousIndex;
@property (assign, nonatomic) NSInteger nextIndex;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation RWLoopScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
    UIView *leftContainer = [[UIView alloc] init];
    self.leftContainer = leftContainer;
    [scrollView addSubview:leftContainer];
    
    UIView *midContainer = [[UIView alloc] init];
    self.midContainer = midContainer;
    [scrollView addSubview:midContainer];
    
    UIView *rightContainer = [[UIView alloc] init];
    self.rightContainer = rightContainer;
    [scrollView addSubview:rightContainer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self stopTimer];
    
    self.scrollView.frame = self.bounds;
    CGFloat scrW = self.frame.size.width;
    CGFloat scrH = self.frame.size.height;
    
    self.scrollView.contentSize = CGSizeMake(scrW * 3, scrH);
    self.scrollView.contentOffset = CGPointMake(scrW, 0);
    
    self.leftContainer.frame = CGRectMake(0, 0, scrW, scrH);
    self.midContainer.frame = CGRectMake(scrW, 0, scrW, scrH);
    self.rightContainer.frame = CGRectMake(scrW * 2, 0, scrW, scrH);
    
    UIView *leftContent = objc_getAssociatedObject(self.leftContainer, kRWLoopScrollViewContainerAssociateKey);
    UIView *midContent = objc_getAssociatedObject(self.midContainer, kRWLoopScrollViewContainerAssociateKey);
    UIView *rightContent = objc_getAssociatedObject(self.rightContainer, kRWLoopScrollViewContainerAssociateKey);
    

    
    if ([self.delegate respondsToSelector:@selector(contentViewInLoopScrollView:)]) {
        if (!leftContent) {
            leftContent = [self.delegate contentViewInLoopScrollView:self];
            [self.leftContainer addSubview:leftContent];
            objc_setAssociatedObject(self.leftContainer,
                                     kRWLoopScrollViewContainerAssociateKey,
                                     leftContent,
                                     OBJC_ASSOCIATION_RETAIN);
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(handleGesture:)];
            [self.leftContainer addGestureRecognizer:tap];
        }
        if (!midContent) {
            midContent = [self.delegate contentViewInLoopScrollView:self];
            [self.midContainer addSubview:midContent];
            objc_setAssociatedObject(self.midContainer,
                                     kRWLoopScrollViewContainerAssociateKey,
                                     midContent,
                                     OBJC_ASSOCIATION_RETAIN);
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(handleGesture:)];
            [self.midContainer addGestureRecognizer:tap];
        }
        if (!rightContent) {
            rightContent = [self.delegate contentViewInLoopScrollView:self];
            [self.rightContainer addSubview:rightContent];
            objc_setAssociatedObject(self.rightContainer,
                                     kRWLoopScrollViewContainerAssociateKey,
                                     rightContent,
                                     OBJC_ASSOCIATION_RETAIN);
            
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(handleGesture:)];
            
            [self.rightContainer addGestureRecognizer:tap];
        }
        leftContent.frame = self.leftContainer.bounds;
        midContent.frame = self.midContainer.bounds;
        rightContent.frame = self.rightContainer.bounds;
    }
    
    if ([self.delegate respondsToSelector:@selector(numberOfContentInLoopScrollView:)]) {
        NSUInteger n = [self.delegate numberOfContentInLoopScrollView:self];
        self.scrollView.scrollEnabled = n > 1;
        self.numberOfContent = n;
    }
    
    if ([self.delegate respondsToSelector:@selector(loopScrollView:prepareDisplayContentView:forIndex:)]) {
        if (self.numberOfContent > 0) {
            [self.delegate loopScrollView:self prepareDisplayContentView:midContent forIndex:0];
            if (self.numberOfContent == 1) {
            } else if (self.numberOfContent == 2) {
                [self.delegate loopScrollView:self
                    prepareDisplayContentView:rightContent
                                     forIndex:1];
                [self.delegate loopScrollView:self
                    prepareDisplayContentView:leftContent
                                     forIndex:1];
                [self startTimer];
            } else {
                [self.delegate loopScrollView:self
                    prepareDisplayContentView:rightContent
                                     forIndex:1];
                [self.delegate loopScrollView:self
                    prepareDisplayContentView:leftContent
                                     forIndex:self.numberOfContent - 1];
                [self startTimer];
            }
        } else {
            
        }
    }
    self.currentIndex = 0;
    self.nextIndex = 1;
    self.previousIndex = self.numberOfContent - 1;
}

#pragma mark - Event
- (void)reload {
    [self setNeedsLayout];
}

- (void)handleGesture:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(loopScrollView:didTapViewForIndex:)]) {
            [self.delegate loopScrollView:self didTapViewForIndex:self.currentIndex];
        }
    }
}

#pragma mark - Timer
- (void)startTimer {
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
}

- (void)stopTimer {
    self.timer.fireDate = [NSDate distantFuture];
}

- (NSTimer *)timer {
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:4
                                                 target:self
                                               selector:@selector(timerRun)
                                               userInfo:nil
                                                repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer
                                  forMode:NSRunLoopCommonModes];
        timer.fireDate = [NSDate distantFuture];
        self.timer = timer;
    }
    return _timer;
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self.timer invalidate];
}

#pragma mark - Index
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    
    if (self.numberOfContent > 0) {
        if (_currentIndex >= self.numberOfContent) {
            _currentIndex = 0;
        } else if (_currentIndex < 0) {
            _currentIndex = self.numberOfContent - 1;
        }
    } else {
        _currentIndex = 0;
    }
    
    if ([self.delegate respondsToSelector:@selector(loopScrollView:didScrollToViewAtIndex:)]) {
        [self.delegate loopScrollView:self didScrollToViewAtIndex:_currentIndex];
    }
}

- (void)setPreviousIndex:(NSInteger)previousIndex {
    _previousIndex = previousIndex;
    
    if (self.numberOfContent > 0) {
        if (_previousIndex >= self.numberOfContent) {
            _previousIndex = 0;
        } else if (_currentIndex < 0) {
            _previousIndex = self.numberOfContent - 1;
        }
    } else {
        _previousIndex = 0;
    }
}

- (void)setNextIndex:(NSInteger)nextIndex {
    _nextIndex = nextIndex;
    
    if (self.numberOfContent > 0) {
        if (_nextIndex >= self.numberOfContent) {
            _nextIndex = 0;
        } else if (_nextIndex < 0) {
            _nextIndex = self.numberOfContent - 1;
        }
    } else {
        _nextIndex = 0;
    }
}

#pragma mark - Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (offsetX == 0) {
        [self manageOffsetLeft];
    } else if (offsetX == scrollView.frame.size.width * 2) {
        [self manageOffsetRight];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)manageOffsetLeft {
    CGFloat scrW = self.scrollView.frame.size.width;
    CGFloat scrH = self.scrollView.frame.size.height;
    
    self.scrollView.contentOffset = CGPointMake(scrW, 0);
    
    self.rightContainer.frame = CGRectMake(0, 0, scrW, scrH);
    self.leftContainer.frame = CGRectMake(scrW, 0, scrW, scrH);
    self.midContainer.frame = CGRectMake(scrW * 2, 0, scrW, scrH);
    
    UIView *oriLeft = self.leftContainer;
    UIView *oriMid = self.midContainer;
    self.leftContainer = self.rightContainer;
    self.midContainer = oriLeft;
    self.rightContainer = oriMid;
    
    self.currentIndex --;
    self.nextIndex --;
    self.previousIndex --;
    if ([self.delegate respondsToSelector:@selector(loopScrollView:prepareDisplayContentView:forIndex:)]) {
        UIView *leftContent = objc_getAssociatedObject(self.leftContainer, kRWLoopScrollViewContainerAssociateKey);
        [self.delegate loopScrollView:self
            prepareDisplayContentView:leftContent
                             forIndex:self.previousIndex];
    }
}

- (void)manageOffsetRight {
    CGFloat scrW = self.scrollView.frame.size.width;
    CGFloat scrH = self.scrollView.frame.size.height;
    
    self.scrollView.contentOffset = CGPointMake(scrW, 0);
    
    self.leftContainer.frame = CGRectMake(scrW * 2, 0, scrW, scrH);
    self.midContainer.frame = CGRectMake(0, 0, scrW, scrH);
    self.rightContainer.frame = CGRectMake(scrW, 0, scrW, scrH);
    
    UIView *oriRight = self.rightContainer;
    UIView *oriMid = self.midContainer;
    self.rightContainer = self.leftContainer;
    self.midContainer = oriRight;
    self.leftContainer = oriMid;
    
    self.currentIndex ++;
    self.nextIndex ++;
    self.previousIndex ++;
    if ([self.delegate respondsToSelector:@selector(loopScrollView:prepareDisplayContentView:forIndex:)]) {
        UIView *rightContent = objc_getAssociatedObject(self.rightContainer, kRWLoopScrollViewContainerAssociateKey);
        [self.delegate loopScrollView:self
            prepareDisplayContentView:rightContent
                             forIndex:self.nextIndex];
    }
}

- (void)timerRun {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 2, 0) animated:YES];
}

@end


