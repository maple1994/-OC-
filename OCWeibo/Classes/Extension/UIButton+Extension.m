//
//  UIButton+Extension.m
//  OCWeibo
//
//  Created by Maple on 16/7/24.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

+ (instancetype)buttonWithTitle:(NSString *)title image:(NSString *)image {
  UIButton *button = [[UIButton alloc] init];
  [button setTitle:title forState:UIControlStateNormal];
  [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background"] forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
  [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  button.titleLabel.font = [UIFont systemFontOfSize:15];
  return button;
}

@end
