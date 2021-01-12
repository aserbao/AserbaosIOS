//
//  ASPerson.m
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/12.
//

#import "ASPerson.h"

@implementation ASPerson

- (void)inputName:(NSString *)name{
    _name = name;
}

- (void)inputAge:(int *)age{
    _age = age;
}

- (NSString *)info{
    return [@"my name is " stringByAppendingFormat:@"%@ age: %d",_name,_age];
}
@end
