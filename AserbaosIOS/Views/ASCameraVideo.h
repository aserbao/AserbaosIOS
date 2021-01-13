//
//  ASCameraPreview.h
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/12.
//

#import <UIKit/UIKit.h>
@interface ASCameraVideo : UIView
///初始化
- (instancetype)initWithFrame:(CGRect)frame withPositionDevice:(BOOL)isBack didRecord:(void (^)(NSURL *outputFileUrl, NSError *error))completionBlock;
@end

