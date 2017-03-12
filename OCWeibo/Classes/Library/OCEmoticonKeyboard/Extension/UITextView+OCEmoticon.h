//
//  UITextView+OCEmoticon.h
//  表情键盘
//
//  Created by Maple on 16/7/31.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OCEmoji;
@interface UITextView (OCEmoticon)

/**
 * 返回网络传输的字符串
 */
- (NSString *)resultString;

/**
 * 插入表情
 *
 * @param emojiModel 表情模型
 */
- (void)insertEmoticon:(OCEmoji *)emojiModel;

@end
