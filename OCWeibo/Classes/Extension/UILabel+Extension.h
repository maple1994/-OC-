//
//  UILabel+Extension.h
//  OCWeibo
//
//  Created by Maple on 16/7/23.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

/**
 * 根据传入的颜色和文字大小创建label
 */
+ (instancetype)labelWithColor:(UIColor *)color fontSize:(CGFloat)fontSize;

@end
