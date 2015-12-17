//
//  UINavigationBar+Helper.m
//  CPWeiboHomePageDemo
//
//  Created by Parsifal on 15/12/4.
//  Copyright © 2015年 Parsifal. All rights reserved.
//

#import "UINavigationBar+Helper.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Helper)
- (UIView *)overlayView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setOverlayView:(UIView *)overlayView
{
    objc_setAssociatedObject(self, @selector(overlayView), overlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cp_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlayView) {
        [self cp_setTransparent:YES];
        self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    -20,
                                                                    [UIScreen mainScreen].bounds.size.width,
                                                                    CGRectGetHeight(self.bounds)+20)];
        self.overlayView.userInteractionEnabled = NO;
        self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlayView atIndex:0];
    }
    self.overlayView.backgroundColor = backgroundColor;
}

- (void)cp_reset
{
    [self cp_setTransparent:NO];
    [self.overlayView removeFromSuperview];
    self.overlayView = nil;
}

- (void)cp_setTransparent:(BOOL)trans
{
    if (trans) {
        self.shadowImage = [UIImage new];
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    } else {
        self.shadowImage = nil;
        [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    }
}
@end
