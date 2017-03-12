//
//  OCUser.h
//  OCWeibo
//
//  Created by Maple on 16/7/23.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <Foundation/Foundation.h>

///用户信息模型
@interface OCUser : NSObject

/// 用户UID
@property (nonatomic, copy) NSString *UID;
/// 用户昵称
@property (nonatomic, copy) NSString *screen_name;
/// 用户头像地址
@property (nonatomic, copy) NSString *profile_image_url;
/// verified_type 没有认证:-1   认证用户:0  企业认证:2,3,5  达人:220
@property (nonatomic, assign) NSInteger verified_type;
/// 会员等级
@property (nonatomic, assign) NSInteger mbrank;
/// 会员图片
@property (nonatomic, strong) UIImage *rangImage;
/// 认证图片
@property (nonatomic, strong) UIImage *verfiyImage;


/**
 * 字典转模型
 */
+ (instancetype)userWithDic: (NSDictionary *)dic;

@end
