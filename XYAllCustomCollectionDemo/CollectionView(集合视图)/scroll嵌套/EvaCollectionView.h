//
//  EvaCollectionView.h
//  XYAllCustomCollectionDemo
//
//  Created by 4AM_XIAO on 2020/7/30.
//  Copyright © 2020 4AM_XIAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollNestViewController.h"
#import "ScrollerNestingHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface EvaCollectionView : UICollectionView

@property (nonatomic, assign) OffsetType offsetType;

@property (nonatomic, weak) ScrollNestViewController *mainVC;

@end

NS_ASSUME_NONNULL_END
