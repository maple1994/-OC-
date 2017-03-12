//
//  OCStatusDAL.h
//  OCWeibo
//
//  Created by Maple on 16/8/7.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

///微博数据接口层
@interface OCStatusDAL : NSObject

+ (instancetype)sharedStatusDAL;

///清除缓存
- (void)clearChache;

/**
 * 加载微博数据，本地有则从本地获取，否则从获取获取
 *
 * @param max_id     上拉刷新参数
 * @param since_id   下拉刷新参数
 * @param completion 回调
 */
- (void)loadStatus:(NSUInteger)max_id SinceId:(NSUInteger)since_id Completion:(void (^)(NSError *error, NSArray *statusArray)) completion;

@end
