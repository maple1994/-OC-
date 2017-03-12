//
//  SQLManager.h
//  OC数据库操作
//
//  Created by Maple on 16/8/6.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface SQLManager : NSObject

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

///单例对象
+ (instancetype)sharedManager;

@end
