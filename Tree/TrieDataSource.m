//
//  TrieDataSource.m
//  Tree
//
//  Created by Scott Riccardelli on 7/22/15.
//  Copyright © 2015 Scott Riccardelli. All rights reserved.
//

#import "TrieDataSource.h"
#import "Trie.h"
#import "TrieSuppView.h"
#import "TrieCell.h"

NSString* const supplementalViewKind = @"trieSupplementalKind";
NSString* const supplementalReuseIdentifier = @"treeSupplementalId";
NSString* const cellViewKind = @"trieCellKind";
NSString* const cellReuseIdentifier = @"trieCellId";

@interface TrieDataSource ()
@property (strong, nonatomic) Trie* rootTrie;
@property (strong, nonatomic) NSMutableDictionary* indexPathToTrieInformation;
@end

@implementation TrieDataSource

- (instancetype)init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

- (void)setCollectionView:(UICollectionView* _Nullable)collectionView
{
    _collectionView = collectionView;
    [_collectionView registerClass:[TrieCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
    [_collectionView registerClass:[TrieSuppView class]
        forSupplementaryViewOfKind:supplementalViewKind
               withReuseIdentifier:supplementalReuseIdentifier];
}

- (Trie*)trie
{
    if(!_rootTrie)
    {
        _rootTrie = [[Trie alloc] initWithName:@"NSObject"];
        Trie* tmpTrie;
        [_rootTrie addChild:[[Trie alloc] initWithName:@"NSLayoutConstraint"]];
        [_rootTrie addChild:[[Trie alloc] initWithName:@"NSLayoutManager"]];
        tmpTrie = [[Trie alloc] initWithName:@"NSParagraphStyle"];
        [tmpTrie addChild:[[Trie alloc] initWithName:@"NSMutableParagraphStyle"]];
        [_rootTrie addChild:tmpTrie];
        [_rootTrie addChild:[[Trie alloc] initWithName:@"UIAcceleration"]];
        [_rootTrie addChild:[[Trie alloc] initWithName:@"UIAccelerometer"]];
        [_rootTrie addChild:[[Trie alloc] initWithName:@"UIAccesibilityElement"]];
        tmpTrie = [[Trie alloc] initWithName:@"UIBarItem"];
        [tmpTrie addChild:[[Trie alloc] initWithName:@"UIBarButtonItem"]];
        [tmpTrie addChild:[[Trie alloc] initWithName:@"UITabBarItem"]];
        [_rootTrie addChild:tmpTrie];
        [_rootTrie addChild:[[Trie alloc] initWithName:@"UIActivity"]];
        [_rootTrie addChild:[[Trie alloc] initWithName:@"UIBezierPath"]];
    }
    return _rootTrie;
}

- (NSDictionary*)indexPathToTrieInformation
{
    if(!_indexPathToTrieInformation)
    {
        _indexPathToTrieInformation = [NSMutableDictionary dictionary];
        NSMutableArray* currentSectionQueue = [NSMutableArray array];
        [currentSectionQueue addObject:_rootTrie];
        NSMutableArray* nextSectionQueue = [NSMutableArray array];
        NSUInteger section = 0;
        NSUInteger item = 0;
        Trie* current = nil;
        while(currentSectionQueue.count > 0 || nextSectionQueue.count > 0)
        {
            current = (Trie*)[currentSectionQueue objectAtIndex:0];
            [currentSectionQueue removeObjectAtIndex:0];
            NSIndexPath* path = [NSIndexPath indexPathForItem:item++ inSection:section];
            [_indexPathToTrieInformation setObject:current forKey:path];
            for(Trie* child in current.children)
            {
                [nextSectionQueue addObject:child];
            }
            if(currentSectionQueue.count == 0)
            {
                currentSectionQueue = nextSectionQueue;
                nextSectionQueue = [NSMutableArray array];
                ++section;
                item = 0;
            }
        }
    }
    return _indexPathToTrieInformation;
}

- (nonnull UICollectionViewCell*)collectionView:(nonnull UICollectionView*)collectionView
                         cellForItemAtIndexPath:(nonnull NSIndexPath*)indexPath
{
    TrieCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];

    cell.backgroundColor = [UIColor blueColor];

    NSString* text = @"";
    Trie* trie = [self trieAtIndexPath:indexPath];
    text = trie.name;
    [cell setLabelString:text];

    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger cnt = [self countOfChildrenAtLevel:section];
    return cnt;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    NSInteger depth = 0;
    while(YES)
    {
        if([self.trie countOfChildrenAtLevel:depth])
        {
            depth++;
        }
        else
        {
            break;
        }
    }
    return depth;
}

- (NSUInteger)countOfChildrenAtLevel:(NSUInteger)level
{
    return [self.rootTrie countOfChildrenAtLevel:level];
}

/*!
 *  After putting the adjusted attributes back in the dictionary, the totalHeight variable
 *  is adjusted to reflect where the next item’s frame needs to be. This is where the code takes
 *  advantage of the custom protocol. Whatever object implements that protocol needs to implement
 *  the numRowsForClassAndChildrenAtIndexPath: method, which returns how many rows each class
 *  needs to occupy given how many children it has.
 *  @return row count
 */
- (NSUInteger)numRowsForClassAndChildrenAtIndexPath:(NSIndexPath*)indexPath
{
    if(!indexPath || indexPath.length < 1)
    {
        return 0;
    }

    Trie* trie = [self trieAtIndexPath:indexPath];

    return [trie countOfLeaves];
}

- (Trie*)trieAtIndexPath:(NSIndexPath*)indexPath
{
    return [self.indexPathToTrieInformation objectForKey:indexPath];
}

- (NSArray*)childrenAtIndexPath:(NSIndexPath*)indexPath
{
    if(!indexPath || indexPath.length < 1)
    {
        return @[];
    }

    Trie* trie = [self trieAtIndexPath:indexPath];
    return trie.children;
}

- (BOOL)firstChild:(NSIndexPath*)indexPath
{
    Trie* trie = [self trieAtIndexPath:indexPath];
    return trie.parent.children[0] == trie;
}

- (nonnull UICollectionReusableView*)collectionView:(nonnull UICollectionView*)collectionView
                  viewForSupplementaryElementOfKind:(nonnull NSString*)kind
                                        atIndexPath:(nonnull NSIndexPath*)indexPath
{
    TrieSuppView* view = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                 withReuseIdentifier:supplementalReuseIdentifier
                                                                        forIndexPath:indexPath];
    if([self firstChild:indexPath])
    {
        [view.controlPoints
            addObject:[NSValue valueWithCGPoint:CGPointMake(view.bounds.origin.x,
                                                            view.bounds.origin.y + view.bounds.size.height)]];
        [view.controlPoints
            addObject:[NSValue valueWithCGPoint:CGPointMake(view.bounds.origin.x + view.bounds.size.width,
                                                            view.bounds.origin.y + view.bounds.size.height)]];
    }
    else
    {
        [view.controlPoints
            addObject:[NSValue valueWithCGPoint:CGPointMake(view.bounds.origin.x, view.bounds.origin.y)]];
        [view.controlPoints
            addObject:[NSValue valueWithCGPoint:CGPointMake(view.bounds.origin.x,
                                                            view.bounds.origin.y + view.bounds.size.height)]];
        [view.controlPoints
            addObject:[NSValue valueWithCGPoint:CGPointMake(view.bounds.origin.x + view.bounds.size.width,
                                                            view.bounds.origin.y + view.bounds.size.height)]];
    }
    return view;
}
@end
