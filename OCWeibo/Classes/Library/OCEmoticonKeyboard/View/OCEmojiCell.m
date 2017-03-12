//
//  OCEmojiCell.m
//  表情键盘
//
//  Created by Maple on 16/7/29.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCEmojiCell.h"
#import "UIColor+Random.h"
#import "OCEmoji.h"
#import "OCEmojiButton.h"
#import "OCTipView.h"

@interface OCEmojiCell ()
///调试label
@property (nonatomic, weak) UILabel *debugLabel;
///按钮数组
@property (nonatomic, strong) NSMutableArray *buttons;
///删除按钮
@property (nonatomic, weak) UIButton *deleteButton;
///最近label
@property (nonatomic, weak) UILabel *recentLabel;
///提示视图
@property (nonatomic, weak) OCTipView *tipView;

@end

@implementation OCEmojiCell

- (void)setEmojiModelArray:(NSArray<OCEmoji *> *)emojiModelArray {
  _emojiModelArray = emojiModelArray;
  //默认隐藏按钮，要才显示
  for (OCEmojiButton *button in self.buttons) {
    button.hidden = YES;
  }
  NSInteger count = 0;
  for (OCEmoji *emoji in emojiModelArray) {
    OCEmojiButton *button = self.buttons[count];
    button.hidden = NO;
    button.emojiModel = emoji;
    count++;
  }
}

#pragma mark - 私有方法
- (OCEmojiButton *)getButtonWithLocation:(CGPoint)location {
  for (OCEmojiButton *btn in self.buttons) {
    //当前点在按钮上，且按钮不为空
    if (CGRectContainsPoint(btn.frame, location) && !btn.isHidden) {
      return btn;
    }
  }
  return nil;
}

- (void)longPress:(UIGestureRecognizer *)recognizer {
  CGPoint location = [recognizer locationInView:self.contentView];
  OCEmojiButton *button = [self getButtonWithLocation:location];
  if (!button) {
    self.tipView.hidden = YES;
    return;
  }
  
  switch (recognizer.state) {
    case UIGestureRecognizerStateBegan:
    case UIGestureRecognizerStateChanged:
      self.tipView.hidden = NO;
      //转换坐标系
      CGPoint center = [self convertPoint:button.center toView:self.window];
      self.tipView.center = center;
      self.tipView.emojiModel = button.emojiModel;
      break;
    case UIGestureRecognizerStateEnded:
      self.tipView.hidden = YES;
      [self buttonClick:button];
      break;
    case UIGestureRecognizerStateFailed:
    case UIGestureRecognizerStateCancelled:
      self.tipView.hidden = YES;
      break;
    default:
      break;
  }
}

- (void)buttonClick:(OCEmojiButton *)button {
  if ([self.deleagte respondsToSelector:@selector(emojiCellDidClickButton:)]) {
    [self.deleagte emojiCellDidClickButton:button.emojiModel];
  }
}

- (void)deleteButtonClick {
  if ([self.deleagte respondsToSelector:@selector(emojiCellDidClickDelete)]) {
    [self.deleagte emojiCellDidClickDelete];
  }
}

#pragma mark - 设置界面
- (void)willMoveToWindow:(UIWindow *)newWindow {
  OCTipView *tipView = [[OCTipView alloc] init];
  self.tipView = tipView;
  self.tipView.hidden = YES;
  [newWindow addSubview:tipView];
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setupUI];
  }
  return self;
}

- (void)setupUI {
  //添加20个按钮
  for (NSInteger i = 0; i < maxNumberOfPage; i++) {
    OCEmojiButton *button = [[OCEmojiButton alloc] init];
    button.hidden = YES;
    //添加点击事件
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    [self.buttons addObject:button];
    //添加长按手势
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    press.minimumPressDuration = 0.1;
    [button addGestureRecognizer:press];
  }
  //设置最近label的约束
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.recentLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-5]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.recentLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
  self.tipView;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  //布局按钮
  [self layoutButton];
}

- (void)layoutButton {
  //计算按钮宽高
  CGFloat lrMargin = 5;
  CGFloat bottomHeight = 25;
  CGFloat width = (self.contentView.frame.size.width - 2 * lrMargin) / maxNumberOfCol;
  CGFloat height = (self.contentView.frame.size.height - bottomHeight) / maxNumberOfRow;
  //设置按钮的frame
  for (NSInteger i = 0; i < maxNumberOfPage; i++) {
    UIButton *button = self.buttons[i];
    NSInteger row = i / maxNumberOfCol;
    NSInteger col = i % maxNumberOfCol;

    button.frame = CGRectMake(lrMargin + col * width, row * height, width, height);
  }
  //设置删除按钮的frame，固定在第六列第二行
  CGFloat x = (maxNumberOfCol - 1) * width + lrMargin;
  CGFloat y = (maxNumberOfRow - 1) * height;
  self.deleteButton.frame = CGRectMake(x, y, width, height);
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
  _indexPath = indexPath;
  self.debugLabel.text = [NSString stringWithFormat:@"第%zd组--第%zd列", indexPath.section, indexPath.item];
  self.recentLabel.hidden = (indexPath.section != 0);
}

#pragma mark - 懒加载

- (UILabel *)debugLabel {
  if (_debugLabel == nil) {
    UILabel *label = [[UILabel alloc] init];
    label.hidden = YES;
    _debugLabel = label;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:25];
    label.frame = CGRectMake(10, 10, 350, 150);
    [self.contentView addSubview:label];
  }
  return _debugLabel;
}

- (NSMutableArray *)buttons {
  if (_buttons == nil) {
    _buttons = [NSMutableArray array];
  }
  return _buttons;
}

- (UIButton *)deleteButton {
  if (_deleteButton == nil) {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
    _deleteButton = button;
    //添加点击事件
    [button addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
  }
  return _deleteButton;
}

- (UILabel *)recentLabel {
  if (_recentLabel == nil) {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"最近使用表情";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [label sizeToFit];
    _recentLabel = label;
    [self.contentView addSubview:label];
  }
  return _recentLabel;
}






@end
