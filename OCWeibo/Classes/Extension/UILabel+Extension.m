//
//  UILabel+Extension.m
//  OCWeibo
//
//  Created by Maple on 16/7/23.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

/**
 * 根据传入的颜色和文字大小创建label
 */
+ (instancetype)labelWithColor:(UIColor *)color fontSize:(CGFloat)fontSize {
  UILabel *label = [[UILabel alloc] init];
  label.textColor = color;
  label.font = [UIFont systemFontOfSize:fontSize];
  return label;
}

@end
