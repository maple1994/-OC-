//
//  OCEmojiPackage.h
//  表情键盘
//
//  Created by Maple on 16/7/29.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OCEmoji;
///表情包类
@interface OCEmojiPackage : NSObject

/// 表情包文件夹名称
@property (nonatomic, copy) NSString *ID;
/// 表情包名
@property (nonatomic, copy) NSString *group_name_cn;
/// 表情模型数组
@property (nonatomic, strong) NSArray<OCEmoji *> *emoticons;
/// 模型数组分页数组
@property (nonatomic, strong) NSMutableArray<NSArray<OCEmoji *>*> *pageEmoticons;

///创建模型
+ (instancetype)emojiPackageWithID: (NSString *)ID groupName: (NSString *)group_name_cn emoticons: (NSArray<OCEmoji *> *)emoticons;

@end
