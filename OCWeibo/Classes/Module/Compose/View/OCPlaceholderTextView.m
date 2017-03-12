//
//  OCPlaceholderTextView.m
//  OCWeibo
//
//  Created by Maple on 16/7/28.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCPlaceholderTextView.h"

@interface OCPlaceholderTextView ()
@property (nonatomic, weak) UILabel *placeholderLabel;
@end

@implementation OCPlaceholderTextView

- (instancetype)init {
  if (self = [super init]) {
    [self setupUI];
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUI {
  self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
  //设置约束
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:5]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:8]];
}

- (void)textChange {
  self.placeholderLabel.hidden = self.hasText;
}

- (void)setPlaceholder:(NSString *)placeholder {
  _placeholder = placeholder;
  self.placeholderLabel.text = placeholder;
}

#pragma mark 懒加载
- (UILabel *)placeholderLabel {
  if (_placeholderLabel == nil) {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:18];
    _placeholderLabel = label;
    [self addSubview:label];
  }
  return _placeholderLabel;
}

@end
