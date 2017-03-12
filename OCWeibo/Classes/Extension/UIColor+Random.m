//
//  UIColor+Random.m
//  OCWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)

+ (instancetype)randomColor {
  CGFloat r = arc4random_uniform(256) / 255.0;
  CGFloat g = arc4random_uniform(256) / 255.0;
  CGFloat b = arc4random_uniform(256) / 255.0;
  return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

@end
