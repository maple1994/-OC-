//
//  OCEmojiCell.h
//  表情键盘
//
//  Created by Maple on 16/7/29.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <UIKit/UIKit.h>
#define maxNumberOfPage 20
#define maxNumberOfCol 7
#define maxNumberOfRow 3

@class OCEmoji;
@protocol OCEmojiCellDelegate <NSObject>

- (void)emojiCellDidClickButton:(OCEmoji *)emojiModel;

- (void)emojiCellDidClickDelete;

@end


@interface OCEmojiCell : UICollectionViewCell

///调试用
@property (nonatomic, strong) NSIndexPath *indexPath;
///模型
@property (nonatomic, strong) NSArray<OCEmoji *> *emojiModelArray;
///代理
@property (nonatomic, weak) id<OCEmojiCellDelegate> deleagte;

@end
