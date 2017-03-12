//
//  OCHttpTool.h
//  OCWeibo
//
//  Created by Maple on 16/7/19.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef enum : NSUInteger {
  OCHttpToolMethodGET,
  OCHttpToolMethodPOST,
} OCHttpToolMethod;

@interface OCHttpTool : NSObject
///网络请求管理者
@property (nonatomic, strong, nullable) AFHTTPSessionManager *manager;
/**
 * 创建单例对象
 *
 * @return 返回单例对象
 */
+ (nonnull instancetype)sharedHttpTool;

/**
 * 网络请求封装
 *
 * @param method           请求方式
 * @param URLString        请求url
 * @param parameters       请求参数
 * @param downloadProgress 进度回调
 * @param success          成功回调
 * @param failure          失败回调 
 */
- (void)requestMethod:(OCHttpToolMethod)method urlString:(nonnull NSString *)URLString
           parameters:(nullable id)parameters
             progress:(nullable void (^)(NSProgress * _Nonnull))downloadProgress
              success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
              failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

- (void)uploadUrlString:(nonnull NSString *)URLString parameters:(nullable id)parameters constructingBodyWithBlock:(nullable void (^)(_Nullable id <AFMultipartFormData> formData))block success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *_Nonnull error))failure;



@end
