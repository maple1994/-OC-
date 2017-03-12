//
//  OCTabBarViewController.m
//  OCWeibo
//
//  Created by Maple on 16/7/18.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCTabBarViewController.h"
#import "OCHomeTableViewController.h"
#import "OCMessageTableViewController.h"
#import "OCProfileTableViewController.h"
#import "OCDiscoveryTableViewController.h"
#import "OCNavigationViewController.h"
#import "OCTabBar.h"
#import "OCComposeViewController.h"
#import "OCOAuthViewController.h"

@interface OCTabBarViewController ()

@end

@implementation OCTabBarViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  //替换tabBar
  OCTabBar *tabBar = [[OCTabBar alloc] init];
  
  [self setValue:tabBar forKey:@"tabBar"];
  //设置回调
  tabBar.block = ^(){
    //判断是否登录
    if ([OCUserAccountViewModel sharedAccountViewModel].isLogin) {
      OCComposeViewController *composeVC = [[OCComposeViewController alloc] init];
      OCNavigationViewController *nav = [[OCNavigationViewController alloc] initWithRootViewController:composeVC];
      [self presentViewController:nav animated:YES completion:nil];
    }else {
      //没有登录则提示登录
      OCOAuthViewController *authVC = [[OCOAuthViewController alloc] init];
      OCNavigationViewController *nav = [[OCNavigationViewController alloc] initWithRootViewController:authVC];
      [self presentViewController:nav animated:YES completion:nil];
    }
  };
  //添加子控制器
  [self addChildViewController];
}

/**
 * 添加子控制器
 */
- (void)addChildViewController {
  OCHomeTableViewController *homeVC = [[OCHomeTableViewController alloc] init];
  [self setUpChildViewController:homeVC title:@"首页" image:@"tabbar_home"];
  
  OCMessageTableViewController *messageVC = [[OCMessageTableViewController alloc] init];
  [self setUpChildViewController:messageVC title:@"消息" image:@"tabbar_message_center"];
  
  OCDiscoveryTableViewController *discoveryVC = [[OCDiscoveryTableViewController alloc] init];
  [self setUpChildViewController:discoveryVC title:@"发现" image:@"tabbar_discover"];
  
  OCProfileTableViewController *profileVC = [[OCProfileTableViewController alloc] init];
  [self setUpChildViewController:profileVC title:@"我的" image:@"tabbar_profile"];
}

/**
 * 设置子控制器
 */
- (void)setUpChildViewController:(UIViewController *)controller title:(NSString *)title image:(NSString *)imageName {
  //设置标题，图标
  controller.title = title;
  controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  NSString *selectedName = [NSString stringWithFormat:@"%@_selected", imageName];
  controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  //设置选中文字颜色
  [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor orangeColor]} forState:UIControlStateSelected];
  
  //添加到tabBarController
  OCNavigationViewController *nav = [[OCNavigationViewController alloc] initWithRootViewController:controller];
  [self addChildViewController:nav];
}

@end
