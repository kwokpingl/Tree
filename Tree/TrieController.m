//
//  TrieController.m
//  Tree
//
//  Created by Scott Riccardelli on 7/22/15.
//  Copyright © 2015 Scott Riccardelli. All rights reserved.
//

#import "TrieController.h"
#import "TrieLayout.h"
#import "TrieDataSource.h"

@interface TrieController () <UICollectionViewDelegate>
@property (strong, nonatomic) TrieLayout* layout;
@property (strong, nonatomic) TrieDataSource* trieDataSource;
@end

@implementation TrieController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if(self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    _trieDataSource = [[TrieDataSource alloc] init];
    _trieDataSource.collectionView = self.collectionView;
    self.collectionView.dataSource = _trieDataSource;
    self.collectionView.delegate = self;
    _layout = [[TrieLayout alloc] init];
    _layout.dataSource = _trieDataSource;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView setCollectionViewLayout:_layout animated:NO];
    [_layout invalidateLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
