//
//  CPWeiboImageTableViewCell.m
//  CPWeiboHomePageDemo
//
//  Created by Parsifal on 15/12/17.
//  Copyright © 2015年 Parsifal. All rights reserved.
//

#import "CPWeiboImageTableViewCell.h"
#import "CPImageItemsView.h"
#import <Masonry.h>

@interface CPWeiboImageTableViewCell ()
@property (strong, nonatomic) CPImageItemsView *subview;
@end

@implementation CPWeiboImageTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
            self.subview = [self createImageItemsView];
            [self.contentView addSubview:self.subview];
            [self.subview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView);
            }];
    }
    return self;
}

- (CPImageItemsView *)createImageItemsView
{
    CPImageItemsView *view = [CPImageItemsView createImageItemsViewWithFrame:CGRectZero
                                                                   imageUrls:@[]];
    return view;
}

- (void)setUrls:(NSArray *)urls
{
    _urls = urls;
    _subview.urls = urls;
}

- (void)setDelegate:(id<kImageItemsProtocol>)delegate
{
    _delegate = delegate;
    _subview.delegate = delegate;
}

- (void)setLayoutStyle:(kImageLayoutSytle)layoutStyle
{
    _layoutStyle = layoutStyle;
    _subview.layoutStyle = layoutStyle;
}
@end

