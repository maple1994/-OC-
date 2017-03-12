//
//  OCNavigationViewController.m
//  OCWeibo
//
//  Created by Maple on 16/7/18.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCNavigationViewController.h"

@interface OCNavigationViewController ()

@end

@implementation OCNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)initialize {
  UINavigationBar *bar = [UINavigationBar appearance];
  bar.tintColor = [UIColor orangeColor];
}

@end
