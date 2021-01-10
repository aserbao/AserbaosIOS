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
        ///获取AppName.app目录路径
        NSString *mianPath = [[NSBundle mainBundle]bundlePath];
        ///获取Documents目录路径: 用于写入应用相关数据文件的目录，在ios中写入这里的文件能够与iTunes共享并访问，存储在这里的文件会自动备份到云端
        NSString *documentPath =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
        ///获取Library/Caches目录路径: 用于写入应用支持文件的目录，保存应用程序再次启动需要的信息。iTunes不会对这个目录的内容进行备份
        NSString *cachePath =NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES).firstObject;
        /// 获取 Library/Application Support目录路径: 这个目录包含应用程序的偏好设置文件，使用 NSUserDefault类进行偏好设置文件的创建、读取和修改
        [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        /// 获取 temp 目录路径: 这个目录用于存放临时文件，只程序终止时需要移除这些文件，当应用程序不再需要这些临时文件时，应该将其从这个目录中删除
        NSString *temPath = NSTemporaryDirectory();
        /// 获取沙河主目录路径
        NSString *hoemPath = NSHomeDirectory();
        
        /// 文件是否存在？
        Boolean isExists = [[NSFileManager defaultManager] fileExistsAtPath:@"文件路径"];
        
        
        
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

