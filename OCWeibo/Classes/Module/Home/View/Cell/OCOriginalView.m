//
//  OCOriginalView.m
//  OCWeibo
//
//  Created by Maple on 16/7/24.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCOriginalView.h"
#import "UILabel+Extension.h"
#import "OCPictureView.h"
#import "NSDate+Extension.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface OCOriginalView ()
///头像
@property (nonatomic, weak) UIImageView *iconImageView;
///等级
@property (nonatomic, weak) UIImageView *rangeImageView;
///认证
@property (nonatomic, weak) UIImageView *verfiyImageView;
///昵称
@property (nonatomic, weak) UILabel *nameLabel;
///发布时间
@property (nonatomic, weak) UILabel *createLabel;
///来源
@property (nonatomic, weak) UILabel *sourceLabel;
///内容
@property (nonatomic, weak) UILabel *contentLabel;
///图片区域
@property (nonatomic, weak) OCPictureView *pictureView;
@end

@implementation OCOriginalView

- (void)setStatus:(OCStatus *)status {
  _status = status;
  NSURL *url = [NSURL URLWithString:status.user.profile_image_url];
  [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
  self.rangeImageView.image = status.user.rangImage;
  self.verfiyImageView.image = status.user.verfiyImage;
  self.nameLabel.text = status.user.screen_name;
  self.createLabel.text = [[NSDate dateFromSinaString:status.created_at] sinaDateDescription];
  self.sourceLabel.text = status.source;
  self.contentLabel.text = status.text;
  self.pictureView.pictureUrlArray = status.pictureArray;
  //判断是否有配图,重去设置pictureView的约束
  CGFloat margin = OCCellMargin;
  if (self.pictureView.pictureUrlArray.count == 0) {
    margin = 0;
  }
  [self.pictureView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.contentLabel.mas_bottom).offset(margin);
  }];
}

- (instancetype)init {
  if (self = [super init]) {
    [self setupUI];
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (void)setupUI {
  //头像
  [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.leading.equalTo(self).offset(OCCellMargin);
    make.width.height.mas_equalTo(OCStatusIconWH);
  }];
  //昵称
  [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.iconImageView.mas_trailing).offset(OCCellMargin);
    make.top.equalTo(self.iconImageView.mas_top);
  }];
  //等级
  [self.rangeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.nameLabel.mas_trailing).offset(OCCellMargin);
    make.centerY.equalTo(self.nameLabel);
  }];
  //认证
  [self.verfiyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.iconImageView.mas_trailing);
    make.centerY.equalTo(self.iconImageView.mas_bottom);
  }];
  //发布时间
  [self.createLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.nameLabel);
    make.bottom.equalTo(self.iconImageView);
  }];
  //来源
  [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.createLabel.mas_trailing).offset(OCCellMargin);
    make.bottom.equalTo(self.createLabel);
  }];
  //内容
  [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.iconImageView.mas_bottom).offset(OCCellMargin);
    make.leading.equalTo(self.iconImageView);
  }];
  //图片区域
  [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.contentLabel.mas_bottom).offset(OCCellMargin);
    make.leading.equalTo(self).offset(OCCellMargin);
    make.size.mas_equalTo(CGSizeMake(OCScreenW - 2 * OCCellMargin, OCScreenW - 2 * OCCellMargin));
  }];
  [self mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.pictureView).offset(OCCellMargin);
  }];
  
}

#pragma mark 懒加载
- (UIImageView *)iconImageView {
  if (_iconImageView == nil) {
    UIImageView *imageView = [[UIImageView alloc] init];
    _iconImageView = imageView;
    [self addSubview:imageView];
  }
  return _iconImageView;
}

- (UIImageView *)rangeImageView {
  if (_rangeImageView == nil) {
    UIImageView *imageView = [[UIImageView alloc] init];
    _rangeImageView = imageView;
    [self addSubview:imageView];
  }
  return _rangeImageView;
}

- (UIImageView *)verfiyImageView {
  if (_verfiyImageView == nil) {
    UIImageView *imageView = [[UIImageView alloc] init];
    _verfiyImageView = imageView;
    [self addSubview:imageView];
  }
  return _verfiyImageView;
}

- (UILabel *)nameLabel {
  if (_nameLabel == nil) {
    UILabel *label = [UILabel labelWithColor:[UIColor darkGrayColor] fontSize:15];
    _nameLabel = label;
    [self addSubview:label];
  }
  return _nameLabel;
}

- (UILabel *)sourceLabel {
  if (_sourceLabel == nil) {
    UILabel *label = [UILabel labelWithColor:[UIColor lightGrayColor] fontSize:12];
    _sourceLabel = label;
    [self addSubview:label];
  }
  return _sourceLabel;
}

- (UILabel *)createLabel {
  if (_createLabel == nil) {
    UILabel *label = [UILabel labelWithColor:[UIColor orangeColor] fontSize:12];
    _createLabel = label;
    [self addSubview:label];
  }
  return _createLabel;
}

- (UILabel *)contentLabel {
  if (_contentLabel == nil) {
    UILabel *label = [UILabel labelWithColor:[UIColor darkGrayColor] fontSize:OCStatusFontSize];
    _contentLabel = label;
    label.numberOfLines = 0;
    label.preferredMaxLayoutWidth = OCScreenW - 2 * OCCellMargin;
    [self addSubview:label];
  }
  return _contentLabel;
}

- (OCPictureView *)pictureView {
  if (_pictureView == nil) {
    OCPictureView *pictureView = [[OCPictureView alloc] init];
    _pictureView = pictureView;
    [self addSubview:pictureView];
  }
  return _pictureView;
}




@end
