//
//  ASPerson.h
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/12.
//

#import <Foundation/Foundation.h>

@interface ASPerson : NSObject{
    //身高
    @public
    NSString *_name;
    //年龄
    int _age;
}

-(void) inputName:(NSString *) name;
-(void) inputAge:(int *) age;
-(NSString *) info;
@end

