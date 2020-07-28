//
//  CardCollectionViewController.m
//  XYAllCustomCollectionDemo
//
//  Created by 4AM_XIAO on 2020/7/16.
//  Copyright © 2020 4AM_XIAO. All rights reserved.
//

#import "CardCollectionViewController.h"
#import "CurrencyCell.h"
#import "CardFlowLayout.h"

@interface CardCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView1;
@property (nonatomic, strong) CardFlowLayout *layout;

@end

@implementation CardCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView1];
}

- (UICollectionView *)collectionView1
{
    if (!_collectionView1) {
        CardFlowLayout *layout = [[CardFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake(kScreenWidth-80, 120);
        self.layout = layout;
        _collectionView1 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 120) collectionViewLayout:layout];
        _collectionView1.delegate = self;
        _collectionView1.dataSource = self;
        _collectionView1.showsVerticalScrollIndicator = NO;
        _collectionView1.showsHorizontalScrollIndicator = NO;
        _collectionView1.pagingEnabled = YES;
        [_collectionView1  registerNib:[UINib nibWithNibName:@"CurrencyCell" bundle:nil] forCellWithReuseIdentifier:kCurrencyCellID];
    }
    return _collectionView1;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CurrencyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCurrencyCellID forIndexPath:indexPath];
    cell.picIndex = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    CGFloat width = 0;
    if (collectionView == self.collectionView1) {
        width = kScreenWidth-80;
        height = 120;
    }
    return CGSizeMake(width, height);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.layout.startX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.layout.endX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.layout cellToCenter];
    });
}

@end
