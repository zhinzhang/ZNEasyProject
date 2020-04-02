//
//  CommonTool.m
//  EasyProject
//
//  Created by ZhangZn on 2020/2/21.
//  Copyright © 2020 ZhangZn. All rights reserved.
//

#import "CommonTool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation CommonTools

//获取时间戳
+(NSString*)getTimeC{
    //    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    //    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *date = [NSDate date];
//    NSTimeInterval time = [date timeIntervalSince1970];

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}

//MD5 32位加密(大写)
+ (NSString *)md5:(NSString *)str {
    if (!str) {
        return @"";
    }
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}

//字典转json格式
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//数组转json格式
+ (NSString*)arrayToJson:(NSArray *)arr
{
    NSError *parseError = nil;
    if (!arr) {
        arr = [[NSArray alloc]init];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:0 error:&parseError];
    //NSJSONWritingPrettyPrinted
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//写入文件
+(void)writeFile:(NSMutableDictionary *)dic toFile:(NSString *)str{
    @try {
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *plistPath = [documentPath stringByAppendingPathComponent: str];
        [dic writeToFile:plistPath atomically:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

//读取文件
+(NSMutableDictionary *)readFile:(NSString *)str{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    NSString *plistPath=[path stringByAppendingPathComponent: str];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]initWithDictionary:dic];
    return  data;
}

// 删除文件
+(void)removeFile:(NSString *)str{
    
    NSFileManager *fileMger = [NSFileManager defaultManager];
    NSString *removePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:str];
    [fileMger removeItemAtPath:removePath error:nil];
    
}


//判断是否有网络
+(BOOL)isConnection {
    //判断跟指定网址是否联通
//    OSSReachability *reach = [OSSReachability reachabilityWithHostName:@"https://www.baidu.com"];
//    OSSNetworkStatus status = reach.currentReachabilityStatus;
//    BOOL isExistenceNetwork;
//    if (status == OSSNotReachable) {
//        isExistenceNetwork = NO;
//    }
//    else {
//        isExistenceNetwork = YES;
//    }
//
//    if (SystemVersion >= 9.000) {
//        return isExistenceNetwork;
//    }
    return YES;
}

+ (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

//对字符串的每个字符进行UTF-8编码
+ (NSString *)URLUTF8EncodingString:(NSString *)decodeStr {
    if (decodeStr.length == 0) {
        return decodeStr;
    }
    NSCharacterSet *characterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeStr = [decodeStr stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
    return encodeStr;
}

//对字符串进行UTF-8解码码
+ (NSString *)URLUTF8DecodingString:(NSString *)encodeStr {
    if (encodeStr.length == 0) {
        return encodeStr;
    }
    NSString *decodedStr = [encodeStr stringByRemovingPercentEncoding];
    
    return decodedStr;
}

@end

