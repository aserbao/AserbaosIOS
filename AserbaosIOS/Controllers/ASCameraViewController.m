//
//  ASCameraViewController.m
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/12.
//

#import "ASCameraViewController.h"
#import "ASCameraPreview.h"
#import "ASCameraVideo.h"
#import "ASVideoViewController.h"

@interface ASCameraViewController ()

@end

@implementation ASCameraViewController

/// 添加相机预览
- (void)viewDidLoad {
    [super viewDidLoad];
    // 相机预览
//    ASCameraPreview *asCameraPreview = [[ASCameraPreview alloc] initWithFrame:[UIScreen mainScreen].bounds withPositionDevice:YES withTakePhotoSuccess:^{
//        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//        [alertCon addAction:cancel];
//        [self presentViewController:alertCon animated:YES completion:nil];
//    }];
//    [self.view addSubview:asCameraPreview];
    
    
    ASCameraVideo *asCameraVideo = [[ASCameraVideo alloc] initWithFrame:[UIScreen mainScreen].bounds withPositionDevice:YES didRecord:^(NSURL *outputFileUrl, NSError *error) {
        ASVideoViewController *vc = [[ASVideoViewController alloc] initWithVideoUrl:outputFileUrl];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:asCameraVideo];
}
@end
