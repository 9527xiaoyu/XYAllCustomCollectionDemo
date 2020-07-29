//
//  XYScrollerNestingConfig.h
//  XYAllCustomCollectionDemo
//
//  Created by 4AM_XIAO on 2020/7/29.
//  Copyright © 2020 4AM_XIAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ScrollerNestingConfigAnima) {
    ScrollerNestingConfigAnimaNormal = 0,
};
/**
    介绍：此配置文件中存放 标签的相关属性
 */
@interface XYScrollerNestingConfig : NSObject

/*标题相关属性*/
//*标题数组
@property(nonatomic, strong) NSArray* titlesArray;
//*标题字体
@property(nonatomic, strong) UIFont* titleFont;
//*标题默认颜色
@property(nonatomic, strong) UIColor* titleNormalColor;
//*标题选中颜色
@property(nonatomic, strong) UIColor* titleSelectColor;

/*标题图片相关属性*/
//*图片数组
//*图片尺寸
//*图片间距

/*标题下标相关属性*/
//*选中下标颜色
@property(nonatomic, strong) UIColor* tagSelectColor;
//*选中下标高度
@property(nonatomic, assign) CGFloat tagSelectHeight;
//*默认下标颜色
@property(nonatomic, strong) UIColor* tagNormalColor;
//*默认下标高度
@property(nonatomic, assign) CGFloat tagNormalHeight;

/*间距相关属性*/
//*子模块间的间距
@property(nonatomic, assign) CGFloat margin4Subview;
//*子模块边缘间距
@property(nonatomic, assign) CGFloat padding4Subview;
//*背景色
@property(nonatomic, strong) UIColor* sn_backGroundColor;
//*双击事件
@property(nonatomic, assign) BOOL canDoubleTouch;
//*动画
//@property(nonatomic, assign) ScrollerNestingConfigAnima sn_scrollerAnimat;

@end

NS_ASSUME_NONNULL_END
