//
//  ViewController.m
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/7.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
- (IBAction)calc;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstNum;
@property (weak, nonatomic) IBOutlet UITextField *txtSecondNum;
@property (weak, nonatomic) IBOutlet UITextField *outResult;
@property (weak, nonatomic) IBOutlet UIButton *calcView;
- (IBAction)useTransform:(UIButton *)sender;
- (IBAction)useDictionary;
- (IBAction)showLabel:(UIButton *)sender;
- (IBAction)someBasics;
- (IBAction)showAlert:(id)sender;
- (IBAction)useTimer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *scrollImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self dynamicAddView];
    [self useUIScrollView];
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
    //移除View
//    [self.view.superview removeFromSuperview:button];
    
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

///使用字典
-(void)useDictionary{
    NSDictionary *dict = @{@"name":@"aserbao",@"age":@18,@"height":@180};
    NSDictionary *dict1 = @{@"name":@"aserbao1",@"age":@19,@"height":@180};
    NSDictionary *dict2 = @{@"name":@"aserbao2",@"age":@20,@"height":@180};
    
    NSArray *students = @[dict,dict1,dict2];
    NSLog(@"%@",students);
}

/// 创建Label
- (IBAction)showLabel:(UIButton *)sender {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"这是一个Label";
    label.backgroundColor = [UIColor blackColor];
    
    CGFloat viewW = self.view.frame.size.width;
    CGFloat viewH = self.view.frame.size.height;
    
    CGFloat msgW = 200;
    CGFloat msgH = 100;
    
    CGFloat msgX = (viewW - msgW)/2;
    CGFloat msgY = (viewH - msgH)/2;
    
    label.frame = CGRectMake(msgX, msgY, msgW, msgH);
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    
    label.alpha = 0;
    label.layer.cornerRadius = 20;
    label.layer.masksToBounds = YES;
    
    [UIView animateWithDuration:2 animations:^{
        label.alpha = 0.6;
    } completion:^(BOOL finished) {
        if(finished){
            [UIView animateWithDuration:1 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    label.alpha = 0;
            } completion:^(BOOL finished) {
                if(finished){
                    [label removeFromSuperview];
                }
            }];
        }
    }];
    
    // 让subviews这个数组中的每一个函数都调用一下removeFromSuperView这个方法。
//    [self.calcView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.view addSubview:label];
}

/// 修改状态栏的文字颜色为白色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDarkContent;
}
/// 隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}

///显示日志
- (void) showLog:(NSString *) input{
    NSLog(@"printStr %@",input);
}


///一些基础的用法
- (void) someBasics{
    
    /// 第一种方式：直接调用
    [self showLog:@"调用方法的第一种方式"];
    /// 第二种方式： 通过performSelector调用
    [self performSelector:@selector(showLog:) withObject:@"调用方法的第二种方式"];
    [self performSelector:@selector(showLog:) withObject:@"延时1s调用showLong方法" afterDelay:1];
    
    /// 第三种方式：通过获取方法签名调用
    NSMethodSignature *signOfShowLog = [self methodSignatureForSelector:@selector(showLog:)];
    //获取方法签名对应的invocation
    NSInvocation *invocationOfShowLog = [NSInvocation invocationWithMethodSignature:signOfShowLog];
    /**
     设置消息接受者，与[invocationOfShowLog setArgument:(__bridge void * _Nonnull)(self) atIndex:0]等价
     */
    [invocationOfShowLog setTarget:self];
    /**设置要执行的selector。与[invocationOfShowLog setArgument:@selector(printStr1:) atIndex:1] 等价*/
    [invocationOfShowLog setSelector:@selector(showLog:)];
    //设置参数
    NSString *str = @"通过获取方法签名的方式调用方法";
    [invocationOfShowLog setArgument:&str atIndex:2];
    //开始执行
    [invocationOfShowLog invoke];
}
/// 显示弹框
- (IBAction)showAlert:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"这是一个弹框" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"你点了确定键");
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"你点了取消键");
    }];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
}
///使用计时器
- (IBAction)useTimer {
//    [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:<#^(NSTimer * _Nonnull timer)block#>]
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector([self showLog:@"useTimer"]) userInfo:nil repeats:YES];
}


- (void) useUIScrollView{
    self.scrollView.contentSize = self.scrollImageView.frame.size;
    // 水平方向进度条隐藏
    self.scrollView.showsVerticalScrollIndicator = NO;
    // 竖直方向进度条隐藏
    self.scrollView.showsHorizontalScrollIndicator = NO;
    // 默认距离上面移动50
    self.scrollView.contentOffset = CGPointMake(0, 50);
    // 设置上下左右的距离
    self.scrollView.contentInset = UIEdgeInsetsMake(50, 10, 0, 0);
    
    self.scrollView.delegate = self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSString *pointStr = NSStringFromCGPoint(scrollView.contentOffset);
    NSLog(@"正在滚动中…… %@",pointStr);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"开始拖拽……");
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"停止拖拽……");
}


@end
