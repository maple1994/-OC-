//
//  OCHomeTableViewController.m
//  OCWeibo
//
//  Created by Maple on 16/7/18.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCHomeTableViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "OCHomeTitleButton.h"
#import "OCStatusViewCell.h"
#import "OCPullDownRefreshView.h"
#import <SVPullToRefresh.h>
@interface OCHomeTableViewController ()

///微博模型数组
@property (nonatomic, strong) NSMutableArray *statusArray;
///下拉刷新控件
@property (nonatomic, weak) OCPullDownRefreshView *pullDownRefreshView;
///提示label
@property (nonatomic, weak) UILabel *tipLabel;
@end

@implementation OCHomeTableViewController

- (OCPullDownRefreshView *)pullDownRefreshView {
  if (_pullDownRefreshView == nil) {
    OCPullDownRefreshView *pullDownRefreshView = [[OCPullDownRefreshView alloc] init];
    [self.tableView addSubview:pullDownRefreshView];
    _pullDownRefreshView = pullDownRefreshView;
  }
  return _pullDownRefreshView;
}

static NSString *reusedID = @"reusedID";
- (void)viewDidLoad {
    [super viewDidLoad];

  //如果没登录，则不执行
  if (![OCUserAccountViewModel sharedAccountViewModel].isLogin) {
    return;
  }
  [self setupNav];
  [self setupTitle];
  [self setupTableView];
  self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
  
  //添加上拉刷新控件
  __weak typeof(self) weakSelf = self;
  [self.tableView addInfiniteScrollingWithActionHandler:^{
    [weakSelf loadMoreDate];
  }];
  
  //设置刷新回调
  self.pullDownRefreshView.refreshBlock = ^ {
    [weakSelf loadNewData];
  };
  //开始刷新
  [self.pullDownRefreshView beginRefresh];
}

///显示提示label
- (void)showTipLabelCount: (NSInteger)count {
  //防止多次刷新
  if (self.tipLabel.layer.animationKeys) {
    return;
  }
  if (count) {
    self.tipLabel.text = [NSString stringWithFormat:@"刷新了%zd条数据", count];
  }else {
    self.tipLabel.text = @"没有数据可刷新";
  }
  [UIView animateWithDuration:1 animations:^{
    self.tipLabel.transform = CGAffineTransformMakeTranslation(0, 44 + 64);
  }completion:^(BOOL finished) {
    //一秒后隐藏
    [UIView animateWithDuration:1 delay:0.5 options:0 animations:^{
      self.tipLabel.transform = CGAffineTransformIdentity;
    } completion:nil];
  }];
  
}

///上拉刷新
- (void)loadMoreDate {
  NSUInteger max_id = 0;
  if (self.statusArray) {
    OCStatus *status = (OCStatus *)self.statusArray.lastObject;
    max_id = status.ID;
  }
  
  [[OCStatusViewModel sharedStatusViewModel] loadStatusMaxId:max_id SinceId:0 Completion:^(NSError *error, NSArray *statusArray) {
    [self.tableView.infiniteScrollingView stopAnimating];
    if (error) {
      NSLog(@"%@", error);
      return;
    }
    if (!self.statusArray) {
      self.statusArray = [NSMutableArray arrayWithArray:statusArray];
    }else {
      [self.statusArray addObjectsFromArray:statusArray];
    }
    [self.tableView reloadData];
    
  }];

}

///下拉刷新
- (void)loadNewData {
  NSUInteger since_id = 0;
  if (self.statusArray) {
    OCStatus *status = (OCStatus *)self.statusArray.firstObject;
    since_id = status.ID;
  }
  [[OCStatusViewModel sharedStatusViewModel] loadStatusMaxId:0 SinceId:since_id Completion:^(NSError *error, NSArray *statusArray) {
    [self.pullDownRefreshView endRefresh];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      [UIView animateWithDuration:0.25 animations:^{
        //隐藏
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top = 0;
        self.tableView.contentInset = inset;
      }];
    });
    if (error) {
      NSLog(@"%@", error);
      return;
    }
    if (!self.statusArray) {
      self.statusArray = [NSMutableArray arrayWithArray:statusArray];
    }else {
      [self showTipLabelCount:statusArray.count];
      NSArray *tempArray = self.statusArray;
      self.statusArray = [NSMutableArray arrayWithArray:statusArray];
      [self.statusArray addObjectsFromArray:tempArray];
    }
    [self.tableView reloadData];
    
  }];
}

/**
 * 设置tableview属性
 */
- (void)setupTableView {
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//  self.tableView.estimatedRowHeight = 200;
  self.tableView.allowsSelection = NO;
  //注册cell
  [self.tableView registerClass:[OCStatusViewCell class] forCellReuseIdentifier:reusedID];
}

- (void)setupNav {
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"navigationbar_friendsearch"];
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"navigationbar_pop"];
}

- (void)setupTitle {
  NSString *title = [OCUserAccountViewModel sharedAccountViewModel].account.screen_name;
  OCHomeTitleButton *button = [[OCHomeTitleButton alloc] init];
  [button setTitle:title forState:UIControlStateNormal];
  [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.titleView = button;
}

- (void)titleClick:(UIButton *)button {
  button.selected = !button.isSelected;
  CGAffineTransform transform = CGAffineTransformIdentity;
  if (button.selected) {
    transform = CGAffineTransformMakeRotation(M_PI - 0.0001);
  }else {
    transform = CGAffineTransformIdentity;
  }
  
  [UIView animateWithDuration:defalutDutation animations:^{
    button.imageView.transform = transform;
  }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statusArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OCStatusViewCell *cell = (OCStatusViewCell *)[tableView dequeueReusableCellWithIdentifier:reusedID];
    OCStatus *status = self.statusArray[indexPath.row];
  cell.status = status;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  OCStatus *status = self.statusArray[indexPath.row];

  if (!status) {
    return 0;
  }
  return status.rowHeight;
}


- (UILabel *)tipLabel {
  if (_tipLabel == nil) {
    UILabel *label = [[UILabel alloc] init];
    _tipLabel = label;
    label.backgroundColor = [UIColor orangeColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"刷新了X条数据";
    label.frame = CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, 44);
    [self.navigationController.navigationBar insertSubview:label atIndex:0];
  }
  return _tipLabel;
}

@end
