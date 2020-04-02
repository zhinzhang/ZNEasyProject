//
//  AppDelegate.m
//  EasyProject
//
//  Created by ZhangZn on 2019/11/7.
//  Copyright © 2019 ZhangZn. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseWebViewController.h"
#import "DCUniMP.h"

@interface AppDelegate ()

@property (nonatomic, strong) BaseWebViewController *baseVC;

@end

@implementation AppDelegate

- (BaseWebViewController *)baseVC {
    if (!_baseVC) {
        _baseVC = [[BaseWebViewController alloc]init];
    }
    return _baseVC;
}

+(AppDelegate *)shareApp {
    return  (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 配置参数
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithDictionary:launchOptions];
    // 设置 debug YES 会在控制台输出 js log，默认不输出 log，注：需要引入 liblibLog.a 库
    [options setObject:[NSNumber numberWithBool:NO] forKey:@"debug"];
    // 初始化引擎
    [DCUniMPSDKEngine initSDKEnvironmentWihtLaunchOptions:options];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.baseVC];
    self.window.rootViewController = navigationController;
    
    
    return YES;
}

#pragma mark - App 生命周期方法
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [DCUniMPSDKEngine applicationDidBecomeActive:application];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [DCUniMPSDKEngine applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [DCUniMPSDKEngine applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [DCUniMPSDKEngine applicationWillEnterForeground:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [DCUniMPSDKEngine destory];
}

#pragma mark - 如果需要使用 URL Scheme 或 通用链接相关功能，请实现以下方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    // 通过 url scheme 唤起 App
    [DCUniMPSDKEngine application:app openURL:url options:options];
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    // 通过通用链接唤起 App
    [DCUniMPSDKEngine application:application continueUserActivity:userActivity];
    return YES;
}

#pragma mark - 如需使用远程推送相关功能，请实现以下方法
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 远程通知注册成功，收到 deviceToken 调用sdk方法，传入 deviceToken
    [DCUniMPSDKEngine application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // 远程通知注册失败
    [DCUniMPSDKEngine application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 收到远程推送消息
    [DCUniMPSDKEngine application:application didReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 如需使用本地推送通知功能，请实现以下方法
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    // 收到本地推送消息
    [DCUniMPSDKEngine application:application didReceiveLocalNotification:notification];
}

@end
