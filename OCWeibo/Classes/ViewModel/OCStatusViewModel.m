//
//  OCStatusViewModel.m
//  OCWeibo
//
//  Created by Maple on 16/7/23.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCStatusViewModel.h"
#import "OCStatusDAL.h"

@interface OCStatusViewModel ()
///是否在刷新中
@property (nonatomic, assign, getter=isLoadingStatus) BOOL loadingStatus;
@end

@implementation OCStatusViewModel

static OCStatusViewModel *instance;

+ (instancetype)sharedStatusViewModel {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] init];
  });
  return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [super allocWithZone:zone];
  });
  return instance;
}

- (void)sendStatus: (NSString *)status image:(UIImage *)image completion:(void (^)(NSError *error))completion {
  //https://upload.api.weibo.com/2/statuses/upload.json
  OCUserAccount *account = [OCUserAccountViewModel sharedAccountViewModel].account;
  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  parameters[@"access_token"] = account.access_token;
  parameters[@"status"] = status;
  //发带图片的微博
  if (image) {
    NSData *data = UIImagePNGRepresentation(image);
    NSString *urlString = @"https://upload.api.weibo.com/2/statuses/upload.json";
    [[OCHttpTool sharedHttpTool] uploadUrlString:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nullable formData) {
      [formData appendPartWithFileData:data name:@"pic" fileName:@"test" mimeType:@"image/png"];
    } success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
      if (completion) {
        completion(nil);
      }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      if (completion) {
        completion(error);
      }
    }];
  }else {
    //发不带图片的微博
    NSString *urlString = @"2/statuses/update.json";
    [[OCHttpTool sharedHttpTool] requestMethod:OCHttpToolMethodPOST urlString:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      if (completion) {
        completion(nil);
      }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      if (completion) {
        completion(error);
      }
    }];

  }
}

/**
 * 获取微博数据
 *
 * @param max_id     下拉刷新参数
 * @param since_id   上拉刷新参数
 * @param completion 回调
 */
- (void)loadStatusMaxId:(NSUInteger)max_id SinceId:(NSUInteger)since_id Completion:(void (^)(NSError *error, NSArray *statusArray)) completion {
  //如果正在刷新，则直接返回
  if (self.isLoadingStatus) {
    NSError *error = [NSError errorWithDomain:@"com.maple.loadstatus" code:8888 userInfo:nil];
    completion(error, nil);
  }
  self.loadingStatus = YES;
  //加载微博数据
  [[OCStatusDAL sharedStatusDAL] loadStatus:max_id SinceId:since_id Completion:^(NSError *error, NSArray *statusArray) {
    self.loadingStatus = NO;
    if (error) {
      NSLog(@"%@", error);
      return;
    }
    NSMutableArray *modelArray = [NSMutableArray array];
    //字典数组转模型
    for (NSDictionary *dic in statusArray) {
      OCStatus *status = [OCStatus statusWithDic:dic];
      [modelArray addObject:status];
    }
    //判断有没加载到数据
    if (statusArray != nil && statusArray.count > 0) {
      if (completion) {
        completion(nil, modelArray);
      }
    }else {
      if (completion) {
        completion(nil, nil);
      }
    }
  }];
  
  
}

@end










