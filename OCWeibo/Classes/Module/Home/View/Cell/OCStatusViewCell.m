//
//  OCStatusViewCell.m
//  OCWeibo
//
//  Created by Maple on 16/7/23.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCStatusViewCell.h"
#import "OCOriginalView.h"
#import "OCBottomView.h"
#import "OCRetweetView.h"
#import <Masonry.h>
@interface OCStatusViewCell()
///原创视图
@property (nonatomic, weak) OCOriginalView *originalView;
///底部按钮区域
@property (nonatomic, weak) OCBottomView *bottomView;
///转发微博区域
@property (nonatomic, weak) OCRetweetView *retweetView;
///记录底部View的顶部约束
@property (nonatomic, strong) MASConstraint *bottomTopConstraint;
@end

@implementation OCStatusViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    [self setupUI];
    //设置背景颜色
    self.contentView.backgroundColor = [UIColor colorWithWhite:237 / 255.0 alpha:1];
  }
  return self;
}

/**
 * 添加控件，设置约束
 */
- (void)setupUI {

  [self.originalView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self.contentView);
    make.top.equalTo(self.contentView).offset(OCCellMargin);
  }];
  
  [self.retweetView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.originalView.mas_bottom);
    make.leading.trailing.equalTo(self.contentView);
  }];
  
  [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self.contentView);
    self.bottomTopConstraint = make.top.equalTo(self.retweetView.mas_bottom);
    make.height.mas_equalTo(OCStatusBottomHeight);
  }];
  
  //设置cell和contentView的约束
  [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.leading.trailing.equalTo(self);
    make.bottom.equalTo(self.bottomView);
  }];
}

- (void)setStatus:(OCStatus *)status {
  _status = status;
  self.originalView.status = status;
  //删除之前的顶部约束
  [self.bottomTopConstraint uninstall];
  //判断是否有转发视图，隐藏或显示
  if (status.retweeted_status == nil) {
    self.retweetView.hidden = true;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
      self.bottomTopConstraint = make.top.equalTo(self.originalView.mas_bottom);
    }];
    return;
  }else {
    self.retweetView.hidden = false;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
      self.bottomTopConstraint = make.top.equalTo(self.retweetView.mas_bottom);
    }];
  }
  self.retweetView.status = status.retweeted_status;
}

#pragma mark 懒加载
- (OCOriginalView *)originalView {
  if (_originalView == nil) {
    OCOriginalView *originalView = [[OCOriginalView alloc] init];
    _originalView = originalView;
    [self.contentView addSubview:originalView];
  }
  return _originalView;
}

- (OCBottomView *)bottomView {
  if (_bottomView == nil) {
    OCBottomView *bottomView = [[OCBottomView alloc] init];
    _bottomView = bottomView;
    [self.contentView addSubview:bottomView];
  }
  return _bottomView;
}

- (OCRetweetView *)retweetView {
  if (_retweetView == nil) {
    OCRetweetView *retweetView = [[OCRetweetView alloc] init];
    _retweetView = retweetView;
    [self.contentView addSubview:retweetView];
  }
  return _retweetView;
}

@end
