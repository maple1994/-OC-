//
//  OCNewFeatureCell.m
//  OCWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCNewFeatureCell.h"
#import <Masonry.h>
#import "OCTabBarViewController.h"
@interface OCNewFeatureCell()

///背景imageView
@property (nonatomic, weak) UIImageView *bgImageView;
///分享按钮
@property (nonatomic, weak) UIButton *sharedButton;
///开始按钮
@property (nonatomic, weak) UIButton *startButton;

@end
@implementation OCNewFeatureCell

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setupUI];
  }
  return self;
}

- (void)showButton:(BOOL)isShow {
  self.sharedButton.hidden = !isShow;
  self.startButton.hidden = !isShow;
}

/**
 * 添加控件，设置约束
 */
- (void)setupUI {
  //背景图片
  [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.contentView);
  }];
  
  //分享按钮
  [self.sharedButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.contentView).offset(-160);
    make.centerX.equalTo(self.contentView);
  }];
  
  //开始按钮
  [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.sharedButton.mas_bottom).offset(16);
    make.centerX.equalTo(self.contentView);
  }];
}

#pragma mark 点击事件
- (void)start {
  [AppDelegate changeRootViewController:[[OCTabBarViewController alloc] init]];
}

- (void)share {
  self.sharedButton.selected = !self.sharedButton.isSelected;
}

#pragma mark 重写get和set方法
- (void)setImage:(UIImage *)image {
  _image = image;
  self.bgImageView.image = image;
}

#pragma mark 懒加载
- (UIImageView *)bgImageView {
  if (_bgImageView == nil) {
    UIImageView *imageView = [[UIImageView alloc] init];
    _bgImageView = imageView;
    [self.contentView addSubview:imageView];
  }
  return _bgImageView;
}

- (UIButton *)sharedButton {
  if (_sharedButton == nil) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置属性
    [button setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [button setTitle:@" 分享给朋友" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button sizeToFit];
    button.hidden = YES;
    //添加点击事件
    [button addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    _sharedButton = button;
    [self.contentView addSubview:button];
  }
  return _sharedButton;
}

- (UIButton *)startButton {
  if (_startButton== nil) {
    //设置属性
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    [button setTitle:@"开始体验" forState:UIControlStateNormal];
    [button sizeToFit];
    button.hidden = YES;
    //添加点击事件
    [button addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    _startButton = button;
    [self.contentView addSubview:button];
  }
  return _startButton;
}


@end
