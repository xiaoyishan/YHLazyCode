//
//  YHLazyCode.m
//  YHLazyCode
//
//  Created by MasterFly on 2017/6/9.
//  Copyright © 2017年 MasterFly. All rights reserved.
//


#import "YHLazyCode.h"


#define BtnFormat @"- (%@ *)%@ {\n    if (!_%@) {\n        _%@ = [%@ buttonWithType:<#(UIButtonType)#>];\n    }\n    return _%@;\n}"
#define TableFormat @"- (%@ *)%@{\n    if (!_%@) {\n        _%@ = [[%@ alloc] initWithFrame:<#(CGRect)#> style:<#(UITableViewStyle)#>];\n    }\n    return _%@;\n}"
#define CollectionFormat @"- (%@ *)%@{\n    if (!_%@) {\n        _%@ = [[%@ alloc] initWithFrame:<#(CGRect)#> collectionViewLayout:<#(nonnull UICollectionViewLayout *)#>];\n    }\n    return _%@;\n}"
#define CommonFormat @"- (%@ *)%@{\n    if (!_%@) {\n        _%@ = [[%@ alloc] init];\n    }\n    return _%@;\n}"
#define baseFormat @"- (%@)%@{\n    if (!_%@) {\n        _%@ = %@;\n    }\n    return _%@;\n}"


@implementation YHLazyCode

/**
 添加懒加载的函数到对应的文件中

 @param invocation invocation
 */
+ (void)addLazyCodeWithInvocation:(XCSourceEditorCommandInvocation *)invocation{
    for (XCSourceTextRange *range in invocation.buffer.selections) {
        NSInteger startLine = range.start.line;
        NSInteger endLine = range.end.line;
        NSInteger lineCount = invocation.buffer.lines.count;

        
        NSMutableArray *nameMulDataArr = [NSMutableArray array];
        for (NSInteger i = startLine; i <= endLine; i ++) {
            NSString *lineStr = invocation.buffer.lines[i];
            
            //NSLog(@"原始代码:%@",lineStr);
            
            if ([lineStr isEqualToString:@"\n"] || ![lineStr containsString:@";"]) {
                continue;
            }
            
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
            NSArray *formatArr = [self stringForClassName:classNameStr andPropertyName:propertyName];
            [nameMulDataArr addObject:formatArr];
            NSLog(@"%@",lineStr);
        }
        
        //输出到文件
        for (NSInteger i = 0 ; i < lineCount; i ++) {
            NSString *lineStr = invocation.buffer.lines[i];
            if ([lineStr containsString:@"#pragma mark - Get and Set"]) {
                for (NSInteger j = i + 1 ; j < nameMulDataArr.count + i + 1 ; j ++) {
                    NSArray *formatArr = [nameMulDataArr objectAtIndex:nameMulDataArr.count - j -1  + (i + 1 )];
                    for (int z = 0; z <formatArr.count ; z ++) {
                        [invocation.buffer.lines insertObject:formatArr[z] atIndex:i + 1  + z];
                    }
                }
                break;
            }
        }
        
    }
}


/**
 格式化字符并返回数组

 @param className 类名
 @param propertyName 属性名
 @return 需要写入文件的数组
 */
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

@end
