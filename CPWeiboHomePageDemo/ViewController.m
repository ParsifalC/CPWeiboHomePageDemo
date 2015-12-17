//
//  ViewController.m
//  CPWeiboHomePageDemo
//
//  Created by Parsifal on 15/12/4.
//  Copyright © 2015年 Parsifal. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "UINavigationBar+Helper.h"
#import "CPExpendHeaderView.h"
#import "CPSegmentedView.h"
#import "CPWeiboImageTableViewCell.h"

#define SCREENSIZE [UIScreen mainScreen].bounds.size

typedef enum : NSUInteger {
    kCurrentDataSourceProfile,
    kCurrentDataSourceWeibo,
    kCurrentDataSourceAlbum,
} kCurrentDataSourceType;
static NSString * const kBaseTableViewCellIdentifier = @"UITableViewCell";
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, kSegmentedViewProtocol, kImageItemsProtocol>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) CPExpendHeaderView *headerView;
@property (assign, nonatomic) kCurrentDataSourceType type;
@end

@implementation ViewController

#pragma mark - Life Cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableViewUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self scrollViewDidScroll:self.tableView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar cp_reset];
}

#pragma mark - Initialize methods
- (void)setupTableViewUI
{
    typeof(self) __weak weakSelf = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - UIScrollView Delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    UIColor *color = [UIColor colorWithRed:250.0f/255.0f green:227.0f/255.0f blue:147.0f/255.0f alpha:1];
    CGFloat minOffsetY = 40.0f;
    if (offsetY > minOffsetY) {
        CGFloat alpha = MIN(1, (offsetY-minOffsetY)/100);
        [self.navigationController.navigationBar cp_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar cp_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
    
    [self.headerView transformUpdateWithOffset:CGPointMake(0, offsetY)];
}

#pragma mark - UITableView DataSource & Delegate methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellWithDataSourceType:self.type
                              tableView:tableView
                              indexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [self segmentedView];
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.type==kCurrentDataSourceAlbum?SCREENSIZE.width/3*2:44;
    } else {
        return self.type==kCurrentDataSourceAlbum?SCREENSIZE.width/3.0:44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section==0?40:0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - kSegmentedViewProtocol methods
- (void)switchWithIndex:(NSInteger)index
{
    self.type = (kCurrentDataSourceType)index;
    [self.tableView reloadData];
}

#pragma mark - kImageItemsProtocol methods
- (void)imageItemTapped:(NSURL *)url
{
    NSLog(@"%@", url);
}

#pragma mark - Getter & Setter methods
- (UITableViewCell *)cellWithDataSourceType:(kCurrentDataSourceType)type
                                      tableView:(UITableView *)tableView
                                  indexPath:(NSIndexPath *)indexPath
{
    switch (type) {
        case kCurrentDataSourceProfile:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBaseTableViewCellIdentifier
                                                                    forIndexPath:indexPath];
            cell.textLabel.text = [NSString stringWithFormat:@"我是资料:%@", @(indexPath.row)];
            return cell;
            break;
        }
        case kCurrentDataSourceAlbum:
        {
            CPWeiboImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommonImageItemIdentifier
                                                                    forIndexPath:indexPath];
            cell.urls = @[@"http://img.hb.aicdn.com/0d05e672dbd815118dc0d24d15ecd515db1b4a47884f-3KVv18_fw658",
                          @"http://img.hb.aicdn.com/38811f5e81578ce1cd5ea175f6a0913ec385ef6fc107-R4FKfK_fw658",
                          @"http://img.hb.aicdn.com/201f0d11018506ad999c0551eea77135b4ff83a05b55-wqiouE_fw658"];
            cell.delegate = self;
            cell.layoutStyle = indexPath.row==0?kImageLayoutBig:kImageLayoutDefault;
            return cell;
            break;
        }
        case kCurrentDataSourceWeibo:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBaseTableViewCellIdentifier
                                                                    forIndexPath:indexPath];
            cell.textLabel.text = [NSString stringWithFormat:@"我是微博:%@", @(indexPath.row)];
            return cell;
            break;
        }
        default:
            return nil;
            break;
    }
}

- (CPSegmentedView *)segmentedView
{
    CPSegmentedView *segmentedView = [CPSegmentedView createSegmentedViewWithTitles:@[@"资料", @"微博", @"相册"]
                                                                              frame:CGRectMake(0, 0, SCREENSIZE.width, 40)];
    segmentedView.delegate = self;
    return segmentedView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:kBaseTableViewCellIdentifier];
        [_tableView registerClass:[CPWeiboImageTableViewCell class]
           forCellReuseIdentifier:kCommonImageItemIdentifier];
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[CPExpendHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENSIZE.width, SCREENSIZE.width-64)];
    }
    return _headerView;
}
@end
