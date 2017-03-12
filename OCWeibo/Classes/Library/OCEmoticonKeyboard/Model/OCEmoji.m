//
//  OCEmoji.m
//  表情键盘
//
//  Created by Maple on 16/7/29.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "OCEmoji.h"
#import "NSString+Emoji.h"
#define mainBundlePath [[NSBundle mainBundle] pathForResource:@"Emoticons.bundle" ofType:nil]
@implementation OCEmoji

- (void)setCode:(NSString *)code {
  _code = code;
  self.emoji = [code emoji];
}

- (void)setPng:(NSString *)png {
  _png = png;
}

///字典转模型
+ (instancetype)emojiWithDic: (NSDictionary *)dic ID: (NSString *)ID {
  OCEmoji *emoji = [[self alloc] initWithDic:dic];
  emoji.ID = ID;
  emoji.fullPathPNG = [NSString stringWithFormat:@"%@/%@/%@", mainBundlePath, ID, emoji.png];
  return emoji;
}

- (void)setValue:(id)value forKey:(NSString *)key {
//  if ([key isEqualToString:@"png"]) {
//    NSLog(@"%@", value);
//  }
  [super setValue:value forKey:key];
}

///字典转模型
- (instancetype)initWithDic:(NSDictionary *)dic {
  if (self == [super init]) {
    [self setValuesForKeysWithDictionary:dic];
  }
  return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

///归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.ID forKey:@"ID"];
  [aCoder encodeObject:self.code forKey:@"code"];
  [aCoder encodeObject:self.chs forKey:@"chs"];
  [aCoder encodeObject:self.png forKey:@"png"];
  [aCoder encodeObject:self.emoji forKey:@"emoji"];
}

///解档
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
  self.ID = [aDecoder decodeObjectForKey:@"ID"];
  self.code = [aDecoder decodeObjectForKey:@"code"];
  self.chs = [aDecoder decodeObjectForKey:@"chs"];
  self.png = [aDecoder decodeObjectForKey:@"png"];
  self.emoji = [aDecoder decodeObjectForKey:@"emoji"];
  self.fullPathPNG = [NSString stringWithFormat:@"%@/%@/%@", mainBundlePath, self.ID, self.png];
  return self;
}



@end
