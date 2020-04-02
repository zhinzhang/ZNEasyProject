//
//  EPImagePickerHelper.m
//  EasyProject
//
//  Created by ZhangZn on 2020/2/26.
//  Copyright © 2020 ZhangZn. All rights reserved.
//

#import "EPImagePickerHelper.h"

@interface EPImagePickerHelper() <UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *imagesURL;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, weak) UIViewController *superViewController;
@property (nonatomic, assign) CGFloat compressionQuality;

@end

@implementation EPImagePickerHelper

/**
 选取手机图片
 */
- (void)pushImagePickerController:(NSInteger)maxCount WithViewController: (UIViewController *)superController
{
    self.maxCount = maxCount;
    self.superViewController = superController;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCount delegate:self];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    // 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        //NSLog(@"assets");
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.superViewController presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate

// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.finish(photos);
    });
}

#pragma mark -- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([picker.mediaTypes containsObject:(NSString *)kUTTypeImage])
    {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[HUDHelper getInstance]showLabelHUDOnScreen:@"图片处理中" enabled:YES];
            });
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            NSMutableArray *array = [[NSMutableArray alloc]init];
            [array addObject:image];
            self.finish(array);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[HUDHelper getInstance]hideHUD];
            });
        });
    }
    
    [self.superViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self.superViewController dismissViewControllerAnimated:YES completion:nil];
}
/**
 处理图片
 
 @param image image
 @return return 新图片
 */
- (UIImage *)imageProcessing:(UIImage *)image
{
    UIImageOrientation imageOrientation = image.imageOrientation;
    if (imageOrientation != UIImageOrientationUp)
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    
    CGSize imagesize = image.size;
    //质量压缩系数
    self.compressionQuality = 1;
    
    //如果大于两倍屏宽 或者两倍屏高
    if (image.size.width > 640 || image.size.height > 568*2)
    {
        self.compressionQuality = 0.5;
        //宽大于高
        if (image.size.width > image.size.height)
        {
            imagesize.width = 320*2;
            imagesize.height = image.size.height*imagesize.width/image.size.width;
        }
        else
        {
            imagesize.height = 568*2;
            imagesize.width = image.size.width*imagesize.height/image.size.height;
        }
    }
    else
    {
        self.compressionQuality = 0.6;
    }
    
    // 对图片大小进行压缩
//    UIImage *newImage = [UIImage imageWithImage:image scaledToSize:imagesize];
    return image;
}

#pragma mark -- 懒加载

- (NSMutableArray *)imagesURL
{
    if (!_imagesURL) {
        _imagesURL = [NSMutableArray array];
    }
    return _imagesURL;
}


@end
