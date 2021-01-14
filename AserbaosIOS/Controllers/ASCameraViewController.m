//
//  ASCameraViewController.m
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/12.
//

#import "ASCameraViewController.h"
#import "ASCameraPreview.h"
#import "ASCameraCapture.h"
#import "ASCameraVideo.h"
#import "ASCameraVideoAndPhoto.h"
#import "ASVideoViewController.h"


@interface ASCameraViewController (){
    CameraType _type;
}
@end

@implementation ASCameraViewController

- (instancetype) initWithType:(CameraType *)type{
    self->_type = type;
    return self;
}
/// 添加相机预览
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ASCameraViewController viewDidLoad");
    // 相机预览
    switch (self ->_type) {
        case CAMERA_ONLY_PREVIEW:
            [self addCameraOnlyPreview];
            break;
        case CAMERA_PREVIEW_AND_CAPTURE:
            [self addCameraCapture];
            break;
        case CAMERA_PREVIEW_AND_VIDEO:
            // 相机录像功能
            [self addCameraVideo];
            break;
        case CAMERA_PREVIEW_VIDEO_CAPTURE:
            [self addCameraVideoAndCapture];
            break;
        default:
            break;
    }
}

/// 添加相机预览
- (void)addCameraOnlyPreview{
    ASCameraPreview *asCameraPreview = [[ASCameraPreview alloc] initWithFrame:[UIScreen mainScreen].bounds withPositionDevice:YES];
    [self.view addSubview:asCameraPreview];
}
/// 添加相机拍照
- (void)addCameraCapture{
    ASCameraCapture *aSCameraCapture = [[ASCameraCapture alloc] initWithFrame:[UIScreen  mainScreen].bounds withPositionDevice:YES withTakePhotoSuccess:^{
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertCon addAction:cancel];
        [self presentViewController:alertCon animated:YES completion:nil];
    }];
    [self.view addSubview:aSCameraCapture];
}

/// 添加相机拍视频
- (void)addCameraVideo{
    ASCameraVideo *asCameraVideo = [[ASCameraVideo alloc] initWithFrame:[UIScreen mainScreen].bounds withPositionDevice:YES didRecord:^(NSURL *outputFileUrl, NSError *error) {
        NSLog(@"视频拍摄成功了 保存路径在:%@",outputFileUrl);
        ASVideoViewController *vc = [[ASVideoViewController alloc] initWithVideoUrl:outputFileUrl];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:asCameraVideo];
}

/// 添加视频拍摄和照片获取
- (void)addCameraVideoAndCapture{
    ASCameraVideoAndPhoto *asCameraVideoAndCapture = [[ASCameraVideoAndPhoto alloc]initWithFrame:[UIScreen mainScreen].bounds withPositionDevice:YES didRecord:^(NSURL *outputFileUrl, NSError *error) {
        NSLog(@"视频拍摄成功了 保存路径在:%@",outputFileUrl);
        ASVideoViewController *vc = [[ASVideoViewController alloc] initWithVideoUrl:outputFileUrl];
        [self.navigationController pushViewController:vc animated:YES];
    } didTakeSuccess:^{
        NSLog(@"拍照成功了");
    }];
    [self.view addSubview:asCameraVideoAndCapture];
}
@end
