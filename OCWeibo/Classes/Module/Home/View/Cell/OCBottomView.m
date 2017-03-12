//
//  OCBottomView.m
//  OCWeibo
//
//  Created by Maple on 16/7/24.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCBottomView.h"
#import "UIButton+Extension.h"
#import <Masonry.h>

@interface OCBottomView ()
///转发按钮
@property (nonatomic, weak) UIButton *retweetButton;
///点赞按钮
@property (nonatomic, weak) UIButton *likeButton;
///评论按钮
@property (nonatomic, weak) UIButton *commentButton;
///分割线1
@property (nonatomic, weak) UIImageView *seperatorLineFirst;
///分割线2
@property (nonatomic, weak) UIImageView *seperatorLineSecond;

@end

@implementation OCBottomView

- (instancetype)init {
  if (self = [super init]) {
    [self setupUI];
  }
  
  return self;
}

- (void)setupUI {
  [self.retweetButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.leading.bottom.equalTo(self);
  }];
  
  [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.bottom.equalTo(self);
    make.leading.equalTo(self.retweetButton.mas_trailing);
    make.width.equalTo(self.retweetButton);
  }];
  
  [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.bottom.trailing.equalTo(self);
    make.leading.equalTo(self.commentButton.mas_trailing);
    make.width.equalTo(self.commentButton);
  }];
  
  [self.seperatorLineFirst mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.retweetButton.mas_trailing);
    make.centerY.equalTo(self.retweetButton);
  }];
  
  [self.seperatorLineSecond mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.commentButton.mas_trailing);
    make.centerY.equalTo(self.commentButton);
  }];
}

#pragma mark 懒加载
- (UIButton *)retweetButton {
  if (_retweetButton == nil) {
    UIButton *button = [UIButton buttonWithTitle:@"转发" image:@"timeline_icon_retweet"];
    _retweetButton = button;
    [self addSubview:button];
  }
  return _retweetButton;
}

- (UIButton *)commentButton {
  if (_commentButton == nil) {
    UIButton *button = [UIButton buttonWithTitle:@"评论" image:@"timeline_icon_comment"];
    _commentButton = button;
    [self addSubview:button];
  }
  return _commentButton;
}

- (UIButton *)likeButton {
  if (_likeButton == nil) {
    UIButton *button = [UIButton buttonWithTitle:@"赞" image:@"timeline_icon_unlike"];
    _likeButton = button;
    [self addSubview:button];
  }
  return _likeButton;
}

- (UIImageView *)seperatorLineFirst {
  if (_seperatorLineFirst == nil) {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line"]];
    _seperatorLineFirst = imageView;
    [self addSubview:_seperatorLineFirst];
  }
  return _seperatorLineFirst;
}

- (UIImageView *)seperatorLineSecond {
  if (_seperatorLineSecond == nil) {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line"]];
    _seperatorLineSecond = imageView;
    [self addSubview:_seperatorLineSecond];
  }
  return _seperatorLineSecond;
}



@end
