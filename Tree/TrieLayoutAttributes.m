//
//  TrieLayoutAttributes.m
//  Tree
//
//  Created by Scott Riccardelli on 7/22/15.
//  Copyright © 2015 Scott Riccardelli. All rights reserved.
//

#import "TrieLayoutAttributes.h"

@implementation TrieLayoutAttributes

// Apple claims the following method is necessary
// source:
// https://developer.apple.com/library/ios/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/AWorkedExample/AWorkedExample.html#//apple_ref/doc/uid/TP40012334-CH8-SW6
/*
- (BOOL)isEqual:(id)object
{
    TrieLayoutAttributes* otherAttributes = (TrieLayoutAttributes*)object;
    if([self.children isEqualToArray:otherAttributes.children])
    {
        return [super isEqual:object];
    }
    return NO;
}
 */

@end
