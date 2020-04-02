//
//  EPImagePickerHelper.h
//  EasyProject
//
//  Created by ZhangZn on 2020/2/26.
//  Copyright © 2020 ZhangZn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TZImagePickerController/TZImagePickerController.h>
NS_ASSUME_NONNULL_BEGIN

@interface EPImagePickerHelper : NSObject<UINavigationControllerDelegate,  UIImagePickerControllerDelegate, TZImagePickerControllerDelegate>

/**
 完成后返回图片路径数组
 */
@property (nonatomic, copy) void(^finish)(NSArray *array);


/**
 打开手机图片库
 
 @param maxCount 最大张数
 @param superController superController
 */
- (void)pushImagePickerController:(NSInteger)maxCount WithViewController: (UIViewController *)superController;

@end

NS_ASSUME_NONNULL_END
