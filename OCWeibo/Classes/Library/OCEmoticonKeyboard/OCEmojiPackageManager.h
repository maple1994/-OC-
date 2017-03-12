//
//  OCEmojiPackageManager.h
//  表情键盘
//
//  Created by Maple on 16/7/29.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OCEmojiPackage;
@class OCEmoji;
/// 加载数据的工具类
@interface OCEmojiPackageManager : NSObject

@property (nonatomic, strong) NSArray<OCEmojiPackage *> *allEmojiPackages;

+ (instancetype)sharedPackageManager;

/**
 * 加载所有表情包数据
 */
- (NSArray<OCEmojiPackage *>*)loadAllEmojiPackageWithID;

/**
 * 添加最近表情
 */
- (void)addFavorite:(OCEmoji *)emojiModel;

@end
