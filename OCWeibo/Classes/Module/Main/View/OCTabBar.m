//
//  OCTabBar.m
//  OCWeibo
//
//  Created by Maple on 16/7/18.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCTabBar.h"

@interface OCTabBar ()
///中间按钮
@property (nonatomic, weak) UIButton *composeButton;

@end
@implementation OCTabBar

/**
 * 添加中间按钮
 */
- (void)layoutSubviews {
  [super layoutSubviews];
  NSInteger index = 0;
  CGFloat width = self.frame.size.width / 5;
  for (UIView *view in self.subviews) {
    if ([view isKindOfClass:[UIControl class]]) {
      view.frame = CGRectMake(index * width, 0, width, self.frame.size.height);
      
      index++;
      if (index == 2) {
        index++;
      }
    }
  }
  self.composeButton.frame = CGRectMake(2 * width, 0, width, self.frame.size.height);
}

/**
 * public点击事件
 */
- (void)composeClick {
  if (self.block) {
    self.block();
  }
}

#pragma mark 懒加载
- (UIButton *)composeButton {
  if (!_composeButton) {
    UIButton *button = [[UIButton alloc] init];
    _composeButton = button;
    [button setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    //添加点击事件
    [button addTarget:self action:@selector(composeClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_composeButton];
  }
  return _composeButton;
}

@end
