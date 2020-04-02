//
//  ScanQRViewController.m
//  EasyProject
//
//  Created by ZhangZn on 2020/2/26.
//  Copyright © 2020 ZhangZn. All rights reserved.
//

#import "ScanQRViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <TZImagePickerController/TZImagePickerController.h>
#define UP_DOWN_VIEW_HEIGHT (KScreenHeight-(KScreenWidth-100))/2.0

@interface ScanQRViewController ()<AVCaptureMetadataOutputObjectsDelegate,TZImagePickerControllerDelegate> {
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    UIImageView     *_scanView;
    UIImageView     *_lineView;
    int num;
    BOOL upOrdown;
    NSTimer *timer;
    UIImageView *imgView;
    UIButton *leftBtn;
    UIButton *albumBtn;
    NSInteger _scanningNumber;
}

@end

@implementation ScanQRViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _scanningNumber = 0;
    [self setCaptureView];
    
    leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 24, 40, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"arrow_D-L_white"] forState:UIControlStateNormal];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    albumBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-20-40, 24, 40, 40)];
    [albumBtn setImage:[UIImage imageNamed:@"ico-album-A"] forState:UIControlStateNormal];
    albumBtn.backgroundColor = [UIColor clearColor];
    [albumBtn addTarget:self action:@selector(albumBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:albumBtn];
    // Do any additional setup after loading the view.
}

- (void)setCaptureView{
    num = 0;
    upOrdown = NO;
    [timer invalidate];
    timer = nil;
    self.view.backgroundColor = [UIColor whiteColor];
//    UIBarButtonItem *backBtn = [UIBarButtonItem itemWithTarget:self action:@selector(backAction) image:[UIImage imageNamed:@"arrow_D-L"] userInteractionEnabled:YES];
//    self.navigationItem.leftBarButtonItems = @[backBtn];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    // Do any additional setup after loading the view.
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:input ] && [_session canAddOutput:output])
    {
        [_session addInput: input];
        [_session addOutput:output];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, UP_DOWN_VIEW_HEIGHT, KScreenWidth-100, KScreenWidth-100)];
//        imageView.centerY = KScreenHeight/2;
        imageView.image = [UIImage imageNamed:@"img-scan-frame"];
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,imageView.frame.size.width, 20)];
        imgView.image = [UIImage imageNamed:@"img-scan-line"];
        [imageView addSubview:imgView];
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
        
        [self.view addSubview:imageView];
        
        //最上部view
        UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, UP_DOWN_VIEW_HEIGHT)];
        upView.backgroundColor = UIColorFromRGBAndAlpha(0x000000, 0.8);
        [self.view addSubview:upView];
        
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 26)];
        tipsLabel.backgroundColor = UIColorFromRGBAndAlpha(0x000000, 0.85);
        tipsLabel.centerX = upView.frameWidth/2;
        tipsLabel.originY = upView.frameHeight-20-26;
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.font = [UIFont systemFontOfSize:14];
        tipsLabel.layer.masksToBounds = YES;
        tipsLabel.layer.cornerRadius = 13.0;
        tipsLabel.textColor = [UIColor whiteColor];
        if (_tipsString) {
            tipsLabel.text = _tipsString;
        }
        else{
            tipsLabel.text = @"请将条码/二维码放进框内";
        }
        [upView addSubview:tipsLabel];
        
        //左侧的view
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, upView.originY+upView.frameHeight, 50, (KScreenHeight-100)/2.0)];
        leftView.backgroundColor = UIColorFromRGBAndAlpha(0x000000, 0.8);
        [self.view addSubview:leftView];
        //右侧的view
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth-50, upView.originY+upView.frameHeight, 50, (KScreenHeight-100)/2.0)];
        rightView.backgroundColor = UIColorFromRGBAndAlpha(0x000000, 0.8);
        [self.view addSubview:rightView];
        
        //底部view
        UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-UP_DOWN_VIEW_HEIGHT, KScreenWidth, UP_DOWN_VIEW_HEIGHT)];
        downView.backgroundColor = UIColorFromRGBAndAlpha(0x000000, 0.8);
        [self.view addSubview:downView];
        
        [output setRectOfInterest : CGRectMake (imageView.frame.origin.y/KScreenHeight,imageView.frame.origin.x/KScreenWidth,imageView.frame.size.height/KScreenHeight,imageView.frame.size.width/KScreenWidth)];
        
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        layer.frame = self.view.layer.bounds;
        [self.view.layer insertSublayer:layer atIndex:0];
        //开始捕获
        [_session startRunning];
    }
    else{
//        self.view.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.3];
        UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        upView.backgroundColor = UIColorFromRGBAndAlpha(0x000000, 0.8);
        [self.view addSubview:upView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
        label.text = @"对不起，无法获取设备";
        label.textColor = UIColorFromRGB(0xffffff);
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.center = CGPointMake(KScreenWidth/2, (KScreenHeight-64)/2);
        [upView addSubview:label];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请前往设置->隐私->相机，开启相机服务" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action1];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        imgView.originY = 2*num;
        if (2*num > (int)(KScreenWidth-100)-20) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        imgView.originY = 2*num;
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        _scanningNumber = _scanningNumber + 1;
        
        if (_scanningNumber > 1) {
            return;
        }
        
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //解决中文乱码问题
        NSString *string = metadataObject.stringValue;
//        if ([string canBeConvertedToEncoding:NSShiftJISStringEncoding])
//        {
//            string = [NSString stringWithCString:[string cStringUsingEncoding:
//                                                  NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
//        }
        //输出扫描字符串
        NSLog(@"%@",string);
        if (_delegate && [_delegate respondsToSelector:@selector(scanQrcodeWithStr:)]) {
            [_delegate scanQrcodeWithStr:string];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)albumBtnAction {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.naviBgColor = [UIColor whiteColor];
    imagePickerVc.naviTitleColor = UIColorFromRGB(0x504e54);
    imagePickerVc.naviTitleFont = [UIFont systemFontOfSize:17];
    imagePickerVc.barItemTextFont = [UIFont systemFontOfSize:14];
    imagePickerVc.barItemTextColor = UIColorFromRGB(0x504e54);
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    
    __weak ScanQRViewController *weakSelf = self;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        UIImage *image = photos[0];
        // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
        // 声明一个 CIDetector，并设定识别类型 CIDetectorTypeQRCode
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
        
        // 取得识别结果
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        
        if (features.count > 0) {
            for (int index = 0; index < [features count]; index ++) {
                CIQRCodeFeature *feature = [features objectAtIndex:index];
                NSString *resultStr = feature.messageString;
                NSLog(@"%@",resultStr);
                if (resultStr.length > 0) {
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(scanQrcodeWithStr:)]) {
                        [weakSelf.delegate scanQrcodeWithStr:resultStr];
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    break;
                }
            }
        }else{
            [[HUDHelper getInstance]showInformationWithoutImage:@"未发现二维码/条码" view:self.view];
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

