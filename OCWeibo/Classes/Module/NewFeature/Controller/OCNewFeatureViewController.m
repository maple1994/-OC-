//
//  OCNewFeatureViewController.m
//  OCWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCNewFeatureViewController.h"
#import <Masonry/Masonry.h>
#import "UIColor+Random.h"
#import "OCNewFeatureCell.h"

@interface OCNewFeatureViewController()
///流水布局
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
///item个数
@property (nonatomic, assign) NSInteger itemCount;
@end

@implementation OCNewFeatureViewController

- (instancetype)init {
  if (self = [super initWithCollectionViewLayout:self.layout]) {
    
  }
  return self;
}

static NSString *resuedID = @"cell";
- (void)viewDidLoad {
  [super viewDidLoad];
  self.itemCount = 4;
  //注册cell
  [self.collectionView registerClass:[OCNewFeatureCell class] forCellWithReuseIdentifier:resuedID];
  //设置布局
  [self setupLayout];
}

//设置布局属性
- (void)setupLayout {
  self.layout.itemSize = self.view.bounds.size;
  self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  self.layout.minimumLineSpacing = 0;
  self.layout.minimumInteritemSpacing = 0;
  self.collectionView.pagingEnabled = YES;
  self.collectionView.bounces = NO;
}

#pragma mark 懒加载
- (UICollectionViewFlowLayout *)layout {
  if (_layout == nil) {
    _layout = [[UICollectionViewFlowLayout alloc] init];
  }
  return _layout;
}

#pragma mark UICollectViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return _itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  OCNewFeatureCell *cell = (OCNewFeatureCell *)[collectionView dequeueReusableCellWithReuseIdentifier:resuedID forIndexPath:indexPath];
//  cell.backgroundColor = [UIColor randomColor];
  NSString *imagePath = [NSString stringWithFormat:@"new_feature_%zd", indexPath.item + 1];
  cell.image = [UIImage imageNamed:imagePath];
  if (indexPath.item == self.itemCount - 1) {
    [cell showButton:YES];
  }else {
    [cell showButton:NO];
  }
  return cell;
}


@end
