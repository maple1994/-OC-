//
//  OCEmojiPackage.m
//  表情键盘
//
//  Created by Maple on 16/7/29.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCEmojiPackage.h"
#define maxNumberOfPage 20

@implementation OCEmojiPackage

- (void)setEmoticons:(NSArray<OCEmoji *> *)emoticons {
  _emoticons = emoticons;
  //分割数组
  [self splitEmoticons:emoticons];
}

- (void)splitEmoticons: (NSArray<OCEmoji *> *)emoticons {
  NSMutableArray *pageEmoticon = [NSMutableArray array];
  //计算可以分成几页
  NSInteger pageCount = (emoticons.count + maxNumberOfPage - 1) / maxNumberOfPage;
  //如果是0页，默认添加一页
  NSArray *array = [NSArray array];
  if (pageCount == 0) {
    [pageEmoticon addObject:array];
  }
  //将数组分成pageCount个
  for (NSInteger i = 0; i < pageCount; i++) {
    NSInteger start = i * maxNumberOfPage;
    NSInteger length = maxNumberOfPage;
    //越界判断
    if (start + length > emoticons.count) {
      length = emoticons.count - start;
    }
    NSRange range = NSMakeRange(start, length);
    NSArray *subArray = [emoticons subarrayWithRange:range];
    [pageEmoticon addObject:subArray];
  }
  self.pageEmoticons = pageEmoticon;
}

///创建模型
+ (instancetype)emojiPackageWithID: (NSString *)ID groupName: (NSString *)group_name_cn emoticons: (NSArray<OCEmoji *> *)emoticons {
  OCEmojiPackage *package = [[OCEmojiPackage alloc] init];
  package.ID = ID;
  package.group_name_cn = group_name_cn;
  package.emoticons = emoticons;
  return package;
}

- (void)setValue:(id)value forKey:(NSString *)key{
  if ([key isEqualToString:@"id"]) {
    self.ID = value;
  }
}

@end
