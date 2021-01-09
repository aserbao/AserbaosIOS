//
//  ASTomcatViewController.m
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/8.
//

#import "ASTomcatViewController.h"
#import "ASStudent.h"

@interface ASTomcatViewController ()

@property (nonatomic,strong)NSArray *apps;

@end

@implementation ASTomcatViewController

/// 懒加载，获取数据
- (NSArray *)apps{
    if(_apps == nil){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Students.plist" ofType:nil];
        
        NSArray *arrayDict = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *arrayModels = [NSMutableArray array];
        
        for (NSDictionary *dict in arrayDict) {
            ASStudent *model = [[ASStudent alloc] init];
            model.name = dict[@"name"];
            model.age = dict[@"age"];
            [arrayModels addObject:model];
        }
    }
    return _apps;
}

-(void) addView{
    // 加载xib 的View
    UIView *uiView = [[[NSBundle mainBundle] loadNibNamed:@"ASStudent" owner:nil options:nil] lastObject];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Students.plist" ofType:nil];
}

@end

