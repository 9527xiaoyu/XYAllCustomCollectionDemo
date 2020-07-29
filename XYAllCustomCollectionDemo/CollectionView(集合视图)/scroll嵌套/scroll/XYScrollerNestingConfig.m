//
//  XYScrollerNestingConfig.m
//  XYAllCustomCollectionDemo
//
//  Created by 4AM_XIAO on 2020/7/29.
//  Copyright © 2020 4AM_XIAO. All rights reserved.
//

#import "XYScrollerNestingConfig.h"
#import "config/ScrollerNestingHeader.h"

@implementation XYScrollerNestingConfig
- (instancetype)init
{
    self = [super init];
    if (self) {
        //标题
        self.titleFont = kFontNormal(14);
        self.titleNormalColor = kColorDarkGray;
        self.titleSelectColor = kColorOrange;
        
        //下标
        self.tagNormalColor = kColorLightGray;
        self.tagNormalHeight = 1.0;
        self.tagSelectHeight = 2.0;
        
        //间距
        self.margin4Subview = 15.0;
        self.padding4Subview = 4.0;
        self.sn_backGroundColor = kColorWhite;
        self.canDoubleTouch = NO;
//        self.sn_scrollerAnimat = 
    }
    return self;
}

- (void)setTitleSelectColor:(UIColor *)titleSelectColor
{
    _titleSelectColor = titleSelectColor;
    self.tagSelectColor = titleSelectColor;
}

@end
