//
//  OCTabBar.h
//  OCWeibo
//
//  Created by Maple on 16/7/18.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCTabBar : UITabBar

///block  void (^)()
@property (nonatomic, copy) void (^block)();

@end
