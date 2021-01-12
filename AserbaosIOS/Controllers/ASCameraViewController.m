//
//  ASCameraViewController.m
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/12.
//

#import "ASCameraViewController.h"
#import "ASCameraPreview.h"

@interface ASCameraViewController ()

@end

@implementation ASCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ASCameraPreview *asCameraPreview = [[ASCameraPreview alloc] initWithFrame:[UIScreen mainScreen].bounds withPositionDevice:YES withTakePhotoSuccess:^{
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertCon addAction:cancel];
        [self presentViewController:alertCon animated:YES completion:nil];
    }];
    [self.view addSubview:asCameraPreview];
}
@end
