//
//  OCPictureView.m
//  OCWeibo
//
//  Created by Maple on 16/7/24.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCPictureView.h"
#import "UIColor+Random.h"
#import "SDPhotoBrowser.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface OCPictureView ()<SDPhotoBrowserDelegate>
///imageView数组
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@end

@implementation OCPictureView



- (instancetype)init {
  if (self == [super init]) {
    self.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    
  }
  return self;
}

- (void)setupUI {
  for (int i = 0; i < 9; i++) {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
    [self.imageViewArray addObject:imageView];
    ///添加点击事件
    imageView.tag = i;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [imageView addGestureRecognizer:tap];
  }
}

///图片点击事件
- (void)tap:(UIGestureRecognizer *)recognizer {
  SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
  
  browser.sourceImagesContainerView = self;
  
  browser.imageCount = self.pictureUrlArray.count;
  
  browser.currentImageIndex = recognizer.view.tag;
  
  browser.delegate = self;
  
  [browser show]; // 展示图片浏览器
}

///布局imageView
- (CGSize)layoutImageViewWithPictureArray: (NSArray *)pictureArray {
  NSInteger maxColumn = 3;
  CGFloat imageMargin = 4;
  CGFloat imageWH = (OCScreenW - 2 * OCCellMargin - (maxColumn - 1) * imageMargin) / maxColumn;
  
  NSInteger numberOfColumn = maxColumn;
  NSInteger count = pictureArray.count;
  if (count == 1) {
    numberOfColumn = 1;
  }else if(count == 2 || count == 4) {
    numberOfColumn = 2;
  }

  for(int i = 0; i < self.imageViewArray.count; i++) {
    UIImageView *imageView = self.imageViewArray[i];
    
    //根据数组的个数，显示和隐藏imageView
    if (i >= count) {
      imageView.hidden = YES;
    }else {
      imageView.hidden = NO;
      int row = i / numberOfColumn;
      int col = i % numberOfColumn;
      imageView.frame = CGRectMake(col * (imageWH + imageMargin), row * (imageWH + imageMargin), imageWH, imageWH);
      imageView.backgroundColor = [UIColor randomColor];
      //设置图片
      [imageView sd_setImageWithURL:pictureArray[i]];
      
    }
  }
  if (count == 0) {
    return CGSizeZero;
  }else {
    //计算宽
    CGFloat width = maxColumn * imageWH + (maxColumn - 1) * imageMargin;
    //计算高
    CGFloat numberOfRow = (count + numberOfColumn - 1) / numberOfColumn;
    CGFloat height = numberOfRow * imageWH + (numberOfRow - 1) * imageMargin;
    return CGSizeMake(width, height);
  }
}

#pragma mark - SDPhoto代理方法
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
  UIImageView *imageView = self.imageViewArray[index];
  return imageView.image;
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
  /*
   let urlString = pictureUrlArray![index].absoluteString
   // 换成大图
   let largeUrlString = urlString.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
   */
  NSURL *url = self.pictureUrlArray[index];
  NSString *urlString = url.absoluteString;
  NSString *largeString = [urlString stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large" options:0 range:NSMakeRange(0, urlString.length)];
  return [NSURL URLWithString:largeString];
}

#pragma mark 懒加载
- (NSMutableArray *)imageViewArray {
  if (_imageViewArray == nil) {
    _imageViewArray = [NSMutableArray array];
  }
  return _imageViewArray;
}

- (void)setPictureUrlArray:(NSArray *)pictureUrlArray {
  _pictureUrlArray = pictureUrlArray;
  CGSize size = [self layoutImageViewWithPictureArray:pictureUrlArray];
  //更新约束
  [self mas_updateConstraints:^(MASConstraintMaker *make) {
    make.size.mas_equalTo(size);
  }];
}

@end
