//
//  ScrollNestViewController.m
//  XYAllCustomCollectionDemo
//
//  Created by 4AM_XIAO on 2020/7/29.
//  Copyright © 2020 4AM_XIAO. All rights reserved.
//

#import "ScrollNestViewController.h"
#import "XYScrollerNestingListView.h"
#import "EvaTableView.h"
#import "EvaCollectionView.h"


@interface ScrollNestViewController ()<UITableViewDelegate, UITableViewDataSource, XYScrollerNestingDelegate>
{
    UIScrollView *subScrollView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XYScrollerNestingListView *levelListView;

@property (nonatomic, strong) EvaTableView *evaTableView;
@property (nonatomic, strong) EvaCollectionView *evaCollectionView;

@end

@implementation ScrollNestViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView isEqual:subScrollView]) {
        self.evaTableView.scrollEnabled = NO;
        self.evaCollectionView.scrollEnabled = NO;
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([scrollView isEqual:subScrollView]) {
        self.evaTableView.scrollEnabled = YES;
        self.evaCollectionView.scrollEnabled = YES;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:self.tableView]) {
        
        NSLog(@"%lf, %lf", scrollView.contentOffset.y, scrollView.contentSize.height-CGRectGetHeight(scrollView.frame));
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height-CGRectGetHeight(scrollView.frame)-0.5)) {
            self.offsetType = OffsetTypeMax;
        } else if (scrollView.contentOffset.y <= 0) {
            self.offsetType = OffsetTypeMin;
        } else {
            self.offsetType = OffsetTypeCenter;
        }

        if (self.levelListView.currentIndex == 0 && _evaCollectionView.offsetType == OffsetTypeCenter) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height-CGRectGetHeight(scrollView.frame));
        }
    
        if (self.levelListView.currentIndex == 1 && _evaTableView.offsetType == OffsetTypeCenter) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height-CGRectGetHeight(scrollView.frame));
        }
        
    } else if ([scrollView isEqual:subScrollView]) {
        
        [self.levelListView config4OffsetX:subScrollView.contentOffset.x];
    }
    

}

#pragma mark *** YBLevelListViewDelegate ***
- (void)XYScrollerNestingListView:(XYScrollerNestingListView *)view chooseIndex:(NSInteger)index
{
    [subScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*index, 0)];
}

#pragma mark *** UITableViewDataSource ***
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 200;
    } else {
        return kHeightOfCell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 44;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nullCell0"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"nullCell0"];
        }
        
        cell.backgroundColor = [UIColor orangeColor];
        
        return cell;
    }
    else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nullCell1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"nullCell1"];

            
            subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeightOfCell)];
            subScrollView.bounces = NO;
            [subScrollView setContentSize:CGSizeMake(SCREEN_WIDTH*2, kHeightOfCell)];
            subScrollView.pagingEnabled = YES;
            subScrollView.showsHorizontalScrollIndicator = NO;
            subScrollView.delegate = self;
            [cell addSubview:subScrollView];
            
            
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
            layout.minimumLineSpacing = 10;
            layout.minimumInteritemSpacing = 10;
            layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
            _evaCollectionView = [[EvaCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeightOfCell) collectionViewLayout:layout];
            _evaCollectionView.backgroundColor = kColorWhite;
            _evaCollectionView.mainVC = self;
            [subScrollView addSubview:_evaCollectionView];
            
            _evaTableView = [[EvaTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, kHeightOfCell) style:UITableViewStylePlain];
            _evaTableView.backgroundColor = kColorWhite;
            _evaTableView.mainVC = self;
            [subScrollView addSubview:_evaTableView];

            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return self.levelListView;
    }
    return nil;
}


#pragma mark *** getter ***
- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (XYScrollerNestingListView *)levelListView {
    if (!_levelListView) {
        
        XYScrollerNestingConfig *model = [[XYScrollerNestingConfig alloc]init];
        model.titlesArray = @[@"图文详情", @"客户评分"];
        model.titleSelectColor = kColorOrange;
        
        _levelListView = [[XYScrollerNestingListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) configModel:model];
        _levelListView.backgroundColor = [UIColor whiteColor];
        _levelListView.sn_delegate = self;
    }
    return _levelListView;
}



@end
