//
//  OCStatusDAL.m
//  OCWeibo
//
//  Created by Maple on 16/8/7.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCStatusDAL.h"
#import "SQLManager.h"

@implementation OCStatusDAL

///清除缓存
- (void)clearChache {
  //清除缓存时间，一般设置为7天，这里测试使用60s//60 * 60 * 24 * 7;
  NSTimeInterval clearTime = 60;
  NSDate *clearDate = [NSDate dateWithTimeIntervalSinceNow:-clearTime];
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  //2016-08-07 10:24:53
  df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
  NSString *clearStr = [df stringFromDate:clearDate];
  //删除缓存
  [[SQLManager sharedManager].dbQueue inDatabase:^(FMDatabase *db) {
    NSString *sql = [NSString stringWithFormat:@"delete from T_Status where createTime < '%@'", clearStr];
    @try {
      [db executeUpdate:sql];
    } @catch (NSException *exception) {
      NSLog(@"%@", exception);
    }
  }];
}

///加载微博数据
- (void)loadStatus:(NSUInteger)max_id SinceId:(NSUInteger)since_id Completion:(void (^)(NSError *error, NSArray *statusArray)) completion {
  //1.判断本地有没有数据
  [self loadChacheMaxId:max_id SinceId:since_id Completion:^(NSError *error, NSArray *statusArray) {
    if (error) {
      NSLog(@"%@", error);
      return;
    }
    if (statusArray != nil && statusArray.count > 0) {
      //2.有则直接返回本地数据
      if (completion) {
        NSLog(@"从本地加载数据");
        completion(nil, statusArray);
        return;
      }
    }
    
    //3.没有从网络获取数据
    OCUserAccount *account = [OCUserAccountViewModel sharedAccountViewModel].account;
    NSString *urlString = @"2/statuses/home_timeline.json";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.access_token;
    parameters[@"count"] = [NSNumber numberWithInteger:2];
    //添加上拉刷新参数
    if (max_id > 0) {
      parameters[@"max_id"] = [NSNumber numberWithInteger:max_id - 1];
    }
    //添加下拉刷新参数
    if (since_id > 0) {
      parameters[@"since_id"] = [NSNumber numberWithInteger:since_id];
    }
    [[OCHttpTool sharedHttpTool] requestMethod:OCHttpToolMethodGET urlString:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
      NSLog(@"从网络获取数据");
      //取出status字典数组
      NSArray *statues = responseObject[@"statuses"];
      //4.将获取的数据缓存到本地
      [self saveStatus:statues];
      
      //5.返回获取到的数据
      if (completion) {
        completion(nil, statues);
      }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      if (error) {
        NSLog(@"error");
        //5.返回获取到的数据
        if (completion) {
          completion(error, nil);
        }
      }
    }];
  }];
  

}

///加载本地数据
- (void)loadChacheMaxId:(NSUInteger)max_id SinceId:(NSUInteger)since_id Completion:(void (^)(NSError *error, NSArray *statusArray)) loadCompletion {
  //获得userId
  NSString *userId = [OCUserAccountViewModel sharedAccountViewModel].account.uid;
  NSAssert(userId != nil, @"userID为空，加载失败");
  
  NSMutableString *sql = [NSMutableString stringWithFormat:@"select statusId, status, userId from T_Status where userId = %@\n", userId];
  if (max_id > 0) {
    //上拉刷新，加载比max_id小的微博
    [sql appendFormat:@"and statusId < %zd\n", max_id];
  }
  if (since_id > 0) {
    //下拉刷新，加载比since_id大的微博
    [sql appendFormat:@"and statusId > %zd\n", since_id];
  }
  //排序
  [sql appendFormat:@"order by status desc limit 0,2"];
  
  //从数据库查询数据
  [[SQLManager sharedManager].dbQueue inDatabase:^(FMDatabase *db) {
    @try {
      FMResultSet *result = [db executeQuery:sql];
      //微博字典数组
      NSMutableArray *statusArray = [NSMutableArray array];
      while (result.next) {
        //取出微博数据，并转换成json格式  NSString -> data -> json
        NSString *status = [result stringForColumn:@"status"];
        NSData *data = [status dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [statusArray addObject:json];
      }
      if (loadCompletion) {
        loadCompletion(nil, statusArray);
      }
    } @catch (NSException *exception) {
      NSLog(@"%@", exception);
      NSError *error = [NSError errorWithDomain:exception.reason code:6666 userInfo:nil];
      loadCompletion(error, nil);
    } 
  }];
}

///保存微博数据到本地
- (void)saveStatus:(NSArray *)statusArray {
  //获得userId
  NSString *userId = [OCUserAccountViewModel sharedAccountViewModel].account.uid;
  NSAssert(userId != nil, @"userID为空，存储失败");
  
  [[SQLManager sharedManager].dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    //遍历数组，保存
    for (NSDictionary *dic in statusArray) {
      //取出微博id
      NSUInteger statusID = [dic[@"id"] integerValue];
      //将整个微博json格式存储起来  dic -> data -> NSString
      NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
      NSString *statusText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
      //"INSERT INTO T_Status (status_id, status, user_id) VALUES(?, ?, \(userID!))"
      //存入数据库
      NSString *sql = @"insert into T_Status (statusId, status, userId) values(?, ?, ?)";
      NSError *error = nil;
      [db executeUpdate:sql values:@[@(statusID), statusText, userId] error:&error];
      if (error) {
        NSLog(@"%@", error);
        *rollback = YES;
      }
    }
    NSLog(@"保存了%zd条数据", statusArray.count);
  }];
}



#pragma mark - 单例的实现
static id instance = nil;
+ (instancetype)sharedStatusDAL {
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




@end
