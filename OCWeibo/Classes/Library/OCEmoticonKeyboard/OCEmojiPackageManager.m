//
//  OCEmojiPackageManager.m
//  表情键盘
//
//  Created by Maple on 16/7/29.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCEmojiPackageManager.h"
#import "OCEmojiPackage.h"
#import "OCEmoji.h"
#define mainBundlePath [[NSBundle mainBundle] pathForResource:@"Emoticons.bundle" ofType:nil]
#define recentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"recent.plist"]
@implementation OCEmojiPackageManager

static OCEmojiPackageManager *instance;
+ (instancetype)sharedPackageManager {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] init];
  });
  return instance;
}

/**
 * 添加最近表情
 */
- (void)addFavorite:(OCEmoji *)emojiModel {
  //取出"最近"数组
  NSArray<OCEmoji *> *temp = self.allEmojiPackages[0].pageEmoticons[0];
  NSMutableArray<OCEmoji *> *recentEmoticon = [NSMutableArray arrayWithArray:temp];
  //保存重复的表情
  OCEmoji *repeatEmoji = nil;
  
  for (OCEmoji *e in recentEmoticon) {
    //判断是否重复
    if ((e.code != nil && [e.code isEqualToString:emojiModel.code]) || ([e.png isEqualToString:emojiModel.png])) {
      repeatEmoji = e;
    }
  }
  
  if (repeatEmoji) {
    //去掉重复的表情
    [recentEmoticon removeObject:repeatEmoji];
  }
  
  
  [recentEmoticon insertObject:emojiModel atIndex:0];
  //判断是否越界
  if (recentEmoticon.count > 20) {
    [recentEmoticon removeLastObject];
  }
  self.allEmojiPackages[0].pageEmoticons[0] = [NSArray arrayWithArray:recentEmoticon];
  //保存
  [self saveRecentEmoticon];
}

///保存“最近”表情
- (void)saveRecentEmoticon {
  [NSKeyedArchiver archiveRootObject:self.allEmojiPackages[0].pageEmoticons[0] toFile:recentPath];
}

///加载“最近”表情
- (NSArray <OCEmoji *>*)loadRecentEmoticon {
  NSArray <OCEmoji *> *recentEmoticon = [NSKeyedUnarchiver unarchiveObjectWithFile:recentPath];
  if (recentEmoticon) {
    return recentEmoticon;
  }else {
    NSArray<OCEmoji *> *emptyArray = [NSArray array];
    return emptyArray;
  }
  
}

/**
 * 加载一个表情包数据
 *
 * @param ID 表情包文件夹名称
 */
- (OCEmojiPackage *)loadEmojiPackageWithID:(NSString *)ID {
  //拼接表情包路径
  NSString *filePath = [NSString stringWithFormat:@"%@/%@/info.plist", mainBundlePath, ID];
  NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
  NSString *myID = dictionary[@"id"];
  NSString *group_name_cn = dictionary[@"group_name_cn"];
  NSArray *emoticons = dictionary[@"emoticons"];
  NSMutableArray *modelArray = [NSMutableArray array];
  
  for (NSDictionary *dic in emoticons) {
    OCEmoji *emoji = [OCEmoji emojiWithDic:dic ID:myID];
    [modelArray addObject:emoji];
  }
  return [OCEmojiPackage emojiPackageWithID:myID groupName:group_name_cn emoticons:modelArray];
}

/**
 * 加载所有表情包数据
 */
- (NSArray<OCEmojiPackage *>*)loadAllEmojiPackageWithID {
  OCEmojiPackage *recent = [OCEmojiPackage emojiPackageWithID:@"" groupName:@"最近" emoticons:[self loadRecentEmoticon]];
  OCEmojiPackage *emojiPackage = [self loadEmojiPackageWithID:@"com.apple.emoji"];
  OCEmojiPackage *defaultPackage = [self loadEmojiPackageWithID:@"com.sina.default"];
  OCEmojiPackage *lxhEmoticonPackage = [self loadEmojiPackageWithID:@"com.sina.lxh"];
  return @[recent, defaultPackage, emojiPackage, lxhEmoticonPackage];
}

- (NSArray<OCEmojiPackage *> *)allEmojiPackages {
  if (_allEmojiPackages == nil) {
    _allEmojiPackages = [self loadAllEmojiPackageWithID];
  }
  return _allEmojiPackages;
}

@end
