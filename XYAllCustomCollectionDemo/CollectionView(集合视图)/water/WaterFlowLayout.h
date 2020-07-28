//
//  WaterFlowLayout.h
//  XYAllCustomCollectionDemo
//
//  Created by 4AM_XIAO on 2020/7/23.
//  Copyright © 2020 4AM_XIAO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WaterFlowLayoutCustomDelegate <NSObject>
@optional
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section;
@end

@interface WaterFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, weak) id<WaterFlowLayoutCustomDelegate> customDelegate;

///瀑布流的分区
@property (nonatomic, strong) NSArray *waterSections;
@property (nonatomic, assign) NSInteger columnCount;

@end

NS_ASSUME_NONNULL_END
