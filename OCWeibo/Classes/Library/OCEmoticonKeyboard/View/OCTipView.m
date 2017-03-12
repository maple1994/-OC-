//
//  OCTipView.m
//  OCWeibo
//
//  Created by Maple on 16/8/10.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCTipView.h"
#import "OCEmoji.h"
#import "OCEmojiButton.h"
#import <pop.h>

@interface OCTipView()
@property (nonatomic, weak) OCEmojiButton *button;
@property (nonatomic, strong) OCEmoji *preEmojiModel;
@end

@implementation OCTipView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self = [self initWithImage:[UIImage imageNamed:@"emoticon_keyboard_magnifier"]];
    [self sizeToFit];
    //设置锚点
    self.layer.anchorPoint = CGPointMake(0.5, 1.2);
    self.button.layer.anchorPoint = CGPointMake(0.5, 0);
    self.button.frame = CGRectMake(0, 8, 36, 36);
    self.button.center = CGPointMake(self.bounds.size.width * 0.5, 0);
  }
  return self;
}

- (void)setEmojiModel:(OCEmoji *)emojiModel {
  _emojiModel = emojiModel;
  //模型相等直接返回
  if (emojiModel == self.preEmojiModel) {
    return;
  }
  self.preEmojiModel = emojiModel;
  
  self.button.emojiModel = emojiModel;
  //设置pop动画
  POPSpringAnimation *pop = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
  pop.fromValue = @30;
  pop.toValue = @8;
  pop.springSpeed = 20;
  pop.springBounciness = 20;
  [self.button pop_addAnimation:pop forKey:nil];
}

- (OCEmojiButton *)button {
  if (_button == nil) {
    OCEmojiButton *button = [[OCEmojiButton alloc] init];
    _button = button;
    [self addSubview:button];
  }
  return _button;
}

@end
