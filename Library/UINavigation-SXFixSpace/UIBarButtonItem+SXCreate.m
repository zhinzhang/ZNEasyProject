//
//  UIBarButtonItem+SXCreate.m
//  UINavigation-SXFixSpace
//
//  Created by ZhangZn on 2017/9/8.
//  Copyright © 2018年 Wenyu. All rights reserved.
//

#import "UIBarButtonItem+SXCreate.h"

@implementation UIBarButtonItem (SXCreate)

+(UIBarButtonItem *)itemWithTarget:(id)target
                            action:(SEL)action
                             image:(UIImage *)image
            userInteractionEnabled:(BOOL)enabled{
    return [self itemWithTarget:target
                         action:action
                     nomalImage:image
               higeLightedImage:nil
                imageEdgeInsets:UIEdgeInsetsZero
         userInteractionEnabled:enabled];
}

+(UIBarButtonItem *)itemWithTarget:(id)target
                            action:(SEL)action
                             image:(UIImage *)image
                   imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
            userInteractionEnabled:(BOOL)enabled{
    return [self itemWithTarget:target
                         action:action
                     nomalImage:image
               higeLightedImage:nil
                imageEdgeInsets:imageEdgeInsets
         userInteractionEnabled:enabled];
}

+(UIBarButtonItem *)itemWithTarget:(id)target
                            action:(SEL)action
                        nomalImage:(UIImage *)nomalImage
                  higeLightedImage:(UIImage *)higeLightedImage
                   imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
            userInteractionEnabled:(BOOL)enabled{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.userInteractionEnabled = enabled;
    [button setImage:[nomalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    if (higeLightedImage) {
        [button setImage:higeLightedImage forState:UIControlStateHighlighted];
    }
    [button sizeToFit];
    if (button.bounds.size.width < 40) {
        CGFloat width = 40 / button.bounds.size.height * button.bounds.size.width;
        button.bounds = CGRectMake(0, 0, width, 40);
    }
    if (button.bounds.size.height > 40) {
        CGFloat height = 40 / button.bounds.size.width * button.bounds.size.height;
        button.bounds = CGRectMake(0, 0, 40, height);
    }
    button.imageEdgeInsets = imageEdgeInsets;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

+(UIBarButtonItem *)itemWithTarget:(id)target
                            action:(SEL)action
                             title:(NSString *)title
            userInteractionEnabled:(BOOL)enabled {
    return [self itemWithTarget:target
                         action:action
                          title:title
                           font:[UIFont boldSystemFontOfSize:18]
                     titleColor:UIColorFromRGB(0x000000)
               highlightedColor:nil
                titleEdgeInsets:UIEdgeInsetsZero
         userInteractionEnabled:enabled];
}

+(UIBarButtonItem *)itemWithTarget:(id)target
                            action:(SEL)action
                             title:(NSString *)title
                              font:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                  highlightedColor:(UIColor *)highlightedColor
            userInteractionEnabled:(BOOL)enabled{
    return [self itemWithTarget:target
                         action:action
                          title:title
                           font:font
                     titleColor:titleColor
               highlightedColor:highlightedColor
                titleEdgeInsets:UIEdgeInsetsZero
         userInteractionEnabled:enabled];
}

+(UIBarButtonItem *)itemWithTarget:(id)target
                            action:(SEL)action
                             title:(NSString *)title
                   titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
            userInteractionEnabled:(BOOL)enabled{
    return [self itemWithTarget:target
                         action:action
                          title:title
                           font:[UIFont boldSystemFontOfSize:18]
                     titleColor:UIColorFromRGB(0x000000)
               highlightedColor:nil
                titleEdgeInsets:titleEdgeInsets
         userInteractionEnabled:enabled];
}

//+(UIBarButtonItem *)itemWithTarget:(id)target
//                            action:(SEL)action
//                             title:(NSString *)title
//                              font:(UIFont *)font
//                        titleColor:(UIColor *)titleColor
//                  highlightedColor:(UIColor *)highlightedColor
//                   titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    [button setTitle:title forState:UIControlStateNormal];
//    button.titleLabel.font = font?font:nil;
//    [button setTitleColor:titleColor?titleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button setTitleColor:highlightedColor?highlightedColor:nil forState:UIControlStateHighlighted];
//    
//    [button sizeToFit];
//    if (button.bounds.size.width < 40) {
//        CGFloat width = 40 / button.bounds.size.height * button.bounds.size.width;
//        button.bounds = CGRectMake(0, 0, width, 40);
//    }
//    if (button.bounds.size.height > 40) {
//        CGFloat height = 40 / button.bounds.size.width * button.bounds.size.height;
//        button.bounds = CGRectMake(0, 0, 40, height);
//    }
//    button.titleEdgeInsets = titleEdgeInsets;
//    return [[UIBarButtonItem alloc] initWithCustomView:button];
//}

+(UIBarButtonItem *)itemWithTarget:(id)target
                            action:(SEL)action
                             title:(NSString *)title
                              font:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                  highlightedColor:(UIColor *)highlightedColor
                   titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
            userInteractionEnabled:(BOOL)enabled {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font?font:nil;
    button.userInteractionEnabled = enabled;
    [button setTitleColor:titleColor?titleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor?highlightedColor:nil forState:UIControlStateHighlighted];
    
    [button sizeToFit];
    if (button.bounds.size.width < 40) {
        CGFloat width = 40 / button.bounds.size.height * button.bounds.size.width;
        button.bounds = CGRectMake(0, 0, width, 40);
    }
    if (button.bounds.size.height > 40) {
        CGFloat height = 40 / button.bounds.size.width * button.bounds.size.height;
        button.bounds = CGRectMake(0, 0, 40, height);
    }
    button.titleEdgeInsets = titleEdgeInsets;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+(UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width {
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = width;
    return fixedSpace;
}

@end
