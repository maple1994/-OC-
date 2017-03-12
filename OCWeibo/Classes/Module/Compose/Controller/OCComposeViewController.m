//
//  OCComposeViewController.m
//  OCWeibo
//
//  Created by Maple on 16/7/28.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCComposeViewController.h"
#import "OCPlaceholderTextView.h"
#import "UIBarButtonItem+Extension.h"
#import "OCEmojiKeyboardView.h"
#import "UITextView+OCEmoticon.h"
#import <SVProgressHUD.h>
#import <Masonry.h>
#import "OCWeibo-Swift.h"

#define maxLength 25
@interface OCComposeViewController ()<UITextViewDelegate>

///输入框
@property (nonatomic, weak) OCPlaceholderTextView *textView;
///工具条
@property (nonatomic, weak) UIToolbar *toolbar;
///表情键盘
@property (nonatomic, strong) OCEmojiKeyboardView *emojiKeyboard;
///显示字数长度的label
@property (nonatomic, weak) UILabel *numberLabel;
///图片选择器
@property (nonatomic, weak) MPPicturePickerController *pickerController;
///是否正在显示图片选择器
@property (nonatomic, assign) BOOL isShowing;
@end

@implementation OCComposeViewController

#pragma mark View的生命周期
- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupUI];
  [self setupNav];
  [self setupPicturePicker];
  [self setupToolbar];
  [self setupNumberLabel];
  //添加监听
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (!self.isShowing) {
    [self.textView becomeFirstResponder];
  }
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark UI设置
///设置图片选择器
- (void)setupPicturePicker {
  CGFloat height = OCScreenH * 0.6;
  [self.pickerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.trailing.leading.equalTo(self.view);
    make.bottom.equalTo(self.view).offset(height);
    make.height.mas_equalTo(height);
  }];
}

///设置numberLabel
- (void)setupNumberLabel {
  [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.toolbar.mas_top).offset(-5);
    make.trailing.equalTo(self.view).offset(-5);
  }];
}

///设置导航栏
- (void)setupNav {
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(publish)];
  self.navigationItem.rightBarButtonItem.enabled = false;
  //设置标题
  [self setupTitle];
}

///设置标题
- (void)setupTitle {
  //取出当前用户名
  OCUserAccount *account = [OCUserAccountViewModel sharedAccountViewModel].account;
  NSString *title = [NSString stringWithFormat:@"发微博\n%@", account.screen_name];
  
  //创建富文本并设置属性
  NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
  NSRange range = [title rangeOfString:account.screen_name];
  NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
  attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
  attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
  [attrString addAttributes:attrs range:range];
  
  //创建label并设置属性
  UILabel *titleLabel = [[UILabel alloc] init];
  titleLabel.attributedText = attrString;
  titleLabel.font = [UIFont systemFontOfSize:15];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.numberOfLines = 0;
  [titleLabel sizeToFit];
  self.navigationItem.titleView = titleLabel;
}

///设置工具条
- (void)setupToolbar {
  [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.bottom.trailing.equalTo(self.view);
  }];
  //compose_keyboardbutton_background_highlighted
  //compose_emoticonbutton_background
  NSArray *itemSettings = @[
  @{@"imageName": @"compose_toolbar_picture", @"action": @"picture"},
  @{@"imageName": @"compose_trendbutton_background", @"action": @"trend"},
  @{@"imageName": @"compose_mentionbutton_background", @"action": @"mention"},
  @{@"imageName": @"compose_keyboardbutton_background", @"action": @"emoticon"},
  @{@"imageName": @"compose_add_background", @"action": @"add"}];
  //添加按钮
  NSMutableArray *tempArray = [NSMutableArray array];
  for (NSDictionary *dic in itemSettings) {
    NSString *imageName = dic[@"imageName"];
    NSString *action = dic[@"action"];
    
    UIBarButtonItem *item = [UIBarButtonItem itemWithImgae:imageName target:self action:NSSelectorFromString(action)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [tempArray addObject:item];
    [tempArray addObject:space];
  }
  [tempArray removeLastObject];
  self.toolbar.items = tempArray;
}

#pragma mark 私有方法
- (void)textChange {
  self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

- (void)keyboardChange:(NSNotification *)notification {
  NSDictionary *userinfo = notification.userInfo;
  //键盘动画时间
  CGFloat duration = [userinfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
  //取出键盘最后的frame
  CGRect endRect = [userinfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  //计算偏移量
  CGFloat offY = -(OCScreenH - endRect.origin.y);
  //修改约束
  [self.toolbar mas_updateConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.view).offset(offY);
  }];
  [UIView animateWithDuration:duration animations:^{
    [self.view layoutIfNeeded];
  }];
}

#pragma mark 点击事件
- (void)setupUI {
  [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view);
  }];
}

- (void)cancle {
  [SVProgressHUD dismiss];
  [self.textView resignFirstResponder];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)publish {
  //获取发布的内容
  NSString *status = [self.textView resultString];
  //获取图片
  UIImage *image = self.pickerController.images.firstObject;
  
  //判断是否超出长度
  if (status.length > maxLength) {
    [SVProgressHUD showErrorWithStatus:@"微博长度超出限制"];
    return;
  }
  [SVProgressHUD showWithStatus:@"正在发微博..."];
  [[OCStatusViewModel sharedStatusViewModel] sendStatus:status image:image completion:^(NSError *error) {
    if (error) {
      [SVProgressHUD showErrorWithStatus:@"发送微博失败"];
    }
    [SVProgressHUD showSuccessWithStatus:@"发送微博成功"];
    //延时关闭
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self cancle];
    });
  }];
}

- (void)picture {
  self.isShowing = YES;
  [self.pickerController.view mas_updateConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.view).offset(0);
  }];
  [UIView animateWithDuration:0.25 animations:^{
    [self.view layoutIfNeeded];
  }];
}

- (void)trend {
  NSLog(@"#");
}

- (void)mention {
  NSLog(@"@");
}

- (void)emoticon {
  //compose_keyboardbutton_background_highlighted
  //compose_emoticonbutton_background
  //修改图片
  UIImage *image = nil;
  UIImage *highlightImage = nil;
  [self.textView resignFirstResponder];
  //切换表情键盘
  if (self.textView.inputView == nil) {
    self.textView.inputView = self.emojiKeyboard;
    image = [UIImage imageNamed:@"compose_emoticonbutton_background"];
    highlightImage = [UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"];
  }else {
    self.textView.inputView = nil;
    image = [UIImage imageNamed:@"compose_keyboardbutton_background"];
    highlightImage = [UIImage imageNamed:@"compose_keyboardbutton_background_highlighted"];
  }
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(250 * USEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self.textView becomeFirstResponder];
  });
  
}

- (void)add {
  NSLog(@"+");
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
  NSInteger len = maxLength - [textView resultString].length;
  if (len < 0) {
    self.numberLabel.textColor = [UIColor redColor];
  }else {
    self.numberLabel.textColor = [UIColor lightGrayColor];
  }
  self.numberLabel.text = [NSString stringWithFormat:@"%zd", len];
}

#pragma mark 懒加载

- (MPPicturePickerController *)pickerController {
  if (_pickerController == nil) {
    MPPicturePickerController *pc = [[MPPicturePickerController alloc] init];
    _pickerController = pc;
    [self.view addSubview:_pickerController.view];
    [self addChildViewController:_pickerController];
  }
  return _pickerController;
}

- (OCEmojiKeyboardView *)emojiKeyboard {
  if (_emojiKeyboard == nil) {
    _emojiKeyboard = [[OCEmojiKeyboardView alloc] init];
    _emojiKeyboard.textView = self.textView;
  }

  return _emojiKeyboard;
}

- (OCPlaceholderTextView *)textView {
  if (_textView == nil) {
    OCPlaceholderTextView *textView = [[OCPlaceholderTextView alloc] init];
    _textView = textView;
    textView.alwaysBounceVertical = YES;
    textView.placeholder = @"请输入内容...";
    textView.keyboardDismissMode= UIScrollViewKeyboardDismissModeOnDrag;
    textView.font = [UIFont systemFontOfSize:18];
    //指定代理
    textView.delegate = self;
    [self.view addSubview:textView];
  }
  return _textView;
}

-(UIToolbar *)toolbar {
  if (_toolbar == nil) {
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [self.view addSubview:toolbar];
    _toolbar = toolbar;
  }
  return _toolbar;
}

- (UILabel *)numberLabel {
  if (_numberLabel == nil) {
    UILabel *label = [[UILabel alloc] init];
    _numberLabel = label;
    label.text = [NSString stringWithFormat:@"%zd", maxLength];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:label];
  }
  return _numberLabel;
}


@end
