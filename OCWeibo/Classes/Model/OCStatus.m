//
//  OCStatus.m
//  OCWeibo
//
//  Created by Maple on 16/7/23.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCStatus.h"

@implementation OCStatus

///计算行高
- (void)calRowHeight {
  //cell间距 + 头像间距 + 头像高度 + 内容间距
  CGFloat height = OCCellMargin + OCCellMargin + OCStatusIconWH + OCCellMargin;
  //内容高度
  NSMutableDictionary *attr = [NSMutableDictionary dictionary];
  attr[NSFontAttributeName] = [UIFont systemFontOfSize:OCStatusFontSize];
  height += [self.text boundingRectWithSize:CGSizeMake(OCScreenW - 2 * OCCellMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.height;
  //内容间距
  height += OCCellMargin;
  //配图
  if (self.pictureArray.count > 0) {
    height +=[self calPictureSize:self.pictureArray].height;
    height += OCCellMargin;
  }
  
  //转发
  if (self.retweeted_status) {
    height += OCCellMargin;
    //转发内容
    NSString *retweetContent = [NSString stringWithFormat:@"@%@:%@", self.retweeted_status.user.screen_name, self.retweeted_status.text];
    height += [retweetContent boundingRectWithSize:CGSizeMake(OCScreenW - 2 * OCCellMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.height;
    height += OCCellMargin;
    
    //转发配图
    if (self.retweeted_status.pictureArray.count > 0) {
      height +=[self calPictureSize:self.retweeted_status.pictureArray].height;
      height += OCCellMargin;
    }
  }
  //底部
  height += OCStatusBottomHeight;
  self.rowHeight = height;
}

///计算图片高度
- (CGSize)calPictureSize: (NSArray *)pictureArray {
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


/**
 * 字典转模型
 */
+ (instancetype)statusWithDic:(NSDictionary *)dic {
  
  return [[self alloc] initWithDic:dic];
}

- (instancetype)initWithDic: (NSDictionary *)dic {
  if (self = [super init]) {
    [self setValuesForKeysWithDictionary:dic];
    //计算行高
    [self calRowHeight];
  }
  return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

- (void)setValue:(id)value forKey:(NSString *)key {
  if ([key isEqualToString:@"id"]) {
    self.ID = [value integerValue];
  }else if([key isEqualToString:@"user"]) {
    self.user = [OCUser userWithDic:value];
  }else if([key isEqualToString:@"retweeted_status"]) {
    self.retweeted_status = [OCStatus statusWithDic:value];
  }else {
    [super setValue:value forKey:key];
  }
}

- (NSString *)description
{
  NSArray *keys = @[@"created_at", @"ID", @"text", @"pic_urls", @"source", @"reposts_count", @"comments_count", @"attitudes_count",];
  
  return [NSString stringWithFormat:@"微博模型:%@", [self dictionaryWithValuesForKeys:keys]];
}

#pragma mark 重写set方法
- (void)setPic_urls:(NSArray *)pic_urls {
  _pic_urls = pic_urls;
  NSMutableArray *pictureUrlArray = [NSMutableArray array];
  for (NSDictionary *dic in pic_urls) {
    NSString *urlStirng = dic[@"thumbnail_pic"];
    [pictureUrlArray addObject:[NSURL URLWithString:urlStirng]];
  }
  self.pictureArray = pictureUrlArray;
}

- (void)setSource:(NSString *)source {
  if (source.length == 0) {
    _source = @"未知来源";
  }else {
    NSRange rangeFirst = [source rangeOfString:@">"];
    NSRange rangeSecond = [source rangeOfString:@"</"];
    //截取
    _source = [source substringWithRange:NSMakeRange(rangeFirst.location + 1, rangeSecond.location - rangeFirst.location - 1)];
  }
  
}


@end
