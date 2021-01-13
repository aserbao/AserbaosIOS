//
//  ASCameraViewController.h
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/12.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    CAMERA_ONLY_PREVIEW, // 只有相机预览
    CAMERA_PREVIEW_AND_CAPTURE, // 相机预览+拍照实现
    CAMERA_PREVIEW_AND_VIDEO, // 相机预览+拍视频实现
    CAMERA_PREVIEW_VIDEO_CAPTURE, // 相机预览+拍视频/拍照实现
} CameraType;

NS_ASSUME_NONNULL_BEGIN

@interface ASCameraViewController : UIViewController
- (instancetype) initWithType:(CameraType *)type;
@end

NS_ASSUME_NONNULL_END
