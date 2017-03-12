//
//  NSDate+Extension.h
//  OCWeibo
//
//  Created by Maple on 16/7/27.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 * 传入新浪时间字符串，转化为NSDate格式的数据
 */
+ (instancetype)dateFromSinaString: (NSString *)sinaString;

/// 返回新浪时间表现格式
///     -   刚刚(一分钟内)
///     -   X分钟前(一小时内)
///     -   X小时前(当天)
///     -   昨天 HH:mm(昨天)
///     -   MM-dd HH:mm(一年内)
///     -   yyyy-MM-dd HH:mm(更早期)
- (NSString *)sinaDateDescription;

@end
