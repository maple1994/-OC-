//
//  OCHttpTool.m
//  OCWeibo
//
//  Created by Maple on 16/7/19.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCHttpTool.h"

@implementation OCHttpTool

static OCHttpTool *_instance;
+ (instancetype)sharedHttpTool {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [[self alloc] init];
    NSURL *baseUrl = [NSURL URLWithString:@"https://api.weibo.com/"];
    _instance.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    _instance.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript", @"application/json", @"text/json", @"text/plain", nil];
  });
  return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [super allocWithZone:zone];
  });
  return _instance;
}

- (id)copy {
  return _instance;
}

- (void)requestGET:(NSString *)URLString
        parameters:(id)parameters
          progress:(void (^)(NSProgress * _Nonnull))downloadProgress
           success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
           failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
  [self.manager GET:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
}

- (void)requestPOST:(NSString *)URLString
         parameters:(id)parameters
           progress:(void (^)(NSProgress * _Nonnull))downloadProgress
            success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
            failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
  [self.manager POST:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
}

- (void)requestMethod:(OCHttpToolMethod)method urlString:(nonnull NSString *)URLString
           parameters:(nullable id)parameters
             progress:(nullable void (^)(NSProgress * _Nonnull))downloadProgress
              success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
              failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure {
  switch (method) {
    case OCHttpToolMethodGET:
      [self requestGET:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
      break;
    case OCHttpToolMethodPOST:
      [self requestPOST:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
      break;
  }
}

/*
 - (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
 parameters:(nullable id)parameters
 constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
 success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
 failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
 */

- (void)uploadUrlString:(NSString *)URLString parameters:(nullable id)parameters constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
  [self.manager POST:URLString parameters:parameters constructingBodyWithBlock:block progress:nil success:success failure:failure];
}

@end
