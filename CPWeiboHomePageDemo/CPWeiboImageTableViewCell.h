//
//  CPWeiboImageTableViewCell.h
//  CPWeiboHomePageDemo
//
//  Created by Parsifal on 15/12/17.
//  Copyright © 2015年 Parsifal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPImageItemsView.h"

static NSString * const kCommonImageItemIdentifier = @"kCommonImageItemIdentifier";
@interface CPWeiboImageTableViewCell : UITableViewCell
@property (strong, nonatomic) NSArray *urls;
@property (weak, nonatomic) id<kImageItemsProtocol> delegate;
@property (assign, nonatomic) kImageLayoutSytle layoutStyle;
@end
