//
//  OCVistorView.m
//  OCWeibo
//
//  Created by Maple on 16/7/18.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCVistorView.h"



@interface OCVistorView ()

///屋子视图
@property (nonatomic, weak) UIImageView *houseView;
///遮罩
@property (nonatomic, weak) UIImageView *coverView;
///轮子视图
@property (nonatomic, weak) UIImageView *iconView;
///文本视图
@property (nonatomic, weak) UILabel *textLabel;
///注册按钮
@property (nonatomic, weak) UIButton *registerButton;
///登录按钮
@property (nonatomic, weak) UIButton *loginButton;

@end
@implementation OCVistorView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setUpUI];
    self.backgroundColor = [UIColor colorWithWhite:236 / 255.0 alpha:1];
  }
  return self;
}

- (void)setUpContent:(NSString *)imageName title:(NSString *)title {
  self.iconView.image = [UIImage imageNamed:imageName];
  self.textLabel.text = title;
  [self sendSubviewToBack:self.coverView];
  self.houseView.hidden = YES;
}

/**
 * 开始轮子动画
 */
- (void)startAnimation {
  CABasicAnimation *ba = [CABasicAnimation animation];
  ba.keyPath = @"transform.rotation";
  ba.fromValue = @0;
  ba.toValue = @(M_PI * 2);
  ba.repeatCount = MAXFLOAT;
  ba.duration = 20;
  ba.removedOnCompletion = NO;
  [self.iconView.layer addAnimation:ba forKey:nil];
}

/**
 * 添加控件，设置约束
 */
- (void)setUpUI {
  //取消autoresizing
  self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
  self.coverView.translatesAutoresizingMaskIntoConstraints = NO;
  self.houseView.translatesAutoresizingMaskIntoConstraints = NO;
  self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.registerButton.translatesAutoresizingMaskIntoConstraints = NO;
  self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;
  
  
  //设置iconView约束
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
  
   [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-40]];
  //设置coverView约束
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.coverView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.coverView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
  
  //设置houseView约束
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.houseView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.houseView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
  //设置textLabel约束
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.iconView attribute:NSLayoutAttributeBottom multiplier:1 constant:16]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:260]];
  //设置registerButton约束
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.registerButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];

  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.registerButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:16]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.registerButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.registerButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:35]];
  //设置loginButton约束
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:16]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:35]];
}

#pragma mark 点击事件
- (void)loginClick{
  if ([self.delegate respondsToSelector:@selector(vistorViewDidLogin)]) {
    [self.delegate vistorViewDidLogin];
  }
}

- (void)registerClick{
  if ([self.delegate respondsToSelector:@selector(vistorViewDidRegister)]) {
    [self.delegate vistorViewDidRegister];
  }
}

#pragma mark 懒加载
- (UIImageView *)houseView {
  if (_houseView == nil) {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visitordiscover_feed_image_house"]];
    _houseView = imageView;
    [self addSubview:imageView];
  }
  return _houseView;
}

- (UIImageView *)coverView {
  if (_coverView == nil) {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visitordiscover_feed_mask_smallicon"]];
    _coverView = imageView;
    [self addSubview:_coverView];
  }
  return _coverView;
}

- (UIImageView *)iconView {
  if (_iconView == nil) {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visitordiscover_feed_image_smallicon"]];
    _iconView = imageView;
    [self addSubview:imageView];
  }
  return _iconView;
}

- (UILabel *)textLabel {
  if (_textLabel == nil) {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"关注一些人，回这里看看有什么惊喜关注一些人";
    label.numberOfLines = 0;
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    _textLabel = label;
    [self addSubview:label];
  }
  return _textLabel;
}

- (UIButton *)registerButton {
  if (_registerButton == nil) {
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"common_button_white_disable"] forState:UIControlStateNormal];
    [button setTitle:@"注册" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    _registerButton = button;
    [self addSubview:button];
    //添加点击事件
    [button addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
  }
  return _registerButton;
}

- (UIButton *)loginButton {
  if (_loginButton == nil) {
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"common_button_white_disable"] forState:UIControlStateNormal];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    _loginButton = button;
    [self addSubview:button];
    //添加点击事件
    [button addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
  }
  return _loginButton;
}
@end
















