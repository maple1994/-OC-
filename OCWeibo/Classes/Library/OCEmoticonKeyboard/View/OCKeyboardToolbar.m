//
//  OCKeyboardToolbar.m
//  表情键盘
//
//  Created by Maple on 16/7/29.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCKeyboardToolbar.h"
#import "UIColor+Random.h"


@interface OCKeyboardToolbar ()
///保存按钮的数据
@property (nonatomic, strong) NSMutableArray *buttons;
///记录选中的按钮
@property (nonatomic, strong) UIButton *selectedButton;
@end

@implementation OCKeyboardToolbar

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setupUI];
  }
  return self;
}

- (void)setupUI {
  NSArray *titleArray = @[@"最近", @"默认", @"emoji", @"浪小花"];
  //创建按钮
  NSInteger index = 0;
  for (NSString *title in titleArray) {
    //设置按钮属性
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"compose_emotion_table_mid_normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"compose_emotion_table_mid_selected"] forState:UIControlStateDisabled];
    button.tag = index;
    
    //添加点击事件
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //默认选中第一个按钮
    if (index == 0) {
      [self buttonClick:button];
    }
    //添加到view中
    [self addSubview:button];
    [self.buttons addObject:button];
    index++;
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];
  //布局按钮
  [self layoutButton];
}

///布局按钮
- (void)layoutButton {
  //计算按钮宽
  CGFloat width = [UIScreen mainScreen].bounds.size.width / self.buttons.count;
  CGFloat height = self.frame.size.height;
  [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
    button.frame = CGRectMake(idx * width, 0, width, height);
  }];
}

///点击按钮
- (void)buttonClick:(UIButton *)button {
  [self switchButtonStates:button];
  //执行代理方法
  if ([self.delegate respondsToSelector:@selector(keyboardToolbar:didSelected:)]) {
    [self.delegate keyboardToolbar:self didSelected:button.tag];
  }
}

- (void)selectTitleWithSeciont:(NSInteger) section {
  UIButton *button = self.buttons[section];
  [self switchButtonStates:button];
}

///改变按钮状态
- (void)switchButtonStates:(UIButton *)button {
  if (self.selectedButton == nil) {
    button.enabled = NO;
    self.selectedButton = button;
  }else {
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
  }
}


#pragma mark 懒加载
- (NSMutableArray *)buttons {
  if (_buttons == nil) {
    _buttons = [NSMutableArray array];
  }
  return _buttons;
}

@end
