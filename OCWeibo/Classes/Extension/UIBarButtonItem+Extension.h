//
//  UIBarButtonItem+Extension.h
//  OCWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (instancetype)itemWithImage: (NSString *)image;

+ (instancetype)itemWithImgae:(NSString *)image target:(id)target action:(SEL)action;

@end
