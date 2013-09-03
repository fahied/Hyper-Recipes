//
//  FeedsViewController.m
//  Hyper Recipes
//
//  Created by Fahied ENT on 9/3/13.
//  Copyright (c) 2013 Fahied. All rights reserved.
//

#import "FeedsViewController.h"
#import "FeedCell.h"

#import <UIImageView+JMImageCache.h>


#import "Recipe.h"
#import "Photo.h"




@interface FeedsViewController ()
{
    NSArray *recipes;
    UIImage *placeholder;
}

@end

@implementation FeedsViewController

static NSString * const kCellReuseIdentifier = @"feedCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //[self.collectionView registerNib:[UINib nibWithNibName:@"FeedCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifier];
    
    UINib *cellNib = [UINib nibWithNibName:@"FeedCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:kCellReuseIdentifier];
    
    
    [super viewDidLoad];
    
    
    placeholder =[UIImage imageNamed:@"recipe.jpg"];
    
    recipes = [NSArray arrayWithArray:[Recipe MR_findAll]];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(320, 373)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView setAllowsSelection:YES];
}

-(void)refreshFeedViewController
{
    recipes = [NSArray arrayWithArray:[Recipe MR_findAll]];
    [self.collectionView reloadData];
}


// collection view data source methods ////////////////////////////////////

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return recipes.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Recipe *recipe = (Recipe*)[recipes objectAtIndex:indexPath.row];
    FeedCell *cell = (FeedCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    
    cell.descriptionLabel.text = recipe.recipeDescription;
    
    
    cell.nameLabel.text = recipe.name;
    
    if (!(recipe.photo.url == nil))
    {
        NSURL *photoURL = [NSURL URLWithString:recipe.photo.url];
        
        [cell.picImageView setImageWithURL:photoURL placeholderImage:placeholder];
    }
    
      
    return cell;
    
    
}

#pragma mark - delegate methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    printf("Selected View index=%d",indexPath.row);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
