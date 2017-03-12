//
//  AppDelegate.m
//  OCWeibo
//
//  Created by Maple on 16/7/18.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "AppDelegate.h"
#import "OCTabBarViewController.h"
#import "OCWelcomeViewController.h"
#import "OCNewFeatureViewController.h"
#import <SVProgressHUD.h>
#import "OCStatusDAL.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  //设置蒙版消失时间为2s
  [SVProgressHUD setMinimumDismissTimeInterval:2];
  // 创建窗口
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  //设置根控制器
  self.window.rootViewController = [self selectRootViewController];
  //显示
  [self.window makeKeyAndVisible];
  return YES;
}

/**
 * 更换根控制器
 */
+ (void)changeRootViewController: (UIViewController *)controller {
  AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  delegate.window.rootViewController = controller;
}

- (UIViewController *)selectRootViewController {
  //判断是否登录
  BOOL isLogin = [OCUserAccountViewModel sharedAccountViewModel].isLogin;
  if (isLogin) {
    //登录
    if ([self isNewVersion]) {
      //新版本
      return [[OCNewFeatureViewController alloc] init];
    }else {
      //不是新版本
      return  [[OCWelcomeViewController alloc] init];
    }
  }else {
    //没有登录
    return [[OCTabBarViewController alloc] init];
  }
}

/**
 * 判断是否为新版本
 */
- (BOOL)isNewVersion {
  //当前版本号
  NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
  NSString *key = @"version";
  NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
  
  //判断
  BOOL isNew = ![currentVersion isEqualToString:lastVersion];
  if (isNew) {
    //保存
    [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
  }
  return isNew;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [[OCStatusDAL sharedStatusDAL] clearChache];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
