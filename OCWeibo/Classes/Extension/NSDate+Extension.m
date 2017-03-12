//
//  NSDate+Extension.m
//  OCWeibo
//
//  Created by Maple on 16/7/27.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (instancetype)dateFromSinaString: (NSString *)sinaString {
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  //如果是真机
  df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"EN"];
  df.dateFormat = @"EEE MMM dd HH:mm:ss zzz yyyy";
  return [df dateFromString:sinaString];
}

/// 返回新浪时间表现格式
///     -   刚刚(一分钟内)
///     -   X分钟前(一小时内)
///     -   X小时前(当天)
///     -   昨天 HH:mm(昨天)
///     -   MM-dd HH:mm(一年内)
///     -   yyyy-MM-dd HH:mm(更早期)
- (NSString *)sinaDateDescription {
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"EN"];
  //今天
  if ([calendar isDateInToday:self]) {
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self];
    if (delta < 60) {
      return @"刚刚";
    }else if (delta < 60 * 60){
      return [NSString stringWithFormat:@"%zd分钟前", (NSInteger)delta / 60];
    }else {
      return [NSString stringWithFormat:@"%zd小时前", (NSInteger)delta / 60 / 60];
    }
  }
  if([calendar isDateInYesterday:self]){
    //昨天
    formatter.dateFormat = @"昨天 HH:mm";
    return [formatter stringFromDate:self];
  }
  
  //一年内
  if ([calendar compareDate:self toDate:[NSDate date] toUnitGranularity:NSCalendarUnitYear] == NSOrderedSame) {
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter stringFromDate:self];
  }else {
    //更早期
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter stringFromDate:self];
  }
  return @"";
}

@end
