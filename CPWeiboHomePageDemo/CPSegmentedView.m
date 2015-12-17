//
//  CPSegmentedView.m
//  CPWeiboHomePageDemo
//
//  Created by Parsifal on 15/12/14.
//  Copyright © 2015年 Parsifal. All rights reserved.
//

#import "CPSegmentedView.h"
#import <Masonry.h>

@interface CPSegmentedView ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSArray *imageViewConstraints;
@end

@implementation CPSegmentedView
#pragma mark - Initialize methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray *)titles
                         frame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if (self) {
        __block UIButton *lastBtn = nil;
        CGFloat btnWidth = 75;
        CGFloat postionX = MAX(10.0f, (CGRectGetWidth([UIScreen mainScreen].bounds)-titles.count*btnWidth)*0.5f);
        NSInteger index = 0;
        for (NSString *title in titles) {
            UIButton *button = [self buttonWithTitle:title
                                               index:index];
            [self.containerView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(btnWidth);
                make.top.and.bottom.mas_equalTo(self.containerView);
                if (lastBtn) {
                    make.left.mas_equalTo(lastBtn.mas_right);
                } else {
                    make.left.mas_equalTo(postionX);
                }
                lastBtn = button;
            }];
            index++;
        }
        
        if (lastBtn) {
            [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(lastBtn.mas_right);
            }];
        }
    }
    return self;
}

+ (instancetype)createSegmentedViewWithTitles:(NSArray *)titles
                                        frame:(CGRect)frame
{
    CPSegmentedView *segmentedView = [[CPSegmentedView alloc] initWithTitles:titles
                                                                       frame:frame];
    return segmentedView;
}

- (void)initialize
{
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - Action methods
- (void)buttonTapped:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(switchWithIndex:)]) {
        [self.delegate switchWithIndex:sender.tag];
    }
}

#pragma mark - Setter & Getter methods
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = [UIColor lightGrayColor];
        _containerView = [UIView new];
        [_scrollView addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_scrollView);
        }];
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.backgroundColor = [UIColor redColor];
    }
    return _imageView;
}

- (UIButton *)buttonWithTitle:(NSString *)title
                        index:(NSInteger)index
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.tag = index;
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor blackColor]
                 forState:UIControlStateNormal];
    [button setTitle:title
            forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(buttonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end
