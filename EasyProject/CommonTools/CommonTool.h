//
//  CommonTool.h
//  EasyProject
//
//  Created by ZhangZn on 2020/2/21.
//  Copyright © 2020 ZhangZn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonTools : NSObject

//获取时间戳
+(NSString*)getTimeC;

//MD5 32位加密(大写)
+ (NSString *)md5:(NSString *)str;

//字典转json格式
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

//数组转json格式
+ (NSString*)arrayToJson:(NSArray *)arr;

//写入文件
+(void)writeFile:(NSMutableDictionary *)dic toFile:(NSString *)str;

//读取文件
+(NSMutableDictionary *)readFile:(NSString *)str;

// 删除文件
+(void)removeFile:(NSString *)str;

//判断是否有网络
+(BOOL)isConnection;


//找到view中的imageView
+ (UIImageView *)findHairlineImageViewUnder:(UIView *)view;

//对字符串的每个字符进行UTF-8编码
+ (NSString *)URLUTF8EncodingString:(NSString *)decodeStr;

//对字符串进行UTF-8解码码
+ (NSString *)URLUTF8DecodingString:(NSString *)encodeStr;


@end

NS_ASSUME_NONNULL_END
