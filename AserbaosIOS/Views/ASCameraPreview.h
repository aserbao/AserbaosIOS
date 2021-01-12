//
//  ASCameraPreview.h
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TakePhotoSuccess)(void);

@interface ASCameraPreview : UIView
///初始化
- (instancetype)initWithFrame:(CGRect)frame withPositionDevice:(BOOL)isBack withTakePhotoSuccess:(TakePhotoSuccess)takePhotoSuccess;
///开始运行
- (void)startRunning;
///停止运行
- (void)stopRunning;
@end

NS_ASSUME_NONNULL_END
