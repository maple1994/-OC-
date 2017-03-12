//
//  OCStatus.h
//  OCWeibo
//
//  Created by Maple on 16/7/23.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCUser.h"
///微博模型
@interface OCStatus : NSObject

/// 微博创建时间
@property (nonatomic, copy) NSString *created_at;
/// 微博ID
@property (nonatomic, assign) NSUInteger ID;
/// 微博信息内容
@property (nonatomic, copy) NSString *text;
/// url字典数组
@property (nonatomic, strong) NSArray *pic_urls;
/// 配图url数组
@property (nonatomic, strong) NSArray *pictureArray;
/// 微博来源
@property (nonatomic, copy) NSString *source;
/// 转发数
@property (nonatomic, assign) NSInteger reposts_count;
/// 评论数
@property (nonatomic, assign) NSInteger comments_count;
/// 表态数
@property (nonatomic, assign) NSInteger attitudes_count;
/// 用户模型
@property (nonatomic, strong) OCUser *user;
/// 转发微博
@property (nonatomic, strong) OCStatus *retweeted_status;
/// 行高
@property (nonatomic, assign) CGFloat rowHeight;

/**
 * 字典转模型
 */
+ (instancetype)statusWithDic:(NSDictionary *)dic;

@end
