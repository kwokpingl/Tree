//
//  TrieCell.m
//  Tree
//
//  Created by Scott Riccardelli on 7/22/15.
//  Copyright © 2015 Scott Riccardelli. All rights reserved.
//

#import "TrieCell.h"

@interface TrieCell ()
@property (nonatomic, strong) UILabel* label;
@end

@implementation TrieCell

- (instancetype)init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if(self)
    {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setupWithFrame:frame];
    }
    return self;
}

- (void)setupWithFrame:(CGRect)frame
{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont boldSystemFontOfSize:14];
    self.label.text = @"text goes here dummy";
    [self.contentView addSubview:self.label];
}

- (void)setLabelString:(NSString*)labelString
{
    self.label.text = labelString;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes*)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];

    self.label.center =
        CGPointMake(CGRectGetWidth(self.contentView.bounds) / 2.0f, CGRectGetHeight(self.contentView.bounds) / 2.0f);
}

@end
