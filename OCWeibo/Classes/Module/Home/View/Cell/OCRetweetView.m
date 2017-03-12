//
//  OCRetweetView.m
//  OCWeibo
//
//  Created by Maple on 16/7/24.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCRetweetView.h"
#import "OCPictureView.h"
#import "UILabel+Extension.h"
#import <Masonry.h>

@interface OCRetweetView ()

///转发内容
@property (nonatomic, weak) UILabel *contentLabel;
///转发配图
@property (nonatomic, weak) OCPictureView *retweetPictureView;
@end

@implementation OCRetweetView

- (void)setStatus:(OCStatus *)status {
  _status = status;
  if (status == nil) {
    return;
  }
  self.contentLabel.text = [NSString stringWithFormat:@"@%@:%@", status.user.screen_name, status.text];
  self.retweetPictureView.pictureUrlArray = status.pictureArray;
  //根据是否有配图，更新retweetView的约束
  CGFloat margin = OCCellMargin;
  if (status.pictureArray.count == 0) {
    margin = 0;
  }
  [self mas_updateConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.retweetPictureView.mas_bottom).offset(margin);
  }];
}

- (instancetype)init {
  if (self = [super init]) {
    [self setupUI];
  }
  return self;
}

- (void)setupUI {
//  self.backgroundColor = [UIColor brownColor];
  [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.leading.equalTo(self).offset(OCCellMargin);

  }];
  
  [self.retweetPictureView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self).offset(OCCellMargin);
    make.top.equalTo(self.contentLabel.mas_bottom).offset(OCCellMargin);
    make.size.mas_equalTo(CGSizeZero);
  }];
  
  [self mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.retweetPictureView.mas_bottom).offset(OCCellMargin);
  }];
}

#pragma mark 懒加载
- (UILabel *)contentLabel {
  if (_contentLabel == nil) {
    UILabel *label = [UILabel labelWithColor:[UIColor darkGrayColor] fontSize:OCStatusFontSize];
    label.numberOfLines = 0;
    label.preferredMaxLayoutWidth = OCScreenW - 2 * OCCellMargin;
    _contentLabel = label;
    [self addSubview:label];
  }
  return _contentLabel;
}

- (OCPictureView *)retweetPictureView {
  if (_retweetPictureView == nil) {
    OCPictureView *pictureView = [[OCPictureView alloc] init];
    _retweetPictureView = pictureView;
    [self addSubview:pictureView];
  }
  return _retweetPictureView;
}


@end
