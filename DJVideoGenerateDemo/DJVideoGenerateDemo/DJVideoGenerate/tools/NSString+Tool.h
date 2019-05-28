//
//  NSString+Tool.h
//  DJVideoGenerateDemo
//
//  Created by Tommy on 2019/3/12.
//  Copyright © 2019年 Tommy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Tool)

/**
 *  判断字符串是否为空
 *
 *  @param string 字符串儿
 *
 *  @return 返回类型（Y／N）
 */
+ (BOOL) isBlankString:(NSString *)string;

/**
 *  获得字符长度
 *
 *  @param strTemp 字符串
 *
 *  @return 返回长度
 */
+(int)getStringCharLength:(NSString*)strTemp;

/**
 返回处理过之后的字符串(精确到日)

 @param timestamp 后台返回的时间戳(以毫秒为单位的)

 @return 处理之后的字符串
 */
+ (NSString *)dateStringFromTimeStamp:(NSString *)timestamp;

///  判断图片格式
+ (NSString *)contentTypeForImageData:(NSData *)data;

///  通过URL扩展名判断图片格式
+ (NSString *)extensionWithURL:(NSString *)url;

///  获取设备型号
+ (NSString *)iphoneType;

///  获取json格式的图片数组和textView字符串
+ (NSString *)getJSONStrWith:(NSArray *)array textViewStr:(NSString *)string;

///  获取URL内的参数并以字典类型返回
+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr;

///  获取Library内游戏文件路径
+ (NSString *)getGameFilePath;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

///  根据传入最大Size值和字体大小计算字符串所占Size
+ (CGSize)calculateStringSizeWithMaxSize:(CGSize)maxSize textFont:(CGFloat)font textString:(NSString *)string;

/**
 *  为空处理
 *
 *  @return 处理后的字符串
 */
- (NSString *)safeString;

/**
 *  是否包含表情
 *
 *  @return 判断结果
 */
- (BOOL) containEmoji;

- (NSString *)stringByTrim;

- (NSString *)md5String;

@end
