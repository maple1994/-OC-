//
//  OCUserAccountViewModel.h
//  OCWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OCUserAccount;
///userAccount的工具类
@interface OCUserAccountViewModel : NSObject

///用户信息
@property (nonatomic, strong) OCUserAccount *account;

///用户是否为登陆状态
@property (nonatomic, assign, readonly) BOOL isLogin;

/**
 * 返回一个单例对象
 */
+ (instancetype)sharedAccountViewModel;

/**
 * 根据code值，获得accessToken并保存
 *
 * @param code 服务器返回的code
 */
//(void (^ __nullable)(BOOL finished))completion
- (void)saveAccessTokenWithCode: (NSString *)code completion:(void (^)(NSError *error)) completion;

/**
 * 加载用户信息
 */
- (void)loadUserInfoCompletion:(void (^)(NSError *error)) completion;

@end
