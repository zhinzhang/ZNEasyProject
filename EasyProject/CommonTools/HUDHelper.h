//
//  HUDHelper.h
//  Leysen
//
//  Created by ZhangZn on 2017/11/22.
//  Copyright © 2017年 Wenyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

@class MBProgressHUD;

@interface HUDHelper : NSObject

+ (HUDHelper *) getInstance;

@property (nonatomic, strong) MBProgressHUD *HUD;//加载提示器

//提示 成功tip
- (void)showSuccessTipWithLabel:(NSString*)label view:(UIView*)view;

//提示 错误tip
- (void)showErrorTipWithLabel:(NSString*)label view:(UIView*)view;

- (void) showLabelHUD:(NSString *)label view:(UIView*)view;

- (void) hideHUD;

- (void) showLabelHUDOnScreen:(NSString*)label enabled:(BOOL)enabled;

- (void)showInformationWithoutImage:(NSString*)label view:(UIView*)view;


//进度圈圈
- (void)annularDeterminateView:(UIView*)view tips:(NSString *)tips;

@end
