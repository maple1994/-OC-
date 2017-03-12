//
//  OCUser.m
//  OCWeibo
//
//  Created by Maple on 16/7/23.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCUser.h"

@implementation OCUser

+ (instancetype)userWithDic: (NSDictionary *)dic {
  OCUser *user = [[OCUser alloc] init];
  [user setValuesForKeysWithDictionary:dic];
  return user;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

- (void)setValue:(id)value forKey:(NSString *)key {
  if ([key isEqualToString:@"id"]) {
    self.UID = value;
  }else {
    [super setValue:value forKey:key];
  }
}

- (NSString *)description
{
  NSArray *keys = @[@"UID", @"screen_name", @"profile_image_url", @"verified_type", @"mbrank"];
  
  return [NSString stringWithFormat:@"用户模型:%@", [self dictionaryWithValuesForKeys:keys]];
}

#pragma makr 重写set方法
- (void)setMbrank:(NSInteger)mbrank {
  _mbrank = mbrank;
  NSString *levelString = [NSString stringWithFormat:@"common_icon_membership_level%zd", mbrank];
  self.rangImage = [UIImage imageNamed:levelString];
}

- (void)setVerified_type:(NSInteger)verified_type {
  _verified_type = verified_type;
  UIImage *image = nil;
  if (verified_type == 0) {
    image = [UIImage imageNamed:@"avatar_vip"];
  }else if(verified_type == 2 || verified_type == 3 || verified_type == 5){
    image = [UIImage imageNamed:@"avatar_enterprise_vip"];
  }else if(verified_type == 220) {
    image = [UIImage imageNamed:@"avatar_grassroot"];
  }else {
    image = nil;
  }
  self.verfiyImage = image;
  
}




@end
