//
//  XYScrollerNestingTagView.m
//  XYAllCustomCollectionDemo
//
//  Created by 4AM_XIAO on 2020/7/29.
//  Copyright © 2020 4AM_XIAO. All rights reserved.
//

#import "XYScrollerNestingTagView.h"

@implementation XYScrollerNestingTagView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
