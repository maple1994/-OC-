//
//  OCNewFeatureCell.h
//  OCWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCNewFeatureCell : UICollectionViewCell

///显示的背景图片
@property (nonatomic, strong) UIImage *image;

/**
 * 显示按钮
 */
- (void)showButton:(BOOL) isShow;

@end
