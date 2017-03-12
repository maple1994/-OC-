//
//  OCTipView.h
//  OCWeibo
//
//  Created by Maple on 16/8/10.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OCEmoji;

///表情提示视图
@interface OCTipView : UIImageView

@property (nonatomic, strong) OCEmoji *emojiModel;

@end
