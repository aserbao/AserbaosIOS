//
//  ASCameraPreview.m
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/12.
//

#import "ASCameraPreview.h"
#import <AVFoundation/AVFoundation.h>
@interface ASCameraPreview()<AVCapturePhotoCaptureDelegate>
@end

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
    [self addSomeView];
    return self;
}

//添加一些布局
- (void)addSomeView{
    // 添加拍照按钮
    CGRect frame = [UIScreen mainScreen].bounds;
    UIButton *takeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    takeButton.frame = CGRectMake((frame.size.width - 70)/2, frame.size.height - 100, 70, 70);
    takeButton.layer.masksToBounds = YES;
    takeButton.layer.cornerRadius = takeButton.frame.size.height/2;
    takeButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [takeButton setTitle:@"拍照" forState:UIControlStateNormal];
    takeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    takeButton.titleLabel.numberOfLines = 0;
    [takeButton setTitleColor:[UIColor colorWithRed:40.2f/255 green:180.2f/255 blue:247.2f/255 alpha:0.9] forState:UIControlStateNormal];
    [takeButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:takeButton];
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
// ----------------------- AVCapturePhotoCaptureDelegate 方法实现----------------------
/// 代理类方法实现
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhotoSampleBuffer:(CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(AVCaptureBracketedStillImageSettings *)bracketSettings error:(NSError *)error{
    
    NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *image = [UIImage imageWithData:data];
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    NSLog(@"+++++++++++%@", msg);
}
/// 拍照方法，设置代理
-(void) takePhoto{
    NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
    AVCapturePhotoSettings *outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
    [capturePhotoOutput capturePhotoWithSettings:outputSettings delegate:self];
}



@end
