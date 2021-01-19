//
//  ASRippleViewController.h
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/15.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ASByteEffectsViewController : GLKViewController<AVCaptureVideoDataOutputSampleBufferDelegate>
@property(nonatomic) CGFloat saturation;
@end


