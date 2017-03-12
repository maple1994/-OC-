//
//  OCWelcomeViewController.m
//  OCWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCWelcomeViewController.h"
#import "OCTabBarViewController.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface OCWelcomeViewController ()
///背景图片
@property (nonatomic, weak) UIImageView *bgImageView;
///头像
@property (nonatomic, weak) UIImageView *iconImageView;
///欢迎文本
@property (nonatomic, weak) UILabel *welcomeLabel;
@end

@implementation OCWelcomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setUpUI];
  //如果用户没有登录则直接返回
  if (![OCUserAccountViewModel sharedAccountViewModel].isLogin) {
    NSLog(@"用户没有登录");
    return;
  }
  //如果缓存有则从缓存中获取图片
  [self setIcon];
  //加载用户信息
  [[OCUserAccountViewModel sharedAccountViewModel] loadUserInfoCompletion:^(NSError *error) {
    if (error) {
      NSLog(@"%@", error);
      return;
    }
    [self setIcon];
  }];
}

/**
 * 设置头像
 */
- (void)setIcon {
  OCUserAccount *account = [OCUserAccountViewModel sharedAccountViewModel].account;
  //没有图片地址直接返回
  if (account.avatar_large == nil) {
    return;
  }
  NSURL *url = [NSURL URLWithString:account.avatar_large];
  [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self startAnimation];
}

/**
 * 添加控件，设置约束
 */
- (void)setUpUI {
  //背景
  [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view);
  }];
  //头像
  [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.view).offset(-160);
    make.centerX.equalTo(self.view);
    make.width.height.mas_equalTo(90);
  }];
  //欢迎label
  [self.welcomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.iconImageView.mas_bottom).offset(16);
    make.centerX.equalTo(self.view);
  }];
}

/**
 * 开始动画
 */
- (void)startAnimation {
  CGFloat offY = -([UIScreen mainScreen].bounds.size.height - 160);
  [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.view).offset(offY);
  }];
  
  //开始动画
  [UIView animateWithDuration:1 delay:0.1 usingSpringWithDamping:0.75 initialSpringVelocity:7 options:0 animations:^{
    //强制刷新
    [self.view layoutIfNeeded];
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:defalutDutation animations:^{
      self.welcomeLabel.alpha = 1;
    } completion:^(BOOL finished) {
      //跳转控制器
      [AppDelegate changeRootViewController:[[OCTabBarViewController alloc] init]];
    }];
  }];
}

#pragma mark 懒加载
- (UIImageView *)bgImageView {
  if (_bgImageView == nil) {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ad_background"]];
    _bgImageView = imageView;
    
    [self.view addSubview:imageView];
  }
  return _bgImageView;
}

- (UIImageView *)iconImageView {
  if (_iconImageView == nil) {
    UIImageView *imageView = [[UIImageView alloc] init];
    _iconImageView = imageView;
    imageView.layer.cornerRadius = 45;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
  }
  return _iconImageView;
}

- (UILabel *)welcomeLabel {
  if (_welcomeLabel == nil) {
    UILabel *label = [[UILabel alloc] init];
    _welcomeLabel = label;
    label.text = @"欢迎回来";
    label.alpha = 0;
    [label sizeToFit];
    [self.view addSubview:label];
  }
  return _welcomeLabel;
}



@end
