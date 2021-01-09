//
//  ASStudent.h
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASStudent : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSNumber *age;

///instancetype:返回当前初始类的类型
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)appWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
