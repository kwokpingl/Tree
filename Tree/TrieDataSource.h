//
//  TrieDataSource.h
//  Tree
//
//  Created by Scott Riccardelli on 7/22/15.
//  Copyright © 2015 Scott Riccardelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Trie;

extern NSString* const supplementalViewKind;
extern NSString* const supplementalReuseIdentifier;
extern NSString* const cellViewKind;
extern NSString* const cellReuseIdentifier;

@interface TrieDataSource : NSObject <UICollectionViewDataSource>
{
   @private
    Trie* _rootTrie;
}

@property (weak, nonatomic) UICollectionView* collectionView;

- (Trie*)rootTrie;
- (NSUInteger)numRowsForClassAndChildrenAtIndexPath:(NSIndexPath*)indexPath;
- (NSArray*)childrenAtIndexPath:(NSIndexPath*)indexPath;

@end
