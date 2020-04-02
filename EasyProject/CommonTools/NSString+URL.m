//
//  NSString+URL.m
//  WTK
//
//  Created by ZhangZn on 2018/2/13.
//  Copyright © 2018年 Wenyu. All rights reserved.
//

#import "NSString+URL.h"
#import <Foundation/NSString.h>

@implementation NSString (URL)

- (NSString *)URLEncodedStringWithStr:(NSString *)string {
    NSString *charactersToEscape = @"!@#$^%*+,;'\"`<>()[]{}\\|";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedUrl = [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];

    return encodedUrl;
}

@end
