//
//  ASRippleViewController.h
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/15.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASRippleViewController : GLKViewController<AVCaptureVideoDataOutputSampleBufferDelegate>
@property(nonatomic) CGFloat saturation;
@end

NS_ASSUME_NONNULL_END
