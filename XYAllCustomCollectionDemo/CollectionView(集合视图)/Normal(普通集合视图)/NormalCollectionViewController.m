//
//  NormalCollectionViewController.m
//  XYAllCustomCollectionDemo
//
//  Created by 4AM_XIAO on 2020/7/15.
//  Copyright © 2020 4AM_XIAO. All rights reserved.
//

#import "NormalCollectionViewController.h"
#import "CurrencyCell.h"

@interface NormalCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView1;
@property (nonatomic, strong) UICollectionView *collectionView2;
@property (nonatomic, strong) UICollectionView *collectionView3;
@end

@implementation NormalCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView1];
    [self.view addSubview:self.collectionView2];
    [self.view addSubview:self.collectionView3];
}

- (UICollectionView *)collectionView1
{
    if (!_collectionView1) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        _collectionView1 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 120) collectionViewLayout:layout];
        _collectionView1.delegate = self;
        _collectionView1.dataSource = self;
        _collectionView1.showsVerticalScrollIndicator = NO;
        _collectionView1.showsHorizontalScrollIndicator = NO;
        [_collectionView1  registerNib:[UINib nibWithNibName:@"CurrencyCell" bundle:nil] forCellWithReuseIdentifier:kCurrencyCellID];
    }
    return _collectionView1;
}

- (UICollectionView *)collectionView2
{
    if (!_collectionView2) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView2 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView1.frame)+10, kScreenWidth, 120) collectionViewLayout:layout];
        _collectionView2.delegate = self;
        _collectionView2.dataSource = self;
        _collectionView2.showsVerticalScrollIndicator = NO;
        _collectionView2.showsHorizontalScrollIndicator = NO;
        _collectionView2.pagingEnabled = YES;
        [_collectionView2  registerNib:[UINib nibWithNibName:@"CurrencyCell" bundle:nil] forCellWithReuseIdentifier:kCurrencyCellID];
    }
    return _collectionView2;
}

- (UICollectionView *)collectionView3
{
    if (!_collectionView3) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 40, 0, 40);
        
        _collectionView3 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView2.frame)+10, kScreenWidth, 120) collectionViewLayout:layout];
        _collectionView3.delegate = self;
        _collectionView3.dataSource = self;
        _collectionView3.showsVerticalScrollIndicator = NO;
        _collectionView3.showsHorizontalScrollIndicator = NO;
//        _collectionView3x.pagingEnabled = YES;
        [_collectionView3  registerNib:[UINib nibWithNibName:@"CurrencyCell" bundle:nil] forCellWithReuseIdentifier:kCurrencyCellID];
    }
    return _collectionView3;
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
        width = 120;
        height = 120;
    }else
    if (collectionView == self.collectionView2) {
        width = kScreenWidth;
        height = 120;
    }else
    if (collectionView == self.collectionView3) {
        width = kScreenWidth-80;
        height = 120;
    }
    return CGSizeMake(width, height);
}

@end
