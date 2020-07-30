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
    [self removeAllSubview4Super];
    //*初始化scroll
    [self initScrollView];
    //*初始化下划线
    [self initUnderLineView];
    //*配置标签子模块
    [self configSubview];
    //*配置下划线
    [self configUnderLine];
    //*配置scroll内容尺寸 即：标签下方展示的内容
    [self congfigScrollContentSize];
    //*选中内容居中
    [self selectScrollView2Center];
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
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat width = 0;
        CGFloat height = 0;
        
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
            [self configSubviewWithSelect:subView width:width];
        }else{
            //默认
            [self configSubviewWithNormal:subView width:width];
        }
        
        //配置frame
        y = 0.0;
        width = subView.titleLabelWidth + self.config.padding4Subview*2;
        height = self.bounds.size.height;
        
        XYScrollerNestingTagView *lastSubview;
        if (idx>0 && self.tagsArray.count > (idx -1)) {
            lastSubview = self.tagsArray[idx-1];
            x = CGRectGetMaxX(lastSubview.frame) + self.config.margin4Subview;
        }else{
            x = self.config.margin4Subview;
        }
        
        subView.frame = CGRectMake(x, y, width, height);
        
        subView.titleLabel.frame = CGRectMake(self.config.padding4Subview, 0, subView.titleLabelWidth, height);
        //记录总长度
        self.tagTotalLength += width;
        
        //添加到父视图
        if (!subView.superview) {
            [self.scrollView addSubview:subView];
            [self.tagsArray addObject:subView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTouch:)];
            [subView addGestureRecognizer:tap];
        }
    }];
    
    self.tagTotalLength += (self.config.margin4Subview*(self.tagsArray.count+1));
    if (self.tagTotalLength < self.bounds.size.width-0.1) {
        CGFloat defu = self.bounds.size.width - self.tagTotalLength;
        self.config.margin4Subview += defu*1.0/(self.tagsArray.count+1);
        [self configSubview];
    }
}

//*配置下划线
- (void)configUnderLine
{
    if (self.tagsArray.count > self.currentIndex) {
        XYScrollerNestingTagView *selectSubview = self.tagsArray[self.currentIndex];
        if (!self.selectUnderLine.superview) {
            [self.scrollView addSubview:self.selectUnderLine];
        }
        self.selectUnderLine.backgroundColor = self.config.tagSelectColor;
        self.selectUnderLine.frame = CGRectMake(selectSubview.frame.origin.x, self.bounds.size.height-self.config.tagSelectHeight, selectSubview.bounds.size.width, self.config.tagSelectHeight);
    }else{
        if (self.tagsArray.count>0) {
            self.currentIndex = 0;
            [self configUnderLine];
        }else{
            NSLog(@"标签数组为空");
        }
    }
}

//*配置scroll内容尺寸 即：标签下方展示的内容
- (void)congfigScrollContentSize
{
    XYScrollerNestingTagView *finalSubview = self.tagsArray.lastObject;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(finalSubview.frame)+self.config.margin4Subview, CGRectGetHeight(finalSubview.bounds));
}

//*选中内容居中
- (void)selectScrollView2Center
{
    return;
    XYScrollerNestingTagView *subview = self.tagsArray[self.currentIndex];
    CGFloat offsetX = subview.center.x-(CGRectGetWidth(self.bounds)/2.0);
    if (offsetX<0) {
        offsetX = 0;
    }
    
    CGFloat maxOffsetX = self.scrollView.contentSize.width - CGRectGetWidth(self.bounds);
    if (maxOffsetX < 0) {
        maxOffsetX = 0;
    }
    if (maxOffsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark -标签选中设置
- (void)configSubviewWithSelect:(XYScrollerNestingTagView*)subview width:(CGFloat)width
{
    [self configSubviewWithTitle:subview titles:self.config.titlesArray width:width];
    subview.titleLabel.textColor = self.config.titleSelectColor;
}

- (void)configSubviewWithNormal:(XYScrollerNestingTagView*)subview width:(CGFloat)width
{
    [self configSubviewWithTitle:subview titles:self.config.titlesArray width:width];
    subview.titleLabel.textColor = self.config.titleNormalColor;
}

- (BOOL)configSubviewWithTitle:(XYScrollerNestingTagView*)subview titles:(NSArray*)titles width:(CGFloat)width
{
    id obj;
    NSInteger objTag = subview.tag-XY_SNListViewSubviewTag;
    if (titles.count>objTag) {
        obj = titles[objTag];
    }else{
        obj = self.config.titlesArray[objTag];
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *str = (NSString*)obj;
        width = [self getWidthWithText:str font:self.config.titleFont];
        subview.titleLabel.text = str;
        subview.titleLabel.font = self.config.titleFont;
    }else{
        width = 0;
        subview.titleLabel.text = @"";
    }
    subview.titleLabelWidth = width;
    return NO;
}

#pragma mark - private
- (CGFloat)getWidthWithText:(NSString *)text font:(UIFont *)font {
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.width;
}

- (void)moveUnderLineWithOffset:(CGFloat)offset leftSubview:(XYScrollerNestingTagView*)leftSubview rightSubview:(XYScrollerNestingTagView*)rightSubview
{
    //获取两个标签中心点距离
    CGFloat centerDelt = CGRectGetMinX(rightSubview.frame)-CGRectGetMinX(leftSubview.frame);
    //标签宽度差值
    CGFloat widthDelt = CGRectGetWidth(rightSubview.frame)-CGRectGetWidth(leftSubview.frame);
    //移动距离
    CGFloat offsetDelt = offset - self.lastOffsetX;
    //当前下划线偏移量
    CGFloat underLineTransX = offsetDelt*centerDelt/CGRectGetWidth(self.bounds);
    //当前宽度偏移量
    CGFloat underLineWidth = offsetDelt*widthDelt/CGRectGetWidth(self.bounds);
    
    CGRect changeFrame;
    changeFrame.size.width = CGRectGetWidth(self.selectUnderLine.frame)+underLineWidth;
    changeFrame.size.height = CGRectGetHeight(self.selectUnderLine.frame);
    changeFrame.origin.x = CGRectGetMinX(self.selectUnderLine.frame)+underLineTransX;
    changeFrame.origin.y = CGRectGetMinY(self.selectUnderLine.frame);
    self.selectUnderLine.frame = changeFrame;
}

//标签渐变
//- (void)configTitleColorWithOffset:(CGFloat)offset leftSubview:(XYScrollerNestingTagView*)leftSubview rightSubview:(XYScrollerNestingTagView*)rightSubview
//{
//    //获取右侧缩放
//    //获取左侧缩放
//    //
//}

#pragma mark - subview
- (void)select2Index:(NSInteger)index
{
    if (self.tagsArray.count > index) {
        self.currentIndex = index;
        [self configSubview];
        [self configUnderLine];
        [self congfigScrollContentSize];
        [self selectScrollView2Center];
    }else{
        NSLog(@"数组过界");
    }
}

- (void)circlateAllTagView:(void (^)(XYScrollerNestingTagView * _Nonnull, NSInteger))block
{
    [self.tagsArray enumerateObjectsUsingBlock:^(XYScrollerNestingTagView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj,idx);
    }];
}

- (void)config4OffsetX:(CGFloat)offsetX
{
    NSInteger leftIndex = offsetX / CGRectGetWidth(self.bounds);
    XYScrollerNestingTagView *leftSubview = self.tagsArray[leftIndex];
    NSInteger rightIndex = leftIndex+1;
    XYScrollerNestingTagView *rightSubview;
    if (rightIndex < self.tagsArray.count) {
        rightSubview = self.tagsArray[rightIndex];
    }
    
//    if (self.config.type) {
      //偏移下标
    [self moveUnderLineWithOffset:offsetX leftSubview:leftSubview rightSubview:rightSubview];
//    }
    CGFloat tempF = offsetX*1.0/CGRectGetWidth(self.bounds);
    if (tempF == floor(tempF)) {
        [self select2Index:floor(tempF)];
    }
    self.lastOffsetX = offsetX;
}

#pragma mark - touch / action
- (void)tapTouch:(UIGestureRecognizer*)gesture
{
    XYScrollerNestingTagView *subview = (XYScrollerNestingTagView*)gesture.view;
    if (self.currentIndex == subview.tag-XY_SNListViewSubviewTag) {
        return;
    }
    self.currentIndex = subview.tag - XY_SNListViewSubviewTag;
    [self configSubview];
    [self configUnderLine];
    [self congfigScrollContentSize];
    [self selectScrollView2Center];
    if (self.sn_delegate && [self.sn_delegate respondsToSelector:@selector(XYScrollerNestingListView:chooseIndex:)]) {
        [self.sn_delegate XYScrollerNestingListView:self chooseIndex:self.currentIndex];
    }
}

#pragma mark - scroll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark - setter
- (UIView *)normalUnderLine
{
    if (!_normalUnderLine) {
        _normalUnderLine = [[UIView alloc]init];
    }
    return _normalUnderLine;
}

- (UIView *)selectUnderLine
{
    if (!_selectUnderLine) {
        _selectUnderLine = [[UIView alloc]init];
    }
    return _selectUnderLine;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = self.bounds;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

@end
