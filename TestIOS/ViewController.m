//
//  ViewController.m
//  TestIOS
//
//  Created by aserbao on 2021/1/7.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 * 通过QuartzCore 来实现一个简单的3D动画
 */
- (IBAction)animation {
    CATransition *ca = [CATransition animation];
    ca.type = @"cube";
    [self.view.layer addAnimation:ca forKey:nil];
}

@end
