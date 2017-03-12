//
//  OCUserAccountViewModel.m
//  OCWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCUserAccountViewModel.h"
#import "OCUserAccount.h"
#import "OCWelcomeViewController.h"
@implementation OCUserAccountViewModel

static OCUserAccountViewModel *instance;
+ (instancetype)sharedAccountViewModel {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] init];
    });
  return instance;
}

- (instancetype)init {
  if (self = [super init]) {
    self.account = [self loadUserAccount];
  }
  return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
     instance = [super allocWithZone:zone];
  });
  return instance;
}

/**
 * 根据code值，获得accessToken并保存
 *
 * @param code 服务器返回的code
 */
- (void)saveAccessTokenWithCode: (NSString *)code completion:(void (^)(NSError *error)) completion {
  NSString *urlString = @"https://api.weibo.com/oauth2/access_token";
  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  parameters[@"client_id"] = client_id;
  parameters[@"client_secret"] = appSecret;
  parameters[@"grant_type"] = @"authorization_code";
  parameters[@"code"] = code;
  parameters[@"redirect_uri"] = redirect_uri;
  //发送post请求，获得accessToken
  [[OCHttpTool sharedHttpTool] requestMethod:OCHttpToolMethodPOST urlString:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSLog(@"%@", responseObject);
    self.account = [OCUserAccount userAccountWithDic:responseObject];
    NSLog(@"%@", self.account);
    //保存到沙盒中
    [self archiverAccount];
        if (completion) {
      //成功回调
      [AppDelegate changeRootViewController:[[OCWelcomeViewController alloc] init]];
      completion(nil);
    }
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    if (error) {
      if (completion) {
        //失败回调
        completion(error);
      }
      NSLog(@"%@", error);
    }
  }];
}

/**
 * 加载用户信息
 */
- (void)loadUserInfoCompletion:(void (^)(NSError *error)) completion {
  NSString *urlString = @"https://api.weibo.com/2/users/show.json";
  //判断请求参数是否为空
  if (!self.account.access_token || !self.account.uid) {
    NSLog(@"access_token或者uid为空");
    return;
  }
  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  parameters[@"access_token"] = self.account.access_token;
  parameters[@"uid"] = self.account.uid;
  [[OCHttpTool sharedHttpTool] requestMethod:OCHttpToolMethodGET urlString:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
    //保存用户信息
    self.account.avatar_large = responseObject[@"avatar_large"];
    self.account.screen_name = responseObject[@"screen_name"];
    //归档
    [self archiverAccount];
    if(completion) {
      completion(nil);
    }
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    if(completion) {
      completion(error);
    }
    NSLog(@"error");
  }];
}


/**
 * 将账户信息归档
 */
- (void)archiverAccount {
  [NSKeyedArchiver archiveRootObject:self.account toFile:[self getUserAccountFilePath]];
}

/**
 * 获得账户存储沙盒路径
 */
- (NSString *)getUserAccountFilePath {
  NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  return [docPath stringByAppendingPathComponent:@"account.plist"];
}

/**
 * 从沙盒路径中加载用户信息
 */
- (OCUserAccount *)loadUserAccount {
  OCUserAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getUserAccountFilePath]];
  if ([account.expires_date compare:[NSDate date]] == NSOrderedDescending) {
    return account;
  }else {
    return nil;
  }
}

#pragma mark - 重写getter，setter方法
- (BOOL)isLogin {
  return (self.account != nil);
}


@end
