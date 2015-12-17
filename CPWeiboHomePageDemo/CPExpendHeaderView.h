//
//  CPExpendHeaderView.h
//  CPWeiboHomePageDemo
//
//  Created by Parsifal on 15/12/10.
//  Copyright © 2015年 Parsifal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPImageCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic, readonly) UIImageView *imageView;
@end

@interface CPExpendHeaderView : UIView
- (void)transformUpdateWithOffset:(CGPoint)newOffset;
@end
