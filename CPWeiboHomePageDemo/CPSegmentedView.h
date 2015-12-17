//
//  CPSegmentedView.h
//  CPWeiboHomePageDemo
//
//  Created by Parsifal on 15/12/14.
//  Copyright © 2015年 Parsifal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol kSegmentedViewProtocol <NSObject>
@optional
- (void)switchWithIndex:(NSInteger)index;
@end

@interface CPSegmentedView : UIView
- (instancetype)initWithTitles:(NSArray *)titles
                         frame:(CGRect)frame;
+ (instancetype)createSegmentedViewWithTitles:(NSArray *)titles
                                        frame:(CGRect)frame;

@property (weak, nonatomic) id<kSegmentedViewProtocol> delegate;
@end
