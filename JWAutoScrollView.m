//
//  JWAutoScrollView.m
//  07-图片轮播器
//
//  Created by Franky on 2017/2/14.
//  Copyright © 2017年 cngold. All rights reserved.
//

#import "JWAutoScrollView.h"

#import <Masonry.h>

@interface JWAutoScrollView ()<UIScrollViewDelegate>
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@end


@implementation JWAutoScrollView

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images{
    if (self = [super initWithFrame:frame]) {
        
        if (!images) return self;
        
        // 创建子控件
        /******************************************************/
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        self.scrollView = scrollView;
        [self addSubview:scrollView];

        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        self.pageControl = pageControl;
        pageControl.numberOfPages = images.count;
        pageControl.pageIndicatorTintColor = [UIColor redColor];
        [self addSubview:pageControl];
        
        /******************************************************/
        // 布局
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self);
        }];
        
        [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(self.bounds.size.width * 0.2);
            make.height.mas_equalTo(self.bounds.size.height * 0.2);
        }];
        
        [self layoutIfNeeded];
        
        // 添加轮播图
        CGFloat contentWidth = CGFLOAT_MIN;
        for (int i = 0; i < images.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:images[i]];
            imageView.frame = CGRectMake(contentWidth, 0, scrollView.bounds.size.width, scrollView.bounds.size.height);
            contentWidth += scrollView.bounds.size.width;
            [scrollView addSubview:imageView];
        }
        scrollView.contentSize = CGSizeMake(contentWidth, 130);
        
        scrollView.pagingEnabled = YES;
        
        scrollView.showsHorizontalScrollIndicator = NO;
        
        scrollView.bounces = NO;
        
        scrollView.delegate = self;
        
        // 使用定时器实现自动轮播
        _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
    }
    return self;
}
- (void)autoScroll{
    
    
    CGPoint point = self.scrollView.contentOffset;
    NSLog(@"%@",NSStringFromCGPoint(point));
    point.x += self.scrollView.bounds.size.width;
    NSLog(@"%@",NSStringFromCGPoint(point));
    
    NSInteger pageIndex = point.x / self.scrollView.bounds.size.width;
    
    if (pageIndex == self.scrollView.subviews.count - 1) {
        [self.scrollView setContentOffset:CGPointZero animated:YES];
        return;
    }
    
    [self.scrollView setContentOffset:point animated:YES];
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat page = (scrollView.contentOffset.x + 0.5 * scrollView.bounds.size.width)/ scrollView.bounds.size.width;
    
    self.pageControl.currentPage = page;
}
// 开始拖拽的时候停止
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
}
// 结束拖拽的时候重新开始定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

@end
