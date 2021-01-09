//
//  ASStudent.m
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/8.
//

#import "ASStudent.h"

@implementation ASStudent


- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self.name = dict[@"name"];
        self.age = dict[@"age"];
    }
    return self;
}

+(instancetype)appWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
