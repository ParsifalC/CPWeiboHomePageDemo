//
//  CPImageItemsView.m
//  CPWeiboHomePageDemo
//
//  Created by Parsifal on 15/12/17.
//  Copyright © 2015年 Parsifal. All rights reserved.
//

#import "CPImageItemsView.h"
#import <Masonry.h>
#import <UIButton+WebCache.h>

@interface CPImageItemsView ()
@property (strong, nonatomic) NSMutableArray *buttonItems;
@end

@implementation CPImageItemsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        UIButton *lastBtn = nil;
        for (int i = 0; i < 3; i++) {
            UIButton *button = [self createButton];
            button.tag = i;
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.mas_equalTo(self);
                make.width.mas_equalTo(button.mas_height);;
                if (lastBtn) {
                    make.left.mas_equalTo(lastBtn.mas_right);
                } else {
                    make.left.mas_equalTo(self);
                }
            }];
            [self.buttonItems addObject:button];
            lastBtn = button;
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                    imageUrls:(NSArray *)urls
{
    self = [self initWithFrame:frame];
    if (self) {
        NSAssert(urls.count<=3, @"传入图片URL过多，最多只支持显示3张图片");
        self.urls = urls;
    }
    return self;
}

+ (instancetype)createImageItemsViewWithFrame:(CGRect)frame
                                    imageUrls:(NSArray *)urls
{
    CPImageItemsView *imageItemsView = [[CPImageItemsView alloc] initWithFrame:frame
                                                                     imageUrls:urls];
    return imageItemsView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.buttonItems enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        [button sd_setImageWithURL:self.urls[idx]
                          forState:UIControlStateNormal];
    }];
}

- (void)setLayoutStyle:(kImageLayoutSytle)layoutStyle
{
    if (layoutStyle == _layoutStyle) return;
    _layoutStyle = layoutStyle;
    if (self.layoutStyle == kImageLayoutDefault) {
        [self layoutButtonsWithDefaultStyle];
    } else {
        [self layoutButtonsWithBigStyle];
    }
}

- (void)layoutButtonsWithDefaultStyle
{
    UIButton *lastBtn = nil;
    for (UIButton *button in self.buttonItems) {
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.mas_equalTo(self);
            make.width.mas_equalTo(button.mas_height);
            if (lastBtn) {
                make.left.mas_equalTo(lastBtn.mas_right);
            } else {
                make.left.mas_equalTo(self);
            }
        }];
        lastBtn = button;
    }
}

- (void)layoutButtonsWithBigStyle
{
    UIButton *firstBtn = self.buttonItems.firstObject;
    UIButton *sencondBtn = self.buttonItems[1];
    UIButton *thirdBtn = self.buttonItems.lastObject;
    
    [firstBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.bottom.mas_equalTo(self);
        make.right.mas_equalTo(sencondBtn.mas_left);
    }];

    [sencondBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.mas_equalTo(self);
        make.width.mas_equalTo(sencondBtn.mas_height);
        make.height.mas_equalTo(thirdBtn.mas_height);
    }];
    
    [thirdBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.mas_equalTo(self);
        make.top.mas_equalTo(sencondBtn.mas_bottom);
        make.width.mas_equalTo(sencondBtn.mas_width);
    }];
}

- (UIButton *)createButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@""
            forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.contentMode = UIViewContentModeScaleToFill;
    [button addTarget:self
               action:@selector(buttonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonTapped:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(imageItemTapped:)]) {
        [self.delegate imageItemTapped:self.urls[sender.tag]];
    }
}

- (NSMutableArray *)buttonItems
{
    if (!_buttonItems) {
        _buttonItems = @[].mutableCopy;
    }
    return _buttonItems;
}
@end
