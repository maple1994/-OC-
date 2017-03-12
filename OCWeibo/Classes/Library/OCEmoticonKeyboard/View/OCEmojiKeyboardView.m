//
//  OCEmojiKeyboardView.m
//  表情键盘
//
//  Created by Maple on 16/7/29.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCEmojiKeyboardView.h"
#import "UIColor+Random.h"
#import "OCKeyboardToolbar.h"
#import "OCEmojiCell.h"
#import "OCEmoji.h"
#import "OCEmojiPackage.h"
#import "OCEmojiPackageManager.h"
#import "OCTextAtttachment.h"
#import "UITextView+OCEmoticon.h"

@interface OCEmojiKeyboardView ()<OCKeyboardToolbarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, OCEmojiCellDelegate>
///展示表情的collectView
@property (nonatomic, weak) UICollectionView *collectionView;
///布局
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
///工具条
@property (nonatomic, weak) OCKeyboardToolbar *toolBar;
///页面指示器
@property (nonatomic, weak) UIPageControl *pageControl;
///模拟数据
//@property (nonatomic, strong) NSArray *sections;
@end

@implementation OCEmojiKeyboardView

static CGFloat ketboardHeight = 216;
NSString static *ReuseIdentifier = @"ReuseIdentifier";

- (instancetype)initWithFrame:(CGRect)frame {
  CGRect newFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ketboardHeight);
  if (self = [super initWithFrame:newFrame]) {
    [self setupUI];
//    self.sections = @[@1, @4, @6, @2];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.layout.itemSize = self.collectionView.frame.size;
}

- (void)setupUI {
  //设置可视化语言约束
  self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
  self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
  //设置水平方向的约束
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[cv]-0-|" options:0 metrics:nil views:@{@"cv" : self.collectionView}]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tb]-0-|" options:0 metrics:nil views:@{@"tb" : self.toolBar}]];
  //设置垂直方向的约束
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[cv]-0-[tb(==44)]-0-|" options:0 metrics:nil views:@{@"cv" : self.collectionView, @"tb" : self.toolBar}]];
  
  //添加页码指示器
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:25]];
}

- (void)setupPageControl:(NSIndexPath *)indexPath {
  //设置页码指示器
  self.pageControl.numberOfPages = [OCEmojiPackageManager sharedPackageManager].allEmojiPackages[indexPath.section].pageEmoticons.count;
  self.pageControl.currentPage = indexPath.item;
}

#pragma mark - collectionView代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return [OCEmojiPackageManager sharedPackageManager].allEmojiPackages.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  NSArray *pageEmoticons = [OCEmojiPackageManager sharedPackageManager].allEmojiPackages[section].pageEmoticons;
  return pageEmoticons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  OCEmojiCell *cell = (OCEmojiCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
  cell.indexPath = indexPath;
  //设置代理
  cell.deleagte = self;
  
  NSArray<NSArray<OCEmoji *>*> *pageEmoticons = [OCEmojiPackageManager sharedPackageManager].allEmojiPackages[indexPath.section].pageEmoticons;
  cell.emojiModelArray = pageEmoticons[indexPath.row];
  return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  //中心参照点
  CGPoint refPoint = self.collectionView.center;
  //统一坐标系
  refPoint.x += scrollView.contentOffset.x;
  
  for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
    //判断当前显示cell是否包含参照点
    if (CGRectContainsPoint(cell.frame, refPoint)) {
      //取出当前cell的indexPath
      NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
      [self.toolBar selectTitleWithSeciont:indexPath.section];
      //设置页码指示器
      [self setupPageControl:indexPath];
    }
  }
}

#pragma mark - keyboardToolbar代理方法
- (void)keyboardToolbar:(OCKeyboardToolbar *)toolbar didSelected:(OCKeyboardToolbarType)type {
  //滚动到标题对应的表情
  NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:type];
  [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
  
  [self setupPageControl:indexPath];
}

#pragma mark - OCEmojiCellDelegate
- (void)emojiCellDidClickButton:(OCEmoji *)emojiModel {
  //插入表情
  [self.textView insertEmoticon:emojiModel];
  //添加表情到“最近”表情
  [[OCEmojiPackageManager sharedPackageManager] addFavorite:emojiModel];
}

- (void)emojiCellDidClickDelete {
  [self.textView deleteBackward];
}

#pragma mark - 懒加载
- (UIPageControl *)pageControl {
  if (_pageControl == nil) {
    UIPageControl *pc = [[UIPageControl alloc] init];
    pc.translatesAutoresizingMaskIntoConstraints = NO;
    pc.numberOfPages = 1;
    pc.hidesForSinglePage = YES;
    [pc setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKey:@"currentPageImage"];
    [pc setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKey:@"pageImage"];
    _pageControl = pc;
    [self addSubview:pc];
  }
  return _pageControl;
}

- (UICollectionView *)collectionView {
  if (_collectionView == nil) {
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    collectionView.backgroundColor = [UIColor colorWithWhite:236 / 255.0 alpha:1];
    collectionView.pagingEnabled = YES;
    collectionView.bounces = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    _collectionView = collectionView;
    [self addSubview:collectionView];
    //注册cell
    [collectionView registerClass:[OCEmojiCell class] forCellWithReuseIdentifier:ReuseIdentifier];
  }
  return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
  if (_layout == nil) {
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 0;
  }
  return _layout;
}

- (OCKeyboardToolbar *)toolBar {
  if (_toolBar == nil) {
    OCKeyboardToolbar *toolBar = [[OCKeyboardToolbar alloc] init];
    _toolBar = toolBar;
    toolBar.delegate = self;
    [self addSubview:toolBar];
  }
  return _toolBar;
}

@end
