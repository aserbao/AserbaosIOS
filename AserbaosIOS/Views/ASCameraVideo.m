//
//  ASCameraPreview.m
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/12.
// 实现相机预览及捕获相机图片

#import "ASCameraVideo.h"
#import <AVFoundation/AVFoundation.h>
@interface ASCameraVideo()<AVCapturePhotoCaptureDelegate>
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDevice *_device;
@property (strong, nonatomic) AVCapturePhotoOutput *capturePhotoOutput;
@property (strong, nonatomic) AVCapturePhotoSettings *_outputSettings;
@end

@implementation ASCameraVideo{
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
    [takeButton addTarget:self action:@selector(takeVideo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:takeButton];
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
   
    // should create PhotoOutput if you want capture picture
    // 创建AVCapturePhotoOutput的输出
    self.capturePhotoOutput = [[AVCapturePhotoOutput alloc] init];
    // 设置输出图片格式
    NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
    self._outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
    // 一些配置信息
    [self.capturePhotoOutput setPhotoSettingsForSceneMonitoring:self._outputSettings];
    // 添加到Session中
    [self.session addOutput:self.capturePhotoOutput];
    
    // step4: create a previewLayout
    AVCaptureVideoPreviewLayer *previewLayout = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [previewLayout setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [previewLayout setFrame:self.bounds];
    [self.layer insertSublayer:previewLayout atIndex:0];
    
    
    //step5: session start running
    [self.session startRunning];
}
// ----------------------- AVCapturePhotoCaptureDelegate 方法实现----------------------

/// 拍照方法，设置代理
-(void) takeVideo{
    //创建图片输出格式
    NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
    //配置格式
    AVCapturePhotoSettings *outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
    //配置输出代理
    [self.capturePhotoOutput capturePhotoWithSettings:outputSettings delegate:self];
}



@end
