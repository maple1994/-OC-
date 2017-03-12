//
//  OCHomeTitleButton.m
//  OCWeibo
//
//  Created by Maple on 16/7/23.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCHomeTitleButton.h"

@implementation OCHomeTitleButton

- (void)layoutSubviews {
  [super layoutSubviews];
  //重新布局imageView和titleLabel
  self.titleLabel.x = 0;
  self.imageView.x = self.titleLabel.width + 5;
  [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
  [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self sizeToFit];
}

@end
