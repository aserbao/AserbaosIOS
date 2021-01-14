//
//  ASCameraPreview.h
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/12.
//

#import <UIKit/UIKit.h>
@interface ASCameraVideoAndPhoto : UIView
///初始化
//completionBlock 用来拍视频成功回调，
//completionTakeBlock: 用来处理拍照成功的回调
- (instancetype)initWithFrame:(CGRect)frame withPositionDevice:(BOOL)isBack didRecord:(void (^)(NSURL *outputFileUrl, NSError *error))completionBlock didTakeSuccess:(void (^)(void))completionTakeBlock;
@end

