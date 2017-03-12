//
//  OCUserAccount.h
//  OCWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <Foundation/Foundation.h>

///用户账号模型
@interface OCUserAccount : NSObject<NSCoding>
///获取数据的唯一凭证
@property (nonatomic, copy) NSString *access_token;
///失效时间
@property (nonatomic, assign) NSTimeInterval expires_in;
///用户uid
@property (nonatomic, copy) NSString *uid;
///失效日期
@property (nonatomic, strong) NSDate *expires_date;
///用户名
@property (nonatomic, copy) NSString *screen_name;
///用户头像
@property (nonatomic, copy) NSString *avatar_large;

/**
 * 根据字典创建模型
 */
+ (instancetype)userAccountWithDic: (NSDictionary *)dic;

@end
