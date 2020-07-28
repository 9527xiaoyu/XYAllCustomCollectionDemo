//
//  WaterFlowLayout.m
//  XYAllCustomCollectionDemo
//
//  Created by 4AM_XIAO on 2020/7/23.
//  Copyright © 2020 4AM_XIAO. All rights reserved.
//

#import "WaterFlowLayout.h"

@interface WaterFlowLayout()
@property (nonatomic, strong) NSMutableArray *columnHeights;
@property (nonatomic, strong) NSMutableArray *sectionItemAttrs;
@property (nonatomic, strong) NSMutableArray *allItemsAttrs;
@property (nonatomic, strong) NSMutableArray *unionRects;
@end

@implementation WaterFlowLayout

static const NSInteger unionSize = 20;

static CGFloat XY_FloorCGFloat(CGFloat value) {
  CGFloat scale = [UIScreen mainScreen].scale;
  return floor(value * scale) / scale;
}

#pragma mark - Private
- (NSInteger)columnCountForSection:(NSInteger)section {
  if ([self.customDelegate respondsToSelector:@selector(collectionView:layout:columnCountForSection:)]) {
    return [self.customDelegate collectionView:self.collectionView layout:self columnCountForSection:section];
  } else {
    return self.columnCount;
  }
}

- (void)layoutInit
{
    _columnCount = 2;
}

#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self layoutInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self layoutInit];
    }
    return self;
}

#pragma mark -
- (void)prepareLayout
{
    [super prepareLayout];
    [self.columnHeights removeAllObjects];
    [self.sectionItemAttrs removeAllObjects];
    [self.allItemsAttrs removeAllObjects];
    [self.unionRects removeAllObjects];
    
    NSInteger numberOfsections = [self.collectionView numberOfSections];
    if (numberOfsections == 0) {
        return;
    }
    
    NSInteger idx = 0;
    for (NSInteger section = 0; section<numberOfsections; section++) {
        NSInteger columnCount = [self columnCountForSection:section];
        NSMutableArray *sectionColumnHeights = [NSMutableArray arrayWithCapacity:columnCount];
        
        for (idx = 0; idx < columnCount; idx++) {
            [sectionColumnHeights addObject:@(0)];
        }
        [self.columnHeights addObject:sectionColumnHeights];
    }
    
    CGFloat top = 0;
    UICollectionViewLayoutAttributes *attributes;
    for (NSInteger section = 0; section < numberOfsections; section++) {
        CGFloat minimumInterItemSpacing = self.minimumInteritemSpacing;
        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
          minimumInterItemSpacing = [(id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
        }
        
        CGFloat minimumLineSpacing = self.minimumLineSpacing;
        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
            minimumLineSpacing = [(id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
        }
        
        UIEdgeInsets sectionInset = self.sectionInset;
        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            sectionInset = [(id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        }
        
        CGFloat width = self.collectionView.bounds.size.width - sectionInset.left - sectionInset.right;
        NSInteger columnCount = [self columnCountForSection:section];
        BOOL waterSections = NO;
        if (self.waterSections.count>0) {
            waterSections = [self.waterSections containsObject:@(section)];
        }
        CGFloat itemWidth = waterSections? XY_FloorCGFloat((width-(columnCount-1)*minimumLineSpacing)/columnCount) : XY_FloorCGFloat(width-(columnCount-1)*minimumLineSpacing);
        
        CGFloat headerHeight = 0;
        if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            headerHeight = [(id<UICollectionViewDelegateFlowLayout>)self.collectionView.dataSource collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section].height;
        }
        if (headerHeight>0) {
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            attributes.frame = CGRectMake(0, top, self.collectionView.bounds.size.width, headerHeight);
            [self.allItemsAttrs addObject:attributes];
            top = CGRectGetMaxY(attributes.frame);
        }
        
        top += sectionInset.top;
        for (idx = 0; idx < columnCount; idx++) {
            self.columnHeights[section][idx] = @(top);
        }
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
        for (idx = 0; idx < itemCount; idx++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:section];
            NSInteger columnIndex = [self nextColumnIndexForRow:idx inSection:section];
            CGFloat xOffset = sectionInset.left + (itemWidth+minimumLineSpacing)*columnIndex;
            CGFloat yOffset = [self.columnHeights[section][columnIndex] floatValue];
            CGSize itemSize = [(id<UICollectionViewDelegateFlowLayout>)self.collectionView.dataSource collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
            CGFloat itemHeight = 0;
            if (itemSize.height>0 && itemSize.width>0) {
                itemHeight = XY_FloorCGFloat(itemWidth*itemSize.height/itemSize.width);
            }
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectMake(xOffset, yOffset, itemWidth, itemHeight);
            [itemAttributes addObject:attributes];
            
            [self.allItemsAttrs addObject:attributes];
            self.columnHeights[section][columnIndex] = @(CGRectGetMaxY(attributes.frame) + minimumInterItemSpacing);
        }
        
        [self.sectionItemAttrs addObject:itemAttributes];
        
        CGFloat footerHeight = 0;
        NSInteger columnIndex = [self longestColumnIndexInSection:section];
        if (((NSArray*)self.columnHeights[section]).count > 0) {
            top = [self.columnHeights[section][columnIndex] floatValue] - minimumInterItemSpacing + sectionInset.bottom;
        }
        if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            footerHeight = [(id<UICollectionViewDelegateFlowLayout>)self.collectionView.dataSource collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section].height;
        }
        if (footerHeight>0) {
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            attributes.frame = CGRectMake(0, top, self.collectionView.bounds.size.width, headerHeight);
            [self.allItemsAttrs addObject:attributes];
            top = CGRectGetMaxY(attributes.frame);
        }
        for (idx = 0; idx < columnCount; idx++) {
            self.columnHeights[section][idx] = @(top);
        }
    }
    
    idx = 0;
    NSInteger itemCounts = [self.allItemsAttrs count];
    while (idx < itemCounts) {
      CGRect unionRect = ((UICollectionViewLayoutAttributes *)self.allItemsAttrs[idx]).frame;
      NSInteger rectEndIndex = MIN(idx + unionSize, itemCounts);

      for (NSInteger i = idx + 1; i < rectEndIndex; i++) {
        unionRect = CGRectUnion(unionRect, ((UICollectionViewLayoutAttributes *)self.allItemsAttrs[i]).frame);
      }

      idx = rectEndIndex;

      [self.unionRects addObject:[NSValue valueWithCGRect:unionRect]];
    }
}

- (NSInteger)nextColumnIndexForRow:(NSInteger)item inSection:(NSInteger)section
{
    NSInteger index = 0;
//    NSInteger columnCount = [self columnCountForSection:section];
    index = [self shortestColumnIndexInSection:section];
    return index;;
}

- (NSInteger)shortestColumnIndexInSection:(NSInteger)section
{
    __block NSInteger index = 0;
    __block CGFloat shortestHeight = MAXFLOAT;
    [self.columnHeights[section] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = [obj floatValue];
        if (height < shortestHeight) {
            shortestHeight = height;
            index = idx;
        }
    }];
    return index;
}

- (NSInteger)longestColumnIndexInSection:(NSInteger)section
{
    __block NSInteger index = 0;
    __block CGFloat longestHeight = 0;
    [self.columnHeights[section] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = [obj floatValue];
        if (height > longestHeight) {
            longestHeight = height;
            index = idx;
        }
    }];
    return index;
}

- (CGSize)collectionViewContentSize
{
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {
        return CGSizeZero;
    }
    CGSize contentSize = self.collectionView.bounds.size;
    contentSize.height = [[[self.columnHeights lastObject] firstObject] floatValue];
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= self.sectionItemAttrs.count) {
        return nil;
    }
    if (indexPath.item >= [self.sectionItemAttrs[indexPath.section] count]) {
        return nil;
    }
    return self.sectionItemAttrs[indexPath.section][indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  NSInteger i;
  NSInteger begin = 0, end = self.unionRects.count;
  NSMutableDictionary *cellAttrDict = [NSMutableDictionary dictionary];
  NSMutableDictionary *supplHeaderAttrDict = [NSMutableDictionary dictionary];
  NSMutableDictionary *supplFooterAttrDict = [NSMutableDictionary dictionary];
  NSMutableDictionary *decorAttrDict = [NSMutableDictionary dictionary];

  for (i = 0; i < self.unionRects.count; i++) {
    if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
      begin = i * unionSize;
      break;
    }
  }
  for (i = self.unionRects.count - 1; i >= 0; i--) {
    if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
      end = MIN((i + 1) * unionSize, self.allItemsAttrs.count);
      break;
    }
  }
  for (i = begin; i < end; i++) {
    UICollectionViewLayoutAttributes *attr = self.allItemsAttrs[i];
    if (CGRectIntersectsRect(rect, attr.frame)) {
      switch (attr.representedElementCategory) {
        case UICollectionElementCategorySupplementaryView:
          if ([attr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            supplHeaderAttrDict[attr.indexPath] = attr;
          } else if ([attr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            supplFooterAttrDict[attr.indexPath] = attr;
          }
          break;
        case UICollectionElementCategoryDecorationView:
          decorAttrDict[attr.indexPath] = attr;
          break;
        case UICollectionElementCategoryCell:
          cellAttrDict[attr.indexPath] = attr;
          break;
      }
    }
  }

  NSArray *result = [cellAttrDict.allValues arrayByAddingObjectsFromArray:supplHeaderAttrDict.allValues];
  result = [result arrayByAddingObjectsFromArray:supplFooterAttrDict.allValues];
  result = [result arrayByAddingObjectsFromArray:decorAttrDict.allValues];
  return result;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  CGRect oldBounds = self.collectionView.bounds;
  if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
    return YES;
  }
  return NO;
}

- (NSMutableArray *)columnHeights
{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)sectionItemAttrs
{
    if (!_sectionItemAttrs) {
        _sectionItemAttrs = [NSMutableArray array];
    }
    return _sectionItemAttrs;
}

-(NSMutableArray *)allItemsAttrs
{
    if (!_allItemsAttrs) {
        _allItemsAttrs = [NSMutableArray array];
    }
    return _allItemsAttrs;
}

- (NSMutableArray *)unionRects
{
    if (!_unionRects) {
        _unionRects = [NSMutableArray array];
    }
    return _unionRects;
}

@end
