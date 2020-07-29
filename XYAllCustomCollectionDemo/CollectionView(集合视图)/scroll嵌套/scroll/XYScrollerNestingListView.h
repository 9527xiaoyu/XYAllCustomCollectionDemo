//
//  XYScrollerNestingListView.h
//  XYAllCustomCollectionDemo
//
//  Created by 4AM_XIAO on 2020/7/29.
//  Copyright © 2020 4AM_XIAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYScrollerNestingConfig.h"
#import "XYScrollerNestingTagView.h"

NS_ASSUME_NONNULL_BEGIN

@class XYScrollerNestingListView;

@protocol XYScrollerNestingDelegate <NSObject>

- (void)XYScrollerNestingListView:(XYScrollerNestingListView*)view chooseIndex:(NSInteger)index;

@end

@interface XYScrollerNestingListView : UIView
@property (nonatomic, weak) id<XYScrollerNestingDelegate> sn_delegate;

/**
 初始化方法
 @param frame   frame
 @param config  配置文件
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame configModel:(XYScrollerNestingConfig*)config;
/**
 配置文件
 */
@property (nonatomic, strong,readonly) XYScrollerNestingConfig *config;

/**
 通过config 配置UI
 */
- (void)config4NestingView:(XYScrollerNestingConfig*)config;

/**
 当前选中的下标
 */
@property (nonatomic, assign, readonly) NSInteger currentIndex;

/**
 手动选中的下标
 */
- (void)select2Index:(NSInteger)index;

/**
 遍历全部 标签 视图
 */
-(void)circlateAllTagView:(void(^)(XYScrollerNestingTagView *tagView,NSInteger index))block;
/**
 偏移量
 @param offsetX 水平偏移
 */
-(void)config4OffsetX:(CGFloat)offsetX;

@end

NS_ASSUME_NONNULL_END
