//
//  TrieLayout.h
//  Tree
//
//  Created by Scott Riccardelli on 7/22/15.
//  Copyright © 2015 Scott Riccardelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController, TrieDataSource;

@protocol TrieLayoutDelegate <NSObject>
@required
@optional
- (CGSize)collectionView:(UICollectionView*)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath*)indexPath;

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView*)collectionView
                                 layout:(UICollectionViewLayout*)collectionViewLayout
    minimumLineSpacingForSectionAtIndex:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView*)collectionView
                                      layout:(UICollectionViewLayout*)collectionViewLayout
    minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

@end

@interface TrieLayout : UICollectionViewLayout
{
   @private
    CGSize _itemSize;
    UIEdgeInsets _sectionInset;
    CGFloat _minimumLineSpacing;
    CGFloat _minimumInteritemSpacing;
}

@property (nonatomic) CGSize itemSize;
@property (nonatomic) UIEdgeInsets sectionInset;
@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;

// defaults to CGSizeZero - setting a non-zero size enables cells that
// self-size via -preferredLayoutAttributesFittingAttributes:
@property (nonatomic) CGSize estimatedItemSize;

// default is UICollectionViewScrollDirectionVertical
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic) CGSize headerReferenceSize;
@property (nonatomic) CGSize footerReferenceSize;

@property (weak, nonatomic) ViewController* controller;
@property (nonatomic, assign) NSInteger cellCount;

@property (weak, nonatomic) id<TrieLayoutDelegate> delegate;
@property (weak, nonatomic) TrieDataSource* dataSource;
@end
