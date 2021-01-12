//
//  ASCameraPreview.h
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TakePhotoSuccess)(void);

@interface ASCameraVideo : UIView
///初始化
- (instancetype)initWithFrame:(CGRect)frame withPositionDevice:(BOOL)isBack withTakePhotoSuccess:(TakePhotoSuccess)takePhotoSuccess;
@end

NS_ASSUME_NONNULL_END
