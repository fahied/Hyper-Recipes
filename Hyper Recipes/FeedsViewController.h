//
//  FeedsViewController.h
//  Hyper Recipes
//
//  Created by Fahied ENT on 9/3/13.
//  Copyright (c) 2013 Fahied. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddRecipeViewController.h"


@interface FeedsViewController :UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) AddRecipeViewController *addRecipeVC;

-(void)refreshFeedViewController;


@end
