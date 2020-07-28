//
//  WaterViewController.m
//  XYAllCustomCollectionDemo
//
//  Created by 4AM_XIAO on 2020/7/23.
//  Copyright © 2020 4AM_XIAO. All rights reserved.
//

#import "WaterViewController.h"
#import "NormalCollectionViewCell.h"
#import "CurrencyCell.h"
#import "WaterFlowLayout.h"
#import "PhotoModel.h"

@interface WaterViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView1;
@property (nonatomic, strong) WaterFlowLayout *layout;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation WaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [@[] mutableCopy];
    for (int i = 1; i < 14; i++) {
        NSMutableString *string = [[NSMutableString alloc]init];
        PhotoModel *model = [[PhotoModel alloc]init];
        model.imageName = [NSString stringWithFormat:@"water%d",i];
        model.title = @"标题";
        for (int n = 0; n < i; n++) {
            [string appendString:@"测试测试"];
        }
        model.detail = string;
        [self.dataArray addObject:model];
    }
    [self.view addSubview:self.collectionView1];
}

- (UICollectionView *)collectionView1
{
    if (!_collectionView1) {
        WaterFlowLayout *layout = [[WaterFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.waterSections = @[@(1)];
        self.layout = layout;
        _collectionView1 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
        _collectionView1.backgroundColor = [UIColor whiteColor];
        _collectionView1.delegate = self;
        _collectionView1.dataSource = self;
        _collectionView1.showsVerticalScrollIndicator = NO;
        _collectionView1.showsHorizontalScrollIndicator = NO;
//        _collectionView1.pagingEnabled = YES;
        [_collectionView1  registerClass:[NormalCollectionViewCell class] forCellWithReuseIdentifier:@"kNormalCollectionViewCell"];
        [_collectionView1  registerNib:[UINib nibWithNibName:@"CurrencyCell" bundle:nil] forCellWithReuseIdentifier:kCurrencyCellID];
    }
    return _collectionView1;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CurrencyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCurrencyCellID forIndexPath:indexPath];
        cell.picIndex = [NSString stringWithFormat:@"water%ld",(long)indexPath.row+1];
        return cell;
    }
    NormalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kNormalCollectionViewCell" forIndexPath:indexPath];
    PhotoModel *model = self.dataArray[indexPath.item];
    [cell setModel:model layout:collectionView.collectionViewLayout];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return CGSizeMake(kScreenWidth, 300);
    }
    PhotoModel *model = self.dataArray[indexPath.item];
    return [NormalCollectionViewCell sizeWithModel:model layout:collectionViewLayout];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 20, 0);
    }
    return UIEdgeInsetsZero;
}
@end
