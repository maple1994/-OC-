//
//  OCKeyboardToolbar.h
//  表情键盘
//
//  Created by Maple on 16/7/29.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义按钮枚举
typedef enum : NSUInteger {
  OCKeyboardToolbarTypeRecent = 0,  //最近
  OCKeyboardToolbarTypeDefault = 1, //默认
  OCKeyboardToolbarTypeEmoji = 2,   //emoji
  OCKeyboardToolbarTypeLXH = 3      //浪小花
} OCKeyboardToolbarType;

@class OCKeyboardToolbar;
//定义协议
@protocol OCKeyboardToolbarDelegate <NSObject>

- (void)keyboardToolbar:(OCKeyboardToolbar *)toolbar didSelected:(OCKeyboardToolbarType)type;
@end

@interface OCKeyboardToolbar : UIView
///代理
@property (nonatomic, weak)id<OCKeyboardToolbarDelegate> delegate;

///根据传入下标值，选中标题
- (void)selectTitleWithSeciont:(NSInteger) section;

@end
