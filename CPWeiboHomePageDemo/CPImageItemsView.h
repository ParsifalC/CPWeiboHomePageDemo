//
//  CPImageItemsView.h
//  CPWeiboHomePageDemo
//
//  Created by Parsifal on 15/12/17.
//  Copyright © 2015年 Parsifal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol kImageItemsProtocol <NSObject>
- (void)imageItemTapped:(NSURL *)url;
@end

typedef enum : NSUInteger {
    kImageLayoutDefault,
    kImageLayoutBig,
} kImageLayoutSytle;

@interface CPImageItemsView : UIView
- (instancetype)initWithFrame:(CGRect)frame
                    imageUrls:(NSArray *)urls;
+ (instancetype)createImageItemsViewWithFrame:(CGRect)frame
                                    imageUrls:(NSArray *)urls;
@property (strong, nonatomic) NSArray *urls;
@property (weak, nonatomic) id<kImageItemsProtocol> delegate;
@property (assign, nonatomic) kImageLayoutSytle layoutStyle;
@end
