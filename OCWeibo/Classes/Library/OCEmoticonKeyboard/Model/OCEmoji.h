//
//  OCEmoji.h
//  表情键盘
//
//  Created by Maple on 16/7/29.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <Foundation/Foundation.h>

///表情模型
@interface OCEmoji : NSObject<NSCoding>
///文件夹名
@property (nonatomic, copy) NSString *ID;
/// emoji 16进制形式
@property (nonatomic, copy) NSString *code;
/// 表情名称
@property (nonatomic, copy) NSString *chs;
/// 图片名称
@property (nonatomic, copy) NSString *png;
/// emoji 表情
@property (nonatomic, copy) NSString *emoji;
/// 图片全路径
@property (nonatomic, copy) NSString *fullPathPNG;

///字典转模型
+ (instancetype)emojiWithDic: (NSDictionary *)dic ID: (NSString *)ID;

@end
