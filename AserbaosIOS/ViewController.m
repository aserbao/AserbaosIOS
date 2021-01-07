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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
}
@end
