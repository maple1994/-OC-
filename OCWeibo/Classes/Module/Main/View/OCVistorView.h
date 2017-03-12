//
//  OCVistorView.h
//  OCWeibo
//
//  Created by Maple on 16/7/18.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VistorViewDelegate <NSObject>

- (void)vistorViewDidLogin;
- (void)vistorViewDidRegister;
@end

@interface OCVistorView : UIView

///代理
@property (nonatomic, weak) id<VistorViewDelegate> delegate;
/**
 * 开始轮子旋转动画
 */
- (void)startAnimation;

/**
 * 设置访客视图图片和标题
 *
 * @param imageName 图片名
 * @param title     标题
 */
- (void)setUpContent:(NSString *)imageName title:(NSString *)title;
@end
