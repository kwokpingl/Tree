//
//  Trie.m
//  Tree
//
//  Created by Scott Riccardelli on 7/22/15.
//  Copyright © 2015 Scott Riccardelli. All rights reserved.
//

#import "Trie.h"

@implementation Trie

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _children = [NSMutableArray array];
        _parent = nil;
        _name = @"";
    }
    return self;
}

- (instancetype)initWithName:(NSString*)name
{
    self = [self init];
    if(self)
    {
        _name = name;
    }
    return self;
}

- (void)addChild:(Trie*)child
{
    [self.children addObject:child];
    child.parent = self;
}

- (Trie*)root
{
    if(!self.parent)
    {
        return self;
    }
    return [self.parent root];
}

- (BOOL)isRoot
{
    return !self.parent;
}

- (NSUInteger)countOfChildrenAtLevel:(NSUInteger)level
{
    if(level > 0)
    {
        NSUInteger sum = 0;
        for(Trie* child in self.children)
        {
            sum += [child countOfChildrenAtLevel:(level - 1)];
        }
        return sum;
    }
    return 1;
}

- (NSUInteger)countOfLeaves
{
    if(self.children.count == 0)
    {
        return 1;
    }
    else
    {
        NSUInteger sum = 0;
        for(Trie* child in self.children)
        {
            sum += [child countOfLeaves];
        }
        return sum;
    }
}

@end