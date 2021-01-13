//
//  ASCameraPreview.m
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/12.
//  实现相机预览

#import "ASCameraPreview.h"
#import <AVFoundation/AVFoundation.h>
@interface ASCameraPreview()
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDevice *_device;
@property (strong, nonatomic) AVCapturePhotoOutput *capturePhotoOutput;
@property (strong, nonatomic) AVCapturePhotoSettings *_outputSettings;

@end

@implementation ASCameraPreview

- (instancetype)initWithFrame:(CGRect)frame withPositionDevice:(BOOL)isBack {
    if(self = [super initWithFrame:frame]){
        if(isBack){
            [self initCameraWithPosition:AVCaptureDevicePositionBack];
        }else{
            [self initCameraWithPosition:AVCaptureDevicePositionFront];
        }
    }
    return self;
}


/// 初始化相机
- (void)initCameraWithPosition:(AVCaptureDevicePosition)position{
    //step1: create a session
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // step2: create device
    NSArray *devices = [NSArray new];
    if (@available(iOS 10.0, *)) {
        AVCaptureDeviceDiscoverySession *deviceDiscoverySession =  [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
        devices = deviceDiscoverySession.devices;
    }else{
        devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    }
    for (AVCaptureDevice *device in devices) {
            if (position == device.position) {
                self._device = device;
            }
    }
    
    // step3：create deviceinput
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self._device error:&error];
    if(deviceInput && [self.session canAddInput:deviceInput]){
        [self.session addInput:deviceInput];
    }
    
    // step4: create a previewLayout
    AVCaptureVideoPreviewLayer *previewLayout = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [previewLayout setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [previewLayout setFrame:self.bounds];
    [self.layer insertSublayer:previewLayout atIndex:0];
    
    
    //step5: session start running
    [self.session startRunning];
}



@end
