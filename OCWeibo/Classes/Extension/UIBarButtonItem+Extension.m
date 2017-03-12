//
//  UIBarButtonItem+Extension.m
//  OCWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (instancetype)itemWithImage: (NSString *)image {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
  NSString *hightlighted = [image stringByAppendingString:@"_highlighted"];
  [button setImage:[UIImage imageNamed:hightlighted] forState:UIControlStateHighlighted];

  [button sizeToFit];
  return [[self alloc] initWithCustomView:button];
}

+ (instancetype)itemWithImgae:(NSString *)image target:(id)target action:(SEL)action {
  //设置图片
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
  NSString *hightlighted = [image stringByAppendingString:@"_highlighted"];
  //添加点击事件
  [button setImage:[UIImage imageNamed:hightlighted] forState:UIControlStateHighlighted];
  [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  [button sizeToFit];
  return [[self alloc] initWithCustomView:button];
}

@end
