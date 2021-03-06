//
//  FeedsViewController.m
//  Hyper Recipes
//
//  Created by Fahied ENT on 9/3/13.
//  Copyright (c) 2013 Fahied. All rights reserved.
//

#import "FeedsViewController.h"
#import "FeedCell.h"

#import "NSDate+Helper.h"


#import "AFDownloadRequestOperation.h"


#import "Recipe.h"
#import "Photo.h"

#import "Recipes.h"
#import "AppDelegate.h"


@interface FeedsViewController ()
{
    NSArray *recipes;
    UIImage *placeholder;
    UIImage *addImage;
    NSOperationQueue *queue;
    NSMutableArray *refQueue;
    
    NSMutableDictionary *cachedImages;
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
    
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    
    [super viewDidLoad];
    
    
    queue = [[NSOperationQueue alloc]init];
    queue.name = @"fileDownloader";
    queue.MaxConcurrentOperationCount = 2;
    
    refQueue = [[NSMutableArray alloc]init];
    
    //cache 20 images to load view faster
    cachedImages = [NSMutableDictionary dictionaryWithCapacity:20];
    
    placeholder =[UIImage imageNamed:@"cook"];
    addImage = [UIImage imageNamed:@"add_image"];
    
    recipes = [NSArray arrayWithArray:[Recipe MR_findAll]];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(320, 373)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView setAllowsSelection:YES];
    
    
    
    // add refreshview to update contents
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    
    [self.collectionView addSubview:refresh];
    
    
    //Add UIBarButtonItem  +
    UIBarButtonItem *add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewRecipe)];
    self.navigationItem.rightBarButtonItem = add;
    
    
    _addRecipeVC = [[AddRecipeViewController alloc]init];
    [_addRecipeVC setTitle:@"add recipe"];
}





-(void)refreshFeedViewController
{
    recipes = [NSArray arrayWithArray:[Recipe MR_findAll]];
    [self.collectionView reloadData];
}






-(void)addNewRecipe
{
    [self.navigationController pushViewController:_addRecipeVC animated:YES];
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
    
    //: formate time using Utitlity category NSDATE+Helper    
    cell.dateLabel.text =[NSDate stringForDisplayFromDate:recipe.modifiedDate];
    
    cell.nameLabel.text = recipe.name;
    
    if (recipe.favorite )
    {
        cell.favoriteIconImageView.image = [UIImage imageNamed:@"favorite"];
        cell.isFavoriteLabel.text = @"favorite";
    }
    else
    {
        cell.favoriteIconImageView.image = [UIImage imageNamed:@"nofavorite"];
        cell.isFavoriteLabel.text = @"not favorite";
    }
    
    
    cell.bNameLabel.text = recipe.name;
    
    cell.bRecipeInstructions.text = recipe.instructions;
    
    if (!(recipe.photo.url == nil))
    {
        NSString *imgPath = [self completeLocalPath:[recipe.photo.url lastPathComponent]];
        
        if ([cachedImages objectForKey:imgPath])
        {
            cell.picImageView.image = [cachedImages objectForKey:imgPath];
        }
        else
        {
            if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath])
            {
                NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:imgPath]];
                UIImage *image = [[UIImage alloc] initWithData:imgData];
                cell.picImageView.image = image;
                
                [cachedImages setObject:image forKey:imgPath];
            }
            else
            {
                cell.picImageView.image = placeholder;
                
                [self downloadFile:recipe.photo.url WithCompletion:^(BOOL success, NSError *error)
                 {
                     if (success)
                     {
                         NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:imgPath]];
                         UIImage *image = [[UIImage alloc] initWithData:imgData];
                         cell.picImageView.image = image;
                         
                         [cachedImages setObject:image forKey:imgPath];
                     }
                     
                 }];
            }
        }
        
    }
    else
    {
        cell.picImageView.image = addImage;
    }
    return cell;
    
    
}

#pragma mark - delegate methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    printf("Selected View index=%d",indexPath.row);
    
    FeedCell *cell = (FeedCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    //[[cell.feedContainer subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    if (cell.feedContainer.hidden)
    {
        cell.feedContainer.hidden = NO;
    }
    else
    {
        cell.feedContainer.hidden = YES;
    }
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)refreshView:(UIRefreshControl *)refresh {
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    
    // custom refresh logic would be placed here...
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"MMM d, h:mm a"];
    
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                             
    [formatter stringFromDate:[NSDate date]]];
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
        [Recipes getRecipesWithCompletion:^(BOOL success, NSError *error)
        {
            [self refreshFeedViewController];
            [refresh endRefreshing];
        }];
}









#pragma Download files
-(void)downloadFile:(NSString*)stringURL WithCompletion:(void (^)(BOOL success, NSError *error))completionBlock
{
    
    NSString *targetPath = [self completeLocalPath:[stringURL lastPathComponent]];
    NSURL *remoteURL = [NSURL URLWithString:stringURL];
    
    if ([refQueue containsObject:remoteURL])
    {
        return;
    }
    
    [refQueue addObject:remoteURL];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:remoteURL];
    
        if ([AFDownloadRequestOperation isFileModified:remoteURL forFile:targetPath])
        {
            AFDownloadRequestOperation *downloader = [[AFDownloadRequestOperation alloc]initWithRequest:request targetPath:targetPath shouldResume:YES];
            
            [downloader setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 NSLog(@"File downloaded:  %@",operation.request.URL);
                 completionBlock(YES,nil);
                 [refQueue removeObject:request.URL];
                 //remove ref from queue
             } failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 NSLog(@"Failed to download: %@",operation.request.URL);
                 completionBlock(NO,error);
             }];
            
            [queue addOperation:downloader];
        }
}

-(void)cancleQueueOperataions
{
    [queue cancelAllOperations];
}

#pragma Utility Fuctions
-(NSString*)completeLocalPath:(NSString*)fileName
{
    return [NSHomeDirectory() stringByAppendingPathComponent:[@"Documents/" stringByAppendingString:fileName]];
}


@end
