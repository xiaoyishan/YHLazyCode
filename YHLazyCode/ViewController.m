//
//  ViewController.m
//  YHLazyCode
//
//  Created by MasterFly on 2017/6/9.
//  Copyright © 2017年 MasterFly. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()
@property (nonatomic, strong) NSMutableArray<NSString*> *myArr;
@property (nonatomic, assign) BOOL isBig;
@property (nonatomic, assign) NSInteger maxButton;
@property (nonatomic, strong) NSMutableArray *dArray;
@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *lineStr = @"@property (nonatomic, assign) BOOL isBig;";
    
//    if ([lineStr isEqualToString:@"\n"] || ![lineStr containsString:@";"]) {
//        continue;
//    }
    
    if ([lineStr containsString:@"*"]) {
        //去掉空格
        lineStr = [lineStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    
    
    //获取类名
    NSString *classNameStr = @"";
    //获取属性名
    NSString *propertyName = @"";
    
    if ([lineStr containsString:@">"]) {
        // 指定容器类型
        classNameStr = [[lineStr componentsSeparatedByString:@")"].lastObject componentsSeparatedByString:@">*"].firstObject;
        classNameStr = [NSString stringWithFormat:@"%@>",classNameStr];
        propertyName = [[lineStr componentsSeparatedByString:@">*"].lastObject componentsSeparatedByString:@";"].firstObject;
        
    }else if (![lineStr containsString:@"*"]) {
        // 基础类型
        for (NSString *str in [[lineStr componentsSeparatedByString:@")"].lastObject componentsSeparatedByString:@" "]) {
            if (![str isEqual:@" "]) {
                if (classNameStr.length==0) {
                    classNameStr = str;
                }else{
                    propertyName = [str componentsSeparatedByString:@";"].firstObject;
                }
                
            }
        }
    
    }else{
        // 普通NS对象
        classNameStr = [[lineStr componentsSeparatedByString:@")"].lastObject componentsSeparatedByString:@"*"].firstObject;
        propertyName = [[lineStr componentsSeparatedByString:@"*"].lastObject componentsSeparatedByString:@";"].lastObject;
    }
    
    //获取的数据存到字典中
    NSArray *formatArr = [ViewController stringForClassName:classNameStr andPropertyName:propertyName];
    NSLog(@"%@",formatArr);
    
}



+ (NSArray *)stringForClassName:(NSString *)className andPropertyName:(NSString *)propertyName{
    
    BOOL isBasicClass = NO;
    NSString *allocStr = @"";
    NSArray *classArr = @[@"BOOL"];//,@"Int",@"Float",@"Double",@"NSInteger",@"NSUInteger"];
    NSArray *allocArr = @[@"NO"];//,@"0",@"0.0",@"0.0",@"0",@"0"];
    for (int k=0; k<classArr.count; k++) {
        if ([classArr[k] isEqual:className]) {
            isBasicClass = YES;
            allocStr = allocArr[k];
        }
        
    }
    
    NSString *str = @"";
    if ([className containsString:@"Button"]) {
        str = [NSString stringWithFormat:BtnFormat,className,propertyName,propertyName,propertyName,className,propertyName];
    }else if ([className containsString:@"TableView"]){
        str = [NSString stringWithFormat:TableFormat,className,propertyName,propertyName,propertyName,className,propertyName];
    }else if ([className containsString:@"CollectionView"]){
        str = [NSString stringWithFormat:CollectionFormat,className,propertyName,propertyName,propertyName,className,propertyName];
    }else if (isBasicClass == YES) {
        str = [NSString stringWithFormat:baseFormat,className,propertyName,propertyName,propertyName,allocStr,propertyName];
    }else{
        str = [NSString stringWithFormat:CommonFormat,className,propertyName,propertyName,propertyName,className,propertyName];
        
        // 容器声明类型
        if ([className containsString:@"<"]) {
            str = [NSString stringWithFormat:CommonFormat,
                   className,
                   propertyName,
                   propertyName,
                   propertyName,
                   [className componentsSeparatedByString:@"<"].firstObject,
                   propertyName];
        }
        
    }
    NSArray *formaterArr = [[str componentsSeparatedByString:@"\n"] arrayByAddingObject:@"\n"];
    
    return formaterArr;
}

#pragma mark - Get and Set

- (NSMutableArray<NSString*> *)myArr{
    if (_myArr == nil) {
        _myArr = [[NSMutableArray alloc] init];
    }
    return _myArr;
}


@end
