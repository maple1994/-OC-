//
//  SQLManager.m
//  OC数据库操作
//
//  Created by Maple on 16/8/6.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "SQLManager.h"

@implementation SQLManager

static id instance;
+ (instancetype)sharedManager {
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

- (instancetype)init {
  if (self = [super init]) {
    //创建数据库队列
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"fmdb.db"];
    self.dbQueue = [[FMDatabaseQueue alloc] initWithPath:path];
    //创建数据库
    [self createTableWithName:@"T_Status"];
  }
  return self;
}

- (void)createTableWithName:(NSString *)tableName {
  NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (statusId integer primary key, status text, userId integer, createTime TEXT DEFAULT (datetime('now', 'localtime')));", tableName];
  [self.dbQueue inDatabase:^(FMDatabase *db) {
    [db executeUpdate:sql];
  }];
  
}

@end
