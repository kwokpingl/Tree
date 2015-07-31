//
//  Trie.h
//  Tree
//
//  Created by Scott Riccardelli on 7/22/15.
//  Copyright © 2015 Scott Riccardelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trie : NSObject

@property (strong, nonatomic) NSMutableArray* children;
@property (weak, nonatomic) Trie* parent;
@property (strong, nonatomic) NSString* name;
@property (readonly, nonatomic) BOOL isRoot;

- (instancetype)initWithName:(NSString*)name;
- (void)addChild:(Trie*)child;
- (Trie*)root;

- (NSUInteger)countOfChildrenAtLevel:(NSUInteger)level;
- (NSUInteger)countOfLeaves;

@end