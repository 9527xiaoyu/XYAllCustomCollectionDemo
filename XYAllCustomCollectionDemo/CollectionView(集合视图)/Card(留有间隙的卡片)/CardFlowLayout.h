//
//  CardFlowLayout.h
//  XYAllCustomCollectionDemo
//
//  Created by 4AM_XIAO on 2020/7/16.
//  Copyright © 2020 4AM_XIAO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardFlowLayout : UICollectionViewFlowLayout<UIScrollViewDelegate>

///循环
@property (nonatomic, assign) BOOL isScroll;

@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, assign, readonly) NSInteger lastIndex;
@property (nonatomic, assign) CGFloat startX;
@property (nonatomic, assign) CGFloat endX;
-(void)cellToCenter;

@end

NS_ASSUME_NONNULL_END
