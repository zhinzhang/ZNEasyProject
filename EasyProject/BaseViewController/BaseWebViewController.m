
//
//  BaseWebViewController.m
//  EasyProject
//
//  Created by ZhangZn on 2019/11/7.
//  Copyright © 2019 ZhangZn. All rights reserved.
//

#import "BaseWebViewController.h"
#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "ScanQRViewController.h"

@interface BaseWebViewController ()<WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate,ScanQrCodeViewDeleagte,DCUniMPSDKEngineDelegate> {
    AFNetworkReachabilityManager *manager;
    UIButton *reconnectBtn;
    BOOL click;
    NSTimer *_timer;
    HUDHelper *helper;
}

@property (nonatomic, assign) BOOL webDidLoad;
@property (nonatomic, assign) BOOL networkChange;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation BaseWebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *open = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
    [open setTitle:@"打开小程序" forState:UIControlStateNormal];
    [open setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [open addTarget:self action:@selector(openMiniProgram) forControlEvents:UIControlEventTouchUpInside];
    open.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    [self.view addSubview:open];
    return;
    _webDidLoad = NO;
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.navigationController.navigationBar.hidden = YES;
    helper = [[HUDHelper getInstance] init];

    
    UIImageView *navimageView = [CommonTools findHairlineImageViewUnder:self.navigationController.navigationBar];
    navimageView.hidden = YES;
    manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    self.view.backgroundColor = [UIColor whiteColor];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    //注册供js调用的方法
    WKUserContentController *userContentController = [[WKUserContentController alloc]init];
    configuration.userContentController = userContentController;
    configuration.preferences.javaScriptEnabled = YES; //打开JavaScript交互 默认为YES
    //JS调用OC 添加处理脚本
    [userContentController addScriptMessageHandler:self name:@"callAppMethod"];
    CGFloat buttomSafeArea = (KStatusBarHeight == 44) ? 24 : 0;
    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, KStatusBarHeight, KScreenWidth, KScreenHeight-KStatusBarHeight-buttomSafeArea) configuration:configuration];
    _wkWebView.UIDelegate = self;
    _wkWebView.navigationDelegate = self;
    [self.view addSubview:_wkWebView];
    self.requestUrl = @"http://192.168.31.85:8080/";
    __weak __typeof(self)weakSelf = self;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [weakSelf checkNetworks];
    }];
    
    // Do any additional setup after loading the view.
}


- (void)openMiniProgram {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择需要打开的小程序" preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(self)weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"打开默认小程序" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openMiniProgramWithApp_id:k_AppId];
    }];
    [alertController addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"打开表格小程序" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openMiniProgramWithApp_id:k_charts_AppId];
    }];
    [alertController addAction:action2];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)openMiniProgramWithApp_id:(NSString *)app_id {
    if (![self checkUniMPResourceWithApp_id:app_id]) {
        [[HUDHelper getInstance] showSuccessTipWithLabel:@"小程序资源部署失败" view:self.view];
        return;
    }
    DCUniMPMenuActionSheetItem *item1 = [[DCUniMPMenuActionSheetItem alloc] initWithTitle:@"Item 1" identifier:@"action1"];
    DCUniMPMenuActionSheetItem *item2 = [[DCUniMPMenuActionSheetItem alloc] initWithTitle:@"Item 2" identifier:@"action2"];
    // 添加到全局配置
    [DCUniMPSDKEngine setDefaultMenuItems:@[item1,item2]];

    // 设置 delegate
    [DCUniMPSDKEngine setDelegate:self];

    // 启动 uni小程序，（参数可以在小程序中通过 plus.runtime.arguments 获取此参数）
    NSDictionary *arguments = @{ @"value":@"Hello uni microprogram" };
    [DCUniMPSDKEngine openApp:app_id
                    arguments:arguments];
}

/// 检查运行目录是否存在应用资源，不存在将应用资源部署到运行目录
- (BOOL)checkUniMPResourceWithApp_id:(NSString *)app_id {
    if (![DCUniMPSDKEngine isExistsApp:app_id]) {
        // 读取导入到工程中的wgt应用资源
        NSString *appResourcePath = [[NSBundle mainBundle] pathForResource:app_id ofType:@"wgt"];
        // 将应用资源部署到运行路径中
        if ([DCUniMPSDKEngine releaseAppResourceToRunPathWithAppid:app_id resourceFilePath:appResourcePath]) {
            NSLog(@"应用资源文件部署成功");
            return YES;
        }
        return NO;
    }
    return YES;
}

#pragma mark - DCUniMPSDKEngineDelegate
/// DCUniMPMenuActionSheetItem 点击触发回调方法
- (void)defaultMenuItemClicked:(NSString *)identifier {
    NSLog(@"标识为 %@ 的 item 被点击了", identifier);
}

/// 返回打开小程序时的自定义闪屏视图（此视图会以屏幕大小展示）
- (UIView *)splashViewForApp:(NSString *)appid {
    UIView *splashView = [[[NSBundle mainBundle] loadNibNamed:@"SplashView" owner:self options:nil] lastObject];
    return splashView;
}


// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    __weak __typeof(self)weakSelf = self;
    if ([message.name isEqualToString:@"callAppMethod"]) {
        NSDictionary *info = [message.body objectFromJSONString];
        NSString *body = message.body;
        NSString *method = [NSString stringWithFormat:@"%@:",info[@"method"]];
        NSDictionary *param = info[@"param"];
        SEL selector = NSSelectorFromString(method);
        @try {
            if (selector) {
                [weakSelf performSelector:selector withObject:param];
            }
        } @catch (NSException *exception) {
            NSLog(@"%@",exception.reason);
        } @finally {
            
        }
        NSLog(@"%@",body);
    }
}

/*
向本地存储信息
param {key:存储key;value:存储value}
*/
- (void)setAppStorage:(NSDictionary *)param {
    id value = param[@"value"];
    NSString *key = param[@"key"];
    if (value) {
        NSMutableDictionary *data = [CommonTools readFile:@"common_library.plist"];
        if (!data) {
            data = [[NSMutableDictionary alloc]init];
        }
        [data setObject:value forKey:key];
        [CommonTools writeFile:data toFile:@"common_library.plist"];
    }
    else {
        [CommonTools removeFile:[NSString stringWithFormat:@"%@.plist",key]];
    }
}

/*
 获取本地存储信息
 param {key:存储key}
 returnAppStorage:返回对应存储value
 */
- (void)getAppstorage:(NSDictionary *)param {
    NSString *key = param[@"key"];
    NSDictionary *dic = [CommonTools readFile:@"common_library.plist"];
    id value = dic[key];
    NSString *json;
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = [[NSArray alloc]initWithArray:dic[key]];
        json = [CommonTools arrayToJson:array];
    }
    else
        if ([value isKindOfClass:[NSString class]]) {
            json = [NSString stringWithFormat:@"%@",value];
        }
    else
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictionary = [[NSDictionary alloc]initWithDictionary:value];
            json = [CommonTools dictionaryToJson:dictionary];
        }
    if (!json || !value) {
        json = @"";
    }
    NSDictionary *info = [[NSDictionary alloc]initWithObjectsAndKeys:key,@"key",json,@"value", nil];
    NSDictionary *data = [[NSDictionary alloc]initWithObjectsAndKeys:@"returnAppStorage",@"method",info,@"value", nil];
    [self wkJsEvaluateWithJS:[CommonTools dictionaryToJson:data]];
}

/*
 显示alert框/同表单Actionsheet
 param: {
   title: "提示",//弹窗标题
   message: "",//消息内容
   actions: [//弹窗数组 一个为alert样式,两个及以上为actionsheet样式
     {
       title: "确认",//弹窗标题
       type: "confirm",//点击返回值:cancle
       is_default: "Y"// Y为UIAlertActionStyleDefault/N为UIAlertActionStyleDestructive
     }
   ],
 }
 */
- (void)showAlertView:(NSDictionary *)param {
    NSString *title = param[@"title"];
    NSString *message = param[@"message"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    NSArray *actions = param[@"actions"];
    __weak __typeof(self)weakSelf = self;
    NSString *type;
    if (actions.count > 0) {
        for (NSDictionary *dic in actions) {
            type = dic[@"type"];
            if (!type) {
                type = @"";
            }
            NSString *title = dic[@"title"];
            NSString *is_default = dic[@"is_default"];
            NSDictionary *data = [[NSDictionary alloc]initWithObjectsAndKeys:@"alertType",@"method",type,@"value", nil];

            UIAlertActionStyle style = [is_default isEqualToString:@"N"] ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault;
            if ([type isEqualToString:@"cancle"]) {
                style = UIAlertActionStyleCancel;
            }
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf wkJsEvaluateWithJS:[CommonTools dictionaryToJson:data]];
            }];
            [alertController addAction:action];
        }
    }
    else {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}


/*
 显示/隐藏加载框
 param: {
   type: "", message:提示消息/load:加载中类型/hide:隐藏加载框
   message: "",
   canClick: "Y/N" Y页面其他按钮可用 /N 禁用页面触摸
 }
 */
- (void)performLoading:(NSDictionary *)param {
    NSString *type = param[@"type"];
    NSString *canClick = param[@"canClick"];
    BOOL enabled = (canClick && [canClick isEqualToString:@"N"]) ? YES : NO;
    NSString *message = param[@"message"];
    if ([type isEqualToString:@"hide"]) {
        [helper hideHUD];
    }
    else
        if ([type isEqualToString:@"message"]) {
            [helper showSuccessTipWithLabel:message view:self.view];
        }
    else
        if ([type isEqualToString:@"load"]) {
            [helper showLabelHUDOnScreen:message enabled:enabled];
        }
}

/*
 下载文件
 param: {
   message: "",提示语
   file_url:""//下载地址
    file_type:""//文件类型
 }
 */
- (void)downloadFile:(NSDictionary *)param {
    NSString *file_type = param[@"file_type"];
    NSString *file_url = param[@"file_url"];
    NSString *message = param[@"message"];
    if (!message) {
        message = @"文件下载中";
    }
    if (!file_type) {
        file_type = @"";
    }
    else {
        file_type = [NSString stringWithFormat:@".%@",file_type];
    }
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [NSString stringWithFormat:@"%@/download_files/", pathDocuments];
    NSString *sandBoxPath = [NSString stringWithFormat:@"%@%@%@",filePath,[CommonTools md5:file_url],file_type];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if (!(existed&&isDir)){
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self->helper annularDeterminateView:self.view tips:message];
    });
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURL *urlNew = [NSURL URLWithString:file_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlNew];
    NSURLSessionDownloadTask *task =
    [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->helper.HUD.progress = downloadProgress.fractionCompleted;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:sandBoxPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [self->helper hideHUD];
        NSString *file = filePath.absoluteString;
        NSDictionary *data = [[NSDictionary alloc]initWithObjectsAndKeys:@"returnFilePath",@"method",file,@"value", nil];
        [self wkJsEvaluateWithJS:[CommonTools dictionaryToJson:data]];
    }];
    [task resume];
}

/*
 扫描二维码
 */

- (void)scanQrCode:(NSDictionary *)param {
    ScanQRViewController *scanVC = [[ScanQRViewController alloc]init];
    scanVC.delegate = self;
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)scanQrcodeWithStr:(NSString *)qrCode {
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:qrCode,@"value", nil];
    NSDictionary *data = [[NSDictionary alloc]initWithObjectsAndKeys:@"returnScanValue",@"method",dic,@"value", nil];
    [self wkJsEvaluateWithJS:[CommonTools dictionaryToJson:data]];
}


/*
复制
*/
- (void)setPasteboard:(NSDictionary *)param {
    NSString *value = [NSString stringWithFormat:@"%@",param[@"value"]];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = value;
}

/*
获取剪切板内容
*/
- (void)getPasteboard:(NSDictionary *)param {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *value = pasteboard.string;
    if (!value) {
        value = @"";
    }
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:value,@"value", nil];
    NSDictionary *data = [[NSDictionary alloc]initWithObjectsAndKeys:@"returnPasteboardValue",@"method",dic,@"value", nil];
    [self wkJsEvaluateWithJS:[CommonTools dictionaryToJson:data]];
}


/*
 打电话
 param {
 phone:""
 }
 */
- (void)makePhoneCall:(NSDictionary *)param {
    NSString *phone = param[@"phone"];
    NSString *url = [NSString stringWithFormat:@"telprompt://%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


/*
 获取app基础信息 如版本信息/系统信息等
 */
- (void)getAppDetailInfo:(NSDictionary *)param {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:bundlePath];
    NSDictionary *data = [[NSDictionary alloc]initWithObjectsAndKeys:@"returnAppDetailInfo",@"method",infoDict,@"value", nil];
    [self wkJsEvaluateWithJS:[CommonTools dictionaryToJson:data]];
}






- (void)checkNetworks {
    if (self.networkChange) {
        return;
    }
    self.networkChange = YES;

    BOOL network = [manager isReachable];
    if (network) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:20];
        [_wkWebView loadRequest:request];
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"httpResponse == %@", httpResponse);
            // 根据statusCode设置缓存策略
            if (httpResponse.statusCode == 304 || httpResponse.statusCode == 0) {
                [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
            } else {
                [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
            // 保存当前的NSHTTPURLResponse
                [self.defaults setObject:httpResponse.allHeaderFields forKey:self.requestUrl];
            }
            // 重新刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.wkWebView reload];
            });
        }] resume];
    }
    else {
        reconnectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 280)];
        reconnectBtn.center = CGPointMake(_wkWebView.frame.size.width/2, _wkWebView.frame.size.height/2);
        reconnectBtn.backgroundColor = [UIColor clearColor];
        [reconnectBtn setImage:[UIImage imageNamed:@"img-error-A"] forState:UIControlStateNormal];
        [reconnectBtn addTarget:self action:@selector(reconnectWebView) forControlEvents:UIControlEventTouchUpInside];
        [_wkWebView addSubview:reconnectBtn];
    }

}


- (void)reconnectWebView {
    if ([manager isReachable]) {
        reconnectBtn.frame = CGRectMake(0, 0, 0, 0);
        reconnectBtn.hidden = YES;
        reconnectBtn = nil;
        
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:20]];
    }
    else {
        [[HUDHelper getInstance] showInformationWithoutImage:@"当前网络异常" view:self.view];
        reconnectBtn.hidden = NO;
    }
}


#pragma mark - js调用方法
- (void)wkJsEvaluateWithJS:(NSString *)jsonStr {
    NSString *jsStr = [NSString stringWithFormat:@"appBlockData(\'%@\')",jsonStr];
    [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}


#pragma mark - WKUIDelegate
//通过js alert 显示一个警告面板，调用原生会走此方法。
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
