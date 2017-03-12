//
//  AppDelegate.h
//  OCWeibo
//
//  Created by Maple on 16/7/18.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 * 更换根控制器
 */
+ (void)changeRootViewController: (UIViewController *)controller;
@end

