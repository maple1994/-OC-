//
//  UITextView+OCEmoticon.m
//  表情键盘
//
//  Created by Maple on 16/7/31.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "UITextView+OCEmoticon.h"
#import "OCTextAtttachment.h"
#import "OCEmoji.h"

@implementation UITextView (OCEmoticon)

/**
 * 返回网络传输的字符串
 */
- (NSString *)resultString {
  //拼接成网络传输的字符
  NSMutableString *resultString = [NSMutableString string];
  [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
    //如果属性存在"NSAttachment"key，说明是图片表情
    if (attrs[@"NSAttachment"]) {
      //图片表情
      OCTextAtttachment *attach = (OCTextAtttachment *)attrs[@"NSAttachment"];
      [resultString appendString:attach.chs];
    }else{
      //emoji表情或其他字符
      NSString *otherString = [self.attributedText.string substringWithRange:range];
      [resultString appendString:otherString];
    }
  }];
  return resultString;
}

/**
 * 插入表情
 *
 * @param emojiModel 表情模型
 */
- (void)insertEmoticon:(OCEmoji *)emojiModel {
  //插入emoji表情
  if (emojiModel.emoji) {
    [self insertText:emojiModel.emoji];
  }
  
  //插入图片表情
  if (emojiModel.png) {
    //创建附件
    OCTextAtttachment *attach = [[OCTextAtttachment alloc] init];
    attach.image = [UIImage imageNamed:emojiModel.fullPathPNG];
    attach.chs = emojiModel.chs;
    CGFloat imageWH = self.font.lineHeight;
    attach.bounds = CGRectMake(0, -4, imageWH, imageWH);
    //附件必须借助富文本才能显示
    NSAttributedString *attr = [NSAttributedString attributedStringWithAttachment:attach];
    //添加font属性
    NSMutableAttributedString *attrM = [[NSMutableAttributedString alloc] initWithAttributedString:attr];
    [attrM addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attr.length)];
    
    //取出当前文本
    NSAttributedString *currentString = self.attributedText;
    NSMutableAttributedString *currentStringM = [[NSMutableAttributedString alloc] initWithAttributedString:currentString];
    //找到光标的位置
    NSRange currentRange = self.selectedRange;
    //插入表情
    [currentStringM replaceCharactersInRange:NSMakeRange(currentRange.location, 0) withAttributedString:attrM];
    
    self.attributedText = currentStringM;
    //设置光标的位置
    self.selectedRange = NSMakeRange(currentRange.location + 1, 0);
  }
  //自己发送文字改变的通知
  [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
  [self.delegate textViewDidChange:self];
  
}

@end
