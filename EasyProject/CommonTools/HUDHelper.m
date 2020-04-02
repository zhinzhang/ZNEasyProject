//
//  HUDHelper.m
//  Leysen
//
//  Created by ZhangZn on 2017/11/22.
//  Copyright © 2017年 Wenyu. All rights reserved.
//

#import "HUDHelper.h"
#import "AppDelegate.h"


@interface HUDHelper ()

@end

@implementation HUDHelper

+ (HUDHelper *) getInstance
{
    /*
     static dispatch_once_t once;
     static ThemeManager *instance = nil;
     dispatch_once( &once, ^{ instance = [[ThemeManager alloc] init]; } );
     return instance;
     */
    static HUDHelper *instance = nil;
    
    @synchronized(self) {
        if (instance == nil) {
            instance = [[HUDHelper alloc] init];
        }
    }
    
    return instance;
}

- (void) showLabelHUDOnScreen:(NSString*)label enabled:(BOOL)enabled{
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
    self.HUD = [[MBProgressHUD alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    self.HUD.userInteractionEnabled = enabled;
    [[self appDelegate].window addSubview:self.HUD];
    self.HUD.backgroundView.userInteractionEnabled = enabled;
    [self.HUD setMinSize:CGSizeMake(280, 80)];
    self.HUD.bezelView.color = ColorB3;
    self.HUD.delegate = (id)self;
    self.HUD.detailsLabel.text = label;
    self.HUD.detailsLabel.textColor = ButtonCColor;
    self.HUD.detailsLabel.font = ButtonBFont;
    
    [self.HUD showAnimated:YES];
}

- (void) showLabelHUD:(NSString *)label view:(UIView*)view{
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    self.HUD = [[MBProgressHUD alloc] initWithView:view];
    [self.HUD setMinSize:CGSizeMake(280, 80)];
    self.HUD.bezelView.color = ColorB3;
    [view addSubview:self.HUD];
    
    self.HUD.delegate = (id)self;
    //self.HUD.labelText = label;
    self.HUD.detailsLabel.text = label;
    self.HUD.detailsLabel.textColor = ButtonCColor;
    self.HUD.detailsLabel.font = ButtonBFont;
    [self.HUD showAnimated:YES];
}



//提示 成功tip
- (void)showSuccessTipWithLabel:(NSString*)label view:(UIView*)view{
    
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
    if (view) {
        self.HUD = [[MBProgressHUD alloc] initWithView:view];
    }else{
        self.HUD = [[MBProgressHUD alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    }
    [self.HUD setMinSize:CGSizeMake(280, 80)];
    self.HUD.bezelView.color = ColorB3;
    // self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBProgressHUD.bundle/success.png"]];
    self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_提示_完成"]];
    // Set custom view mode
    self.HUD.mode = MBProgressHUDModeCustomView;
    if (view) {
        [view addSubview:self.HUD];
    }else{
        [[self appDelegate].window addSubview:self.HUD];
    }
    self.HUD.delegate = (id)self;
    //self.HUD.labelText = label;
    self.HUD.detailsLabel.text = label;
    self.HUD.detailsLabel.textColor = ButtonCColor;
    self.HUD.detailsLabel.font = ButtonBFont;
    [self.HUD showAnimated:YES];
    [self.HUD hideAnimated:YES afterDelay:1.0];
}
#pragma mark - 只显示文字
- (void)showInformationWithoutImage:(NSString*)label view:(UIView*)view{
    
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
    if (view) {
        self.HUD = [[MBProgressHUD alloc] initWithView:view];
    }else{
        self.HUD = [[MBProgressHUD alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    }
    [self.HUD setMinSize:CGSizeMake(280, 80)];
    self.HUD.bezelView.color = ColorB3;
    self.HUD.customView = [[UIImageView alloc] initWithImage:nil];
    // Set custom view mode
    self.HUD.mode = MBProgressHUDModeCustomView;
    if (view) {
        [view addSubview:self.HUD];
    }else{
        [[self appDelegate].window addSubview:self.HUD];
    }
    self.HUD.delegate = (id)self;
    self.HUD.detailsLabel.text = label;
    self.HUD.detailsLabel.textColor = ButtonCColor;
    self.HUD.detailsLabel.font = ButtonBFont;
    [self.HUD showAnimated:YES];
    [view bringSubviewToFront:self.HUD];
    [self.HUD hideAnimated:YES afterDelay:1.0];
}

- (void)annularDeterminateView:(UIView*)view tips:(NSString *)tips {
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
    if (view) {
        self.HUD = [[MBProgressHUD alloc] initWithView:view];
    }else{
        self.HUD = [[MBProgressHUD alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    }
    [self.HUD setMinSize:CGSizeMake(280, 80)];
    self.HUD.bezelView.color = ColorB3;
    self.HUD.customView = [[UIImageView alloc] initWithImage:nil];
    // Set custom view mode
    self.HUD.mode = MBProgressHUDModeAnnularDeterminate;
    if (view) {
        [view addSubview:self.HUD];
    }else{
        [[self appDelegate].window addSubview:self.HUD];
    }

    self.HUD.delegate = (id)self;
    self.HUD.detailsLabel.text = tips;
    self.HUD.detailsLabel.textColor = ButtonCColor;
    self.HUD.detailsLabel.font = ButtonBFont;
    [self.HUD showAnimated:YES];
    [view bringSubviewToFront:self.HUD];
}

//提示 错误tip
- (void)showErrorTipWithLabel:(NSString*)label view:(UIView*)view{
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
    if (view) {
        self.HUD = [[MBProgressHUD alloc] initWithView:view];
    }else{
        self.HUD = [[MBProgressHUD alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    }
    
    self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_提示_失败"]];
    
    // Set custom view mode
    self.HUD.mode = MBProgressHUDModeCustomView;
    
    if (view) {
        [view addSubview:self.HUD];
    }else{
        [[self appDelegate].window addSubview:self.HUD];
    }
    
    self.HUD.delegate = (id)self;
    self.HUD.detailsLabel.text = label;
    self.HUD.detailsLabel.textColor = ButtonCColor;
    self.HUD.detailsLabel.font = ButtonBFont;
    [self.HUD showAnimated:YES];
    [self.HUD hideAnimated:YES afterDelay:1.0];
}

- (void) setHUDLabel:(NSString*)label{
    self.HUD.detailsLabel.text = label;
}

- (void) hideHUD{
    [self.HUD hideAnimated:YES];
}
#pragma HUD ---EOF

#pragma mark MBProgressHUDDelegate methods --BOF
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [self.HUD removeFromSuperview];
    self.HUD = nil;
}
#pragma mark MBProgressHUDDelegate methods --EOF

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


@end
