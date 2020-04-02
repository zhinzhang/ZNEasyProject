//
//  UIImage+QRCode.h
//  WTK
//
//  Created by ZhangZn on 2017/12/5.
//  Copyright © 2017年 Wenyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (QRCode)

+ (UIImage *)qrImageByContent:(NSString *)content;

+ (UIImage *)qrImageWithContent:(NSString *)content size:(CGFloat)size logo:(UIImage *)logo;

//pre
+ (UIImage *)qrImageWithContent:(NSString *)content size:(CGFloat)size;
/**
 *   色值 0~255
 *
 */
+ (UIImage *)qrImageWithContent:(NSString *)content size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;


+ (UIImage *)qrImageWithContent:(NSString *)content logo:(UIImage *)logo size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

//生成条形码
+ (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height;

@end
