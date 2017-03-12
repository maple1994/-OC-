//
//  OCStatusViewModel.h
//  OCWeibo
//
//  Created by Maple on 16/7/23.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCStatusViewModel : NSObject

+ (instancetype)sharedStatusViewModel;

/**
 * 获取微博数据
 *
 * @param max_id     下拉刷新参数
 * @param since_id   上拉刷新参数
 * @param completion 回调
 */
- (void)loadStatusMaxId:(NSUInteger)max_id SinceId:(NSUInteger)since_id Completion:(void (^)(NSError *error, NSArray *statusArray)) completion;

/**
 * 发微博
 *
 * @param status     微博内容
 * @param image      微博配图
 * @param completion 回调
 */
- (void)sendStatus: (NSString *)status image:(UIImage *)image completion:(void (^)(NSError *error))completion;

@end
