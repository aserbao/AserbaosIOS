//
//  ASCameraPreview.m
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/12.
// 实现相机预览及拍摄视频，及捕获相机图片

#import "ASCameraVideoAndPhoto.h"
#import <AVFoundation/AVFoundation.h>

@interface ASCameraVideoAndPhoto()<AVCaptureFileOutputRecordingDelegate>{
    BOOL isRecording;
}
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDevice *_device;

@property (strong, nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property (strong, nonatomic) AVCapturePhotoSettings *_outputSettings;
@property (nonatomic, copy) void (^didRecordCompletionBlock)(NSURL *outputFileUrl, NSError *error);
@property (weak, nonatomic) IBOutlet UIButton *_takeButton;
@end

@implementation ASCameraVideoAndPhoto

- (instancetype)initWithFrame:(CGRect)frame withPositionDevice:(BOOL)isBack didRecord:(void (^)(NSURL *outputFileUrl, NSError *error))completionBlock{
    if(self = [super initWithFrame:frame]){
        self.didRecordCompletionBlock = completionBlock;
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
    [takeButton setTitle:@"拍视频" forState:UIControlStateNormal];
    takeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    takeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16]; // 设置粗体
    takeButton.titleLabel.numberOfLines = 0;
    [takeButton setTitleColor:[UIColor colorWithRed:40.2f/255 green:180.2f/255 blue:247.2f/255 alpha:0.9] forState:UIControlStateNormal];
    [takeButton addTarget:self action:@selector(takeVideo) forControlEvents:UIControlEventTouchUpInside];
    self._takeButton = takeButton;
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
    
    // step3：create video deviceinput
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self._device error:&error];
    if(deviceInput && [self.session canAddInput:deviceInput]){
        [self.session addInput:deviceInput];
    }
    
    //选择默认音频捕捉设备 即返回一个内置麦克风
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
    if(audioInput && [self.session canAddInput:audioInput]){
        [self.session addInput:audioInput];
    }
    
   
    // should create PhotoOutput if you want capture picture
    // 创建AVCaptureMovieFileOutput的输出
    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    [self.movieFileOutput setMovieFragmentInterval:kCMTimeInvalid];
    if([self.session canAddOutput:self.movieFileOutput]) {
        [self.session addOutput:self.movieFileOutput];
    }
    
    // step4: create a previewLayout
    AVCaptureVideoPreviewLayer *previewLayout = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [previewLayout setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [previewLayout setFrame:self.bounds];
    [self.layer insertSublayer:previewLayout atIndex:0];
    
    
    //step5: session start running
    [self.session startRunning];
}
// ----------------------- AVCapturePhotoCaptureDelegate 方法实现----------------------
/// 开始录像
- (void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections{
    isRecording = true;
}
- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error{
    isRecording = false;
    if(self.didRecordCompletionBlock){
        self.didRecordCompletionBlock(outputFileURL,error);
    }
}


/// 拍视频方法
-(void) takeVideo{
    if(isRecording){
        [self._takeButton setTitle:@"拍视频" forState:UIControlStateNormal];
        NSLog(@"停止拍摄");
        [self stopVideo];
    }else{
        [self._takeButton setTitle:@"停止拍摄" forState:UIControlStateNormal];
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *outputURL = [[url
                             URLByAppendingPathComponent:@"test1"] URLByAppendingPathExtension:@"mov"];
        NSLog(@"开始拍摄 %@",outputURL);
        [self.movieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
    }
}

- (void) stopVideo{
    [self.movieFileOutput stopRecording];
}



@end
