//
//  OCUserAccount.m
//  OCWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCUserAccount.h"

@implementation OCUserAccount

/**
 * 根据字典创建模型
 */
+ (instancetype)userAccountWithDic: (NSDictionary *)dic {
  OCUserAccount *account = [[self alloc] init];
  [account setValuesForKeysWithDictionary:dic];
  return account;
}

//如果不实现这个方法会报错
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  NSLog(@"%@", key);
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@--%lf--%@--%@--%@---%@", self.access_token, self.expires_in, self.uid, self.expires_date, self.screen_name, self.avatar_large];
}
#pragma mark getter和setter
- (void)setExpires_in:(NSTimeInterval)expires_in {
  _expires_in = expires_in;
  self.expires_date = [NSDate dateWithTimeIntervalSinceNow:expires_in];
}

#pragma mark 归档接档
- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.access_token forKey:@"access_token"];
  [aCoder encodeObject:self.uid forKey:@"uid"];
  [aCoder encodeObject:self.expires_date forKey:@"expires_date"];
  [aCoder encodeDouble:self.expires_in forKey:@"expires_in"];
  [aCoder encodeObject:self.avatar_large forKey:@"avatar_large"];
  [aCoder encodeObject:self.screen_name forKey:@"screen_name"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
  self.uid = [aDecoder decodeObjectForKey:@"uid"];
  self.expires_date = [aDecoder decodeObjectForKey:@"expires_date"];
  self.expires_in = [aDecoder decodeDoubleForKey:@"expires_in"];
  self.avatar_large = [aDecoder decodeObjectForKey:@"avatar_large"];
  self.screen_name = [aDecoder decodeObjectForKey:@"screen_name"];
  return self;
}

@end
