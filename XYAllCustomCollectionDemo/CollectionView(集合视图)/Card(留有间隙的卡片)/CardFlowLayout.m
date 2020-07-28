//
//  CardFlowLayout.m
//  XYAllCustomCollectionDemo
//
//  Created by 4AM_XIAO on 2020/7/16.
//  Copyright © 2020 4AM_XIAO. All rights reserved.
//

#import "CardFlowLayout.h"

@interface CardFlowLayout()<UIScrollViewDelegate>

@property (nonatomic, assign, readwrite) NSInteger currentIndex;
@property (nonatomic, assign, readwrite) NSInteger lastIndex;

@end

@implementation CardFlowLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    CGFloat inset = (self.collectionView.bounds.size.width - self.itemSize.width) /2;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

-(void)cellToCenter
{
    ///最小需要的偏移
    float deagMin = self.collectionView.bounds.size.width/20.0;
    if (self.startX - self.endX >= deagMin) {
        self.lastIndex = self.currentIndex;
        self.currentIndex -= 1;// <<==
    }
    else if (self.endX - self.startX >= deagMin)
    {
        self.lastIndex = self.currentIndex;
        self.currentIndex += 1;// ==>>
    }
    
    NSInteger maxIndex = [self.collectionView numberOfItemsInSection:0]-1;
    self.currentIndex = self.currentIndex<= 0?0:self.currentIndex;
    self.currentIndex = self.currentIndex >= maxIndex? maxIndex:self.currentIndex;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

@end
