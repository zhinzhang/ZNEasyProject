//
//  UIBarButtonItem+SXCreate.h
//  UINavigation-SXFixSpace
//
//  Created by ZhangZn on 2017/9/8.
//  Copyright © 2018年 Wenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (SXCreate)

/**
 根据图片生成UIBarButtonItem
 
 @param target target对象
 @param action 响应方法
 @param image image
 @return 生成的UIBarButtonItem
 */
+(UIBarButtonItem *)itemWithTarget:(id)target
                            action:(SEL)action
                             image:(UIImage *)image
            userInteractionEnabled:(BOOL)enabled;
/**
 根据图片生成UIBarButtonItem
 
 @param target target对象
 @param action 响应方法
 @param image image
 @param imageEdgeInsets 图片偏移
 @return 生成的UIBarButtonItem
 */
+(UIBarButtonItem *)itemWithTarget:(id)target
                            action:(SEL)action
                             image:(UIImage *)image
                   imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
            userInteractionEnabled:(BOOL)enabled;

/**
 根据图片生成UIBarButtonItem

 @param target target对象
 @param action 响应方法
 @param nomalImage nomalImage
 @param higeLightedImage higeLightedImage
 @param imageEdgeInsets 图片偏移
 @return 生成的UIBarButtonItem
 */
+(UIBarButtonItem *)itemWithTarget:(id)target
                            action:(SEL)action
                        nomalImage:(UIImage *)nomalImage
                  higeLightedImage:(UIImage *)higeLightedImage
                   imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
            userInteractionEnabled:(BOOL)enabled;


/**
 根据文字生成UIBarButtonItem

 @param target target对象
 @param action 响应方法
 @param title title
 */
+(UIBarButtonItem *)itemWithTarget:(id)target
                            action:(SEL)action
                             title:(NSString *)title
            userInteractionEnabled:(BOOL)enabled;

/**
 根据文字生成UIBarButtonItem
 
 @param target target对象
 @param action 响应方法
 @param title title
 @param titleEdgeInsets 文字偏移
 @return 生成的UIBarButtonItem
 */
+(UIBarButtonItem *)itemWithTarget:(id)target
                            action:(SEL)action
                             title:(NSString *)title
                   titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
            userInteractionEnabled:(BOOL)enabled;

/**
 根据文字生成UIBarButtonItem
 
 @param target target对象
 @param action 响应方法
 @param title title
 @param font font
 @param titleColor 字体颜色
 @param highlightedColor 高亮颜色
 @param enabled 按钮是否可用
 @return 生成的UIBarButtonItem
 */
+(UIBarButtonItem *)itemWithTarget:(id)target
                            action:(SEL)action
                             title:(NSString *)title
                              font:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                  highlightedColor:(UIColor *)highlightedColor
            userInteractionEnabled:(BOOL)enabled;
/**
 根据文字生成UIBarButtonItem

 @param target target对象
 @param action 响应方法
 @param title title
 @param font font
 @param titleColor 字体颜色
 @param highlightedColor 高亮颜色
 @param titleEdgeInsets 文字偏移
 @return 生成的UIBarButtonItem
 */
+(UIBarButtonItem *)itemWithTarget:(id)target
                            action:(SEL)action
                             title:(NSString *)title
                              font:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                  highlightedColor:(UIColor *)highlightedColor
                   titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
            userInteractionEnabled:(BOOL)enabled;


/**
 用作修正位置的UIBarButtonItem

 @param width 修正宽度
 @return 修正位置的UIBarButtonItem
 */
+(UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width;

@end
