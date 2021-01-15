//
//  ASGLKitViewController.m
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/14.
//

#import "ASGLKitViewController.h"

@interface ASGLKitViewController ()<GLKViewControllerDelegate>{
    EAGLContext *context;
}

@end

@implementation ASGLKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupG];
}


-(void) setupG{
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    //2.获取GLKView & 设置context
    GLKView *view =(GLKView *) self.view;
    view.context = context;
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClearColor(0.3, 0.4, 0.5, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    //detect
    
    //draw
}

-(void)glkViewControllerUpdate:(GLKViewController *)controller{
    
}

@end
