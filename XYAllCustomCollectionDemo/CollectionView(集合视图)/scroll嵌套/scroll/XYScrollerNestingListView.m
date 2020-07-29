//
//  XYScrollerNestingListView.m
//  XYAllCustomCollectionDemo
//
//  Created by 4AM_XIAO on 2020/7/29.
//  Copyright © 2020 4AM_XIAO. All rights reserved.
//

#import "XYScrollerNestingListView.h"

#define XY_SNListViewSubviewTag 1024

@interface XYScrollerNestingListView()<UIScrollViewDelegate>
//*标签视图数组
@property (nonatomic, strong) NSMutableArray<XYScrollerNestingTagView*> *tagsArray;
//*标签总长度
@property (nonatomic, assign) CGFloat tagTotalLength;
//*当前下标
@property (nonatomic, assign) NSInteger currentIndex;
//*上一次的偏移量
@property (nonatomic, assign) CGFloat lastOffsetX;
//*滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;
//*选中下划线
@property (nonatomic, strong) UIView *selectUnderLine;
//*默认下划线
@property (nonatomic, strong) UIView *normalUnderLine;

//*配置文件
@property (nonatomic, strong) XYScrollerNestingConfig *config;

@end

@implementation XYScrollerNestingListView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initProperty];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame configModel:(XYScrollerNestingConfig *)config
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initProperty];
        [self config4NestingView:config];
    }
    return self;
}

#pragma mark - 初始化属性
- (void)initProperty
{
    _tagsArray = [@[] mutableCopy];
    _currentIndex = 0;
}

#pragma mark - 通过config 配置UI
- (void)config4NestingView:(XYScrollerNestingConfig *)config
{
    if (!config) {
        NSLog(@"初始化配置<config>不能为空");
        return;
    }
    if (!config.titlesArray || config.titlesArray.count == 0) {
        NSLog(@"初始化配置 标签数组<titlesArray>不能为空");
        return;
    }
    _config = config;
    [self configUI];
}

- (void)configUI
{
    //*移除所有的标签子模块
    //*初始化scroll
    //*初始化下划线
    //*配置标签子模块
    //*配置下划线
    //*配置scroll内容尺寸 即：标签下方展示的内容
    //*选中内容居中
}

//*移除所有的标签子模块
- (void)removeAllSubview4Super
{
    //去除多余的subview
    if (self.config.titlesArray.count < self.tagsArray.count) {
        [self.tagsArray enumerateObjectsUsingBlock:^(XYScrollerNestingTagView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >= self.config.titlesArray.count) {
                [obj removeFromSuperview];
                obj = nil;
            }
        }];
        [self.tagsArray removeObjectsInRange:NSMakeRange(self.config.titlesArray.count, self.tagsArray.count-self.config.titlesArray.count)];
    }
}

//*初始化scroll
- (void)initScrollView
{
    self.scrollView.backgroundColor = self.config.sn_backGroundColor;
    if (!self.scrollView.superview) {
        [self addSubview:self.scrollView];
    }
}

//*初始化下划线
- (void)initUnderLineView
{
    self.normalUnderLine.frame = CGRectMake(0, self.bounds.size.height-self.config.tagNormalHeight, self.bounds.size.width, self.config.tagNormalHeight);
    self.normalUnderLine.backgroundColor = self.config.tagNormalColor;
    if (!self.normalUnderLine.superview) {
        [self addSubview:self.normalUnderLine];
    }
}

//*配置标签子模块
- (void)configSubview
{
    //初始化总长度
    self.tagTotalLength = 0;
    //配置标签列表
    [self.config.titlesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //初始化frame
        CGFloat x,y,width,height;
        
        //创建标签视图
        XYScrollerNestingTagView *subView;
        if (self.tagsArray.count>idx) {
            subView = self.tagsArray[idx];
        }else{
            subView = [[XYScrollerNestingTagView alloc]init];
        }
        subView.tag = XY_SNListViewSubviewTag+idx;
        
        //配置标签属性
        if (self.currentIndex == idx) {
            //选中
        }else{
            //默认
        }
        //配置frame
        //记录总长度
        //添加到父视图
    }];
}

//*配置下划线
- (void)configUnderLine
{
    
}

//*配置scroll内容尺寸 即：标签下方展示的内容
- (void)congfigScrollContentSize
{
    
}

//*选中内容居中
- (void)selectScrollView2Center
{
    
}

@end
