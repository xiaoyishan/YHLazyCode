//
//  ViewController.h
//  YHLazyCode
//
//  Created by MasterFly on 2017/6/9.
//  Copyright © 2017年 MasterFly. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define BtnFormat @"- (%@ *)%@ {\n    if (_%@ == nil) {\n        _%@ = [%@ buttonWithType:<#(UIButtonType)#>];\n    }\n    return _%@;\n}"
#define TableFormat @"- (%@ *)%@{\n    if (_%@ == nil) {\n        _%@ = [[%@ alloc] initWithFrame:<#(CGRect)#> style:<#(UITableViewStyle)#>];\n    }\n    return _%@;\n}"
#define CollectionFormat @"- (%@ *)%@{\n    if (_%@ == nil) {\n        _%@ = [[%@ alloc] initWithFrame:<#(CGRect)#> collectionViewLayout:<#(nonnull UICollectionViewLayout *)#>];\n    }\n    return _%@;\n}"
#define CommonFormat @"- (%@ *)%@{\n    if (_%@ == nil) {\n        _%@ = [[%@ alloc] init];\n    }\n    return _%@;\n}"
#define baseFormat @"- (%@)%@{\n    if (_%@ == nil) {\n        _%@ = %@;\n    }\n    return _%@;\n}"

@interface ViewController : NSViewController


@end

