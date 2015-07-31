//
//  TrieLayout.m
//  Tree
//
//  Created by Scott Riccardelli on 7/22/15.
//  Copyright © 2015 Scott Riccardelli. All rights reserved.
//

#import "TrieLayout.h"
#import "TrieController.h"
#import "TrieSuppView.h"
#import "TrieDataSource.h"
#import "TrieLayoutAttributes.h"

@interface TrieLayout ()
@property (strong, nonatomic) NSMutableDictionary* layoutInformation;
@property (assign, nonatomic) NSInteger maxNumRows;
@property (assign, nonatomic) UIEdgeInsets insets;
@end

@implementation TrieLayout

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.sectionInset = UIEdgeInsetsMake(100.0f, 100.0f, 30.0f, 20.0f);
        self.insets = UIEdgeInsetsMake(50.0f, 50.0f, 0.0f, 0.0f);
        self.minimumInteritemSpacing = 20.0f;
        self.minimumLineSpacing = 10.0f;
        self.itemSize = CGSizeMake(150, 50);

        self.collectionView.scrollEnabled = YES;

        // scroll in x and y
        //    self.collectionView.directionalLockEnabled = NO;
    }
    return self;
}

+ (Class)layoutAttributesClass
{
    return [TrieLayoutAttributes class];
}

- (CGSize)itemSizeAtIndexPath:(NSIndexPath*)indexPath;
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)])
    {
        return [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    return _itemSize;
}

- (UIEdgeInsets)sectionInset:(NSInteger)index
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
    {
        return [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:index];
    }
    return _sectionInset;
}

- (CGFloat)minimumLineSpacing:(NSInteger)section
{
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)])
    {
        return
            [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    return _minimumLineSpacing;
}

- (CGFloat)minimumInteritemSpacing:(NSInteger)section
{
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)])
    {
        return [self.delegate collectionView:self.collectionView
                                              layout:self
            minimumInteritemSpacingForSectionAtIndex:section];
    }
    return _minimumInteritemSpacing;
}

- (void)prepareLayout
{
    [super prepareLayout];

    NSMutableDictionary* layoutInformation = [NSMutableDictionary dictionary];
    NSMutableDictionary* cellInformation = [NSMutableDictionary dictionary];
    NSMutableDictionary* supplementaryInfo = [NSMutableDictionary dictionary];

    NSIndexPath* indexPath;
    NSInteger numSections = [self.collectionView numberOfSections];

    // work left to right building index paths for sections
    for(NSInteger section = 0; section < numSections; section++)
    {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        for(NSInteger item = 0; item < numItems; item++)
        {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            TrieLayoutAttributes* attributes = [self attributesWithChildrenForIndexPath:indexPath];
            [cellInformation setObject:attributes forKey:indexPath];

            UICollectionViewLayoutAttributes* supplementaryAttributes =
                [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:supplementalViewKind
                                                                               withIndexPath:indexPath];
            [supplementaryInfo setObject:supplementaryAttributes forKey:indexPath];
        }
    }

    // work right to left building frame and positions of cells
    for(NSInteger section = numSections - 1; section >= 0; section--)
    {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        NSInteger totalHeight = 0;
        for(NSInteger item = 0; item < numItems; item++)
        {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            TrieLayoutAttributes* attributes = [cellInformation objectForKey:indexPath];
            attributes.frame = [self frameForCellAtIndexPath:indexPath withHeight:totalHeight];
            cellInformation[indexPath] = attributes;
            totalHeight += [self.dataSource numRowsForClassAndChildrenAtIndexPath:indexPath];
        }
        if(section == 0)
        {
            self.maxNumRows = totalHeight;
        }
    }

    // adjust last sections items
    NSInteger numItems = [self.collectionView numberOfItemsInSection:numSections - 2];
    for(NSInteger item = 0; item < numItems; item++)
    {
        indexPath = [NSIndexPath indexPathForItem:item inSection:numSections - 2];
        [self adjustFramesOfChildrenAndConnectorsForClassAtIndexPath:indexPath withCellInformation:cellInformation];
    }

    // cache the cell layouts
    [layoutInformation setObject:cellInformation forKey:cellViewKind];

    [self buildSupplementaryAttributes:cellInformation supplementaryInfo:supplementaryInfo];

    // cache the supplementary info
    [layoutInformation setObject:supplementaryInfo forKey:supplementalViewKind];
    self.layoutInformation = layoutInformation;
}

/*!
 *  builds bounding boxes used to build connectors between cells
 *  @param cellInformation   cell view dictionary
 *  @param supplementaryInfo connector view dictionary
 */
- (void)buildSupplementaryAttributes:(NSMutableDictionary*)cellInformation
                   supplementaryInfo:(NSMutableDictionary*)supplementaryInfo
{
    NSIndexPath* indexPath;
    NSInteger numSections = [self.collectionView numberOfSections];

    // build the supplementary attributes
    for(NSInteger section = 0; section < numSections; section++)
    {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];

        for(NSInteger item = 0; item < numItems; item++)
        {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            TrieLayoutAttributes* attributes = cellInformation[indexPath];
            CGFloat totalHeight = 0;
            for(NSUInteger i = 0; i < attributes.children.count; ++i)
            {
                NSIndexPath* childIndexPath = attributes.children[i];
                UICollectionViewLayoutAttributes* supplementaryAttributes =
                    [supplementaryInfo objectForKey:childIndexPath];
                TrieLayoutAttributes* childAttributes = cellInformation[childIndexPath];

                // adjust z to -1 to put connectors behind cells
                supplementaryAttributes.zIndex = -1;

                CGPoint parentCenter = attributes.center;
                CGPoint childCenter = childAttributes.center;
                CGFloat cellHeight = attributes.size.height;
                CGFloat x, y, w, h;
                if(i == 0)
                {
                    x = parentCenter.x;
                    y = childCenter.y - cellHeight - self.minimumLineSpacing;
                }
                else
                {
                    x = (parentCenter.x + childCenter.x) / 2;
                    y = childCenter.y - (totalHeight * (cellHeight + self.minimumLineSpacing));
                }

                w = childCenter.x - x;
                h = ABS(childCenter.y - y);

                totalHeight += [self.dataSource numRowsForClassAndChildrenAtIndexPath:childIndexPath];

                supplementaryAttributes.frame = CGRectMake(x, y, w, h);
            }
        }
    }

    // cache the supplementary info
    [self.layoutInformation setObject:supplementaryInfo forKey:supplementalViewKind];
}

- (CGRect)frameForCellAtIndexPath:(NSIndexPath*)path withHeight:(CGFloat)height
{
    CGFloat x, y, w, h;

    x = path.section * (self.itemSize.width + self.minimumInteritemSpacing) + self.insets.left;
    y = height * (self.itemSize.height + self.minimumLineSpacing) + self.insets.top;
    w = self.itemSize.width;
    h = self.itemSize.height;

    return CGRectMake(x, y, w, h);
}

- (void)adjustFramesOfChildrenAndConnectorsForClassAtIndexPath:(NSIndexPath*)indexPath
                                           withCellInformation:(NSDictionary*)cellInformation
{
    TrieLayoutAttributes* attributes = cellInformation[indexPath];

    CGFloat y = 0;
    for(NSUInteger i = 0; i < attributes.children.count; ++i)
    {
        NSIndexPath* childIndexPath = attributes.children[i];
        TrieLayoutAttributes* childAttributes = cellInformation[childIndexPath];

        if(i == 0)
        {
            y = attributes.center.y;
        }
        else
        {
            y += (self.itemSize.height + self.minimumLineSpacing);
        }

        childAttributes.center = CGPointMake(childAttributes.center.x, y);
    }
}

/*!
 *  returns an instance of the custom layout attributes, with the children property populated with
 *  the index paths of the children for the item at the current index path
 *  @param indexPath index path of the cell
 *  @return layout attributes
 */
- (TrieLayoutAttributes*)attributesWithChildrenForIndexPath:(NSIndexPath*)indexPath
{
    TrieLayoutAttributes* ret = [TrieLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    ret.indexPath = indexPath;
    NSArray* childTries = [self.dataSource childrenAtIndexPath:indexPath];
    NSMutableArray* childIndexes = [NSMutableArray array];
    NSUInteger childSection = indexPath.section + 1;
    static NSInteger lastSection = -1;
    static NSUInteger i = 0;
    if(lastSection != indexPath.section)
    {
        i = 0;
        lastSection = indexPath.section;
    }
    for(NSUInteger j = 0; j < childTries.count; ++j)
    {
        NSUInteger item = i++;
        childIndexes[j] = [NSIndexPath indexPathForItem:item inSection:childSection];
    }
    ret.children = childIndexes;
    return ret;
}

- (TrieLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return self.layoutInformation[cellViewKind][indexPath];
}

- (CGSize)collectionViewContentSize
{
    return self.collectionView.bounds.size;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* myAttributes = [NSMutableArray arrayWithCapacity:self.layoutInformation.count];
    for(NSString* key in self.layoutInformation)
    {
        NSDictionary* attributesDict = [self.layoutInformation objectForKey:key];
        for(NSIndexPath* key in attributesDict)
        {
            UICollectionViewLayoutAttributes* attributes = [attributesDict objectForKey:key];
            if(CGRectIntersectsRect(rect, attributes.frame))
            {
                [myAttributes addObject:attributes];
            }
        }
    }
    return myAttributes;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForSupplementaryViewOfKind:(NSString*)kind
                                                                    atIndexPath:(NSIndexPath*)indexPath
{
    return self.layoutInformation[supplementalViewKind][indexPath];
}

@end
