//
//  CurrencyCell.m
//  XYAllCustomCollectionDemo
//
//  Created by 4AM_XIAO on 2020/7/15.
//  Copyright © 2020 4AM_XIAO. All rights reserved.
//

#import "CurrencyCell.h"

@interface CurrencyCell()
@property (weak, nonatomic) IBOutlet UIImageView *picImgView;
@end

@implementation CurrencyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPicIndex:(NSString *)picIndex
{
    _picIndex = picIndex;
    [self.picImgView setImage:[UIImage imageNamed:picIndex]];
}
@end
