//
//  ViewController.m
//  RWLoopScrollView
//
//  Created by 许宗城 on 16/6/20.
//  Copyright © 2016年 许宗城. All rights reserved.
//

#import "ViewController.h"
#import "RWLoopScrollView.h"

@interface ViewController () <RWLoopScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) RWLoopScrollView *loopScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dataSource = [NSMutableArray array];
    for (int i = 0; i < 10; i ++) {
        UIColor *color = [UIColor colorWithRed:arc4random_uniform(11)/10.0 green:arc4random_uniform(11)/10.0 blue:arc4random_uniform(11)/10.0 alpha:1.000];
        [self.dataSource addObject:color];
    }
    
    RWLoopScrollView *loopScrollView = [[RWLoopScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 200)];
    loopScrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    loopScrollView.delegate = self;
    [self.view addSubview:loopScrollView];
    self.loopScrollView = loopScrollView;
    
    
    
}

- (NSUInteger)numberOfContentInLoopScrollView:(RWLoopScrollView *)loopScrollView {
    return self.dataSource.count;
}

- (UIView *)contentViewInLoopScrollView:(RWLoopScrollView *)loopScrollView {
    return [[UIView alloc] init];
}

- (void)loopScrollView:(RWLoopScrollView *)loopScrollView prepareDisplayContentView:(UIView *)view forIndex:(NSUInteger)index {
    view.backgroundColor = self.dataSource[index];
    
    
    
}


@end
