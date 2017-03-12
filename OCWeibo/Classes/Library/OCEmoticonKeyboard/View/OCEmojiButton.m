//
//  OCEmojiButton.m
//  表情键盘
//
//  Created by Maple on 16/7/29.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCEmojiButton.h"
#import "OCEmoji.h"

@implementation OCEmojiButton

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.titleLabel.font = [UIFont systemFontOfSize:34];
  }
  return self;
}

- (void)setEmojiModel:(OCEmoji *)emojiModel {
  _emojiModel = emojiModel;
//  NSLog(@"%@--%@--%@", emojiModel.png, emojiModel.code, emojiModel.chs);
  //如果emoji有值，则显示，否则清空
  if (emojiModel.code) {
    [self setTitle:emojiModel.emoji forState:UIControlStateNormal];
  }else {
    [self setTitle:nil forState:UIControlStateNormal];
  }
  
  //设置图片
  if (emojiModel.png) {
    [self setImage:[UIImage imageNamed:emojiModel.fullPathPNG] forState:UIControlStateNormal];
  }else {
    [self setImage:nil forState:UIControlStateNormal];
  }
}

@end
