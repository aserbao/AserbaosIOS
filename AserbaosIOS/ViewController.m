//
//  ViewController.m
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/7.
//

#import "ViewController.h"

@interface ViewController ()
- (IBAction)calc;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstNum;
@property (weak, nonatomic) IBOutlet UITextField *txtSecondNum;
@property (weak, nonatomic) IBOutlet UITextField *outResult;
@property (weak, nonatomic) IBOutlet UIButton *calcView;
- (IBAction)useTransform:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self dynamicAddView];
}

//计算按钮执行这个方法
- (IBAction)calc {
    NSString *num1 = self.txtFirstNum.text;
    NSString *num2 = self.txtSecondNum.text;
    int n1 = num1.intValue;
    int n2 = num2.intValue;
    
    int result = n1 + n2;
    
    self.outResult.text = [NSString stringWithFormat:@"%d",result];
    
    //关闭软键盘的第一种方法
//    [self.txtFirstNum resignFirstResponder];
//    [self.txtSecondNum resignFirstResponder];
    
    //第二种做法
    [self.view endEditing:YES];
    
    [self move];
}

/**
 * View 大小和位置
 * change the view’s location and size
 */
- (void) move{
    // change the view’s location and size
    CGRect originFrame =  self.calcView.frame;
//    CGPoint originCeneter =  self.outResult.center;
//    CGRect originBounds =  self.outResult.bounds;
//    CGAffineTransform originTransform =  self.outResult.transform;
    
//    originFrame.origin.x += 10;
    originFrame.origin.y += 10;
    
    // 动画实现方式一： 头尾式执行动画 流程， 开启动画 --> 设置时间 --> 提交动画
    /**[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.calcView.frame = originFrame;
    [UIView commitAnimations];*/
    
    
    // block的方式执行
    [UIView animateWithDuration:0.5 animations:^{
        self.calcView.frame = originFrame;
    }];
}


// 动态添加视图
- (void) dynamicAddView{

    // 创建系统按钮
//    UIButton *buttonSystem = [UIButton buttonWithType:UIButtonTypeSystem];
    // 创建空白按钮
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"点击一下" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitle:@"被按下了" forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    // 大小
    button.frame = CGRectMake(50, 100, 100, 100);
    // 添加点击事件
    [button addTarget:self action:@selector(move) forControlEvents:UIControlEventTouchUpInside];
    // 添加到UIVieW上
    [self.view addSubview:button];
}

//Transform的使用
- (IBAction)useTransform:(UIButton *)sender {
//    self.calcView.transform = CGAffineTransformMakeTranslation(0, -10);
    switch (sender.tag) {
        case 10:
            self.calcView.transform = CGAffineTransformTranslate(self.calcView.transform,0, 10);
            break;
        case 11:
            self.calcView.transform = CGAffineTransformScale(self.calcView.transform,1.5,1.5);
            break;
        case 12:
            self.calcView.transform = CGAffineTransformRotate(self.calcView.transform,45);
            break;
        default:
            [UIView animateWithDuration:2.5 animations:^{
                // 恢复原状态
                self.calcView.transform = CGAffineTransformIdentity;
            }];
            break;
    }
}
@end
