//
//  XYFont.m
//  XYAllCustomCollectionDemo
//
//  Created by 4AM_XIAO on 2020/7/29.
//  Copyright © 2020 4AM_XIAO. All rights reserved.
//

#import "XYFont.h"
#import "ScrollerNestingHeader.h"

@implementation XYFont
+ (UIFont *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize
{
    if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        return [UIFont systemFontOfSize:fontSize];
    }
    return [super fontWithName:fontName size:fontSize];
}
@end
