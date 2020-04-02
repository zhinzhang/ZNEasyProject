//
//  ScanQRViewController.h
//  EasyProject
//
//  Created by ZhangZn on 2020/2/26.
//  Copyright © 2020 ZhangZn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ScanQrCodeViewDeleagte <NSObject>

- (void)scanQrcodeWithStr:(NSString *)qrCode;

@end

@interface ScanQRViewController : UIViewController

@property (nonatomic, strong) NSString *tipsString;
@property (nonatomic, strong) NSString *detectorString;
@property (nonatomic, assign) id<ScanQrCodeViewDeleagte>delegate;

@end

NS_ASSUME_NONNULL_END
