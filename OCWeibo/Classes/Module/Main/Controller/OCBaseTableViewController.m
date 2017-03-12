//
//  OCBaseTableViewController.m
//  OCWeibo
//
//  Created by Maple on 16/7/18.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCBaseTableViewController.h"
#import "OCVistorView.h"
#import "OCHomeTableViewController.h"
#import "OCMessageTableViewController.h"
#import "OCProfileTableViewController.h"
#import "OCDiscoveryTableViewController.h"
#import "OCOAuthViewController.h"
#import "OCNavigationViewController.h"

@interface OCBaseTableViewController ()<VistorViewDelegate>
///是否为登录状态
@property (nonatomic, assign) BOOL isLogin;
@end

@implementation OCBaseTableViewController

- (void)loadView {
  self.isLogin = [OCUserAccountViewModel sharedAccountViewModel].isLogin;
  if (!self.isLogin) {
    OCVistorView *view = [[OCVistorView alloc] init];
    self.view = view;
    view.delegate = self;
    //根据不同的控制器，显示不同的icon和标题
    if ([self isKindOfClass:[OCHomeTableViewController class]]) {
      [view startAnimation];
    }else if([self isKindOfClass:[OCMessageTableViewController class]]) {
      [view setUpContent:@"visitordiscover_image_message" title:@"登录后，别人评论你的微博，发给你的消息，都会在这里收到通知"];
    }else if([self isKindOfClass:[OCDiscoveryTableViewController class]]) {
      [view setUpContent:@"visitordiscover_image_message" title:@"登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过"];
    }else if([self isKindOfClass:[OCProfileTableViewController class]]) {
      [view setUpContent:@"visitordiscover_image_profile" title:@"登录后，你的微博、相册、个人资料会显示在这里，展示给别人"];
    }
    //设置登录和注册item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(vistorViewDidRegister)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(vistorViewDidLogin)];
  }else {
    [super loadView];
  }
}

#pragma mark visitorView代理方法
- (void)vistorViewDidRegister {
  NSLog(@"%s", __func__);
}

- (void)vistorViewDidLogin {
  OCOAuthViewController *vc = [[OCOAuthViewController alloc] init];
  OCNavigationViewController *nav = [[OCNavigationViewController alloc] initWithRootViewController:vc];
  [self presentViewController:nav animated:YES completion:nil];
}




@end
