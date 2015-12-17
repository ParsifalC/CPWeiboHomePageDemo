//
//  CPExpendHeaderView.m
//  CPWeiboHomePageDemo
//
//  Created by Parsifal on 15/12/10.
//  Copyright © 2015年 Parsifal. All rights reserved.
//

#import "CPExpendHeaderView.h"
#import <Masonry.h>

@interface CPImageCollectionViewCell ()
@property (strong, nonatomic, readwrite) UIImageView *imageView;
@end

@implementation CPImageCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [UIImageView new];
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}
@end


@interface CPExpendHeaderView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIPageControl *pageControl;
@end

static NSString * const kImageCellIdentifier = @"CPImageCollectionViewCell";
#define kItemSize CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds))
@implementation CPExpendHeaderView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - Util methods
- (void)initialize
{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = kItemSize;
    flowLayout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                         collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.pagingEnabled = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsMake(-64, 0, 0, 0));
    }];
    [_collectionView registerClass:NSClassFromString(kImageCellIdentifier)
        forCellWithReuseIdentifier:kImageCellIdentifier];
    
    _pageControl = [UIPageControl new];
    _pageControl.numberOfPages = 4;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    [self addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (void)transformUpdateWithOffset:(CGPoint)newOffset
{
    newOffset.y+=64;
    if (newOffset.y <= 0) {
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0, newOffset.y);
        CGFloat originWidth = CGRectGetHeight([UIScreen mainScreen].bounds);
        CGFloat scaleFactor = fabs(newOffset.y)*2/originWidth+1;
        CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        CGAffineTransform composeTransform = CGAffineTransformConcat(translate, scale);
        self.transform = composeTransform;
        self.collectionView.transform = composeTransform;
        self.pageControl.transform = composeTransform;
        self.collectionView.scrollEnabled = !newOffset.y;
    } else {
        self.collectionView.scrollEnabled = YES;
    }
}

#pragma mark - Delegate methods
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageCellIdentifier
                                                                           forIndexPath:indexPath];
    NSString *imageName = [NSString stringWithFormat:@"image%@.jpeg",@(indexPath.row)];
    cell.imageView.image = [UIImage imageNamed:imageName];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x/kItemSize.width;
}
@end
