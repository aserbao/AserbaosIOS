//
//  ASCameraPreview.m
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/12.
//

#import "ASCameraPreview.h"
#import <AVFoundation/AVFoundation.h>

@implementation ASCameraPreview{
    TakePhotoSuccess _takePhotoSuccess;
}

- (instancetype)initWithFrame:(CGRect)frame withPositionDevice:(BOOL)isBack withTakePhotoSuccess:(TakePhotoSuccess)takePhotoSuccess{
    if(self = [super initWithFrame:frame]){
        _takePhotoSuccess = takePhotoSuccess;
        if(isBack){
            [self initCameraWithPosition:AVCaptureDevicePositionBack];
        }else{
            [self initCameraWithPosition:AVCaptureDevicePositionFront];
        }
    }
    return self;
}


AVCaptureSession *session;
AVCaptureDevice *_device;
AVCapturePhotoOutput *capturePhotoOutput;
AVCapturePhotoSettings *_outputSettings;

/// 初始化相机
- (void)initCameraWithPosition:(AVCaptureDevicePosition)position{
    //step1: create a session
    session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
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
                _device = device;
            }
    }
    
    // step3：create deviceinput
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if(deviceInput && [session canAddInput:deviceInput]){
        [session addInput:deviceInput];
    }
   
    // should create PhotoOutput if you want capture picture
    capturePhotoOutput = [[AVCapturePhotoOutput alloc] init];
    NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
    _outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
    [capturePhotoOutput setPhotoSettingsForSceneMonitoring:_outputSettings];
    [session addOutput:capturePhotoOutput];
    
    // step4: create a previewLayout
    AVCaptureVideoPreviewLayer *previewLayout = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayout setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [previewLayout setFrame:self.bounds];
    [self.layer insertSublayer:previewLayout atIndex:0];
    
    
    //step5: session start running 
    [session startRunning];
}

- (void)startRunning{
}

- (void)stopRunning{
    [session stopRunning];
}

@end