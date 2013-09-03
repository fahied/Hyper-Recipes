//
//  FeedCell.h
//  Hyper Recipes
//
//  Created by Fahied ENT on 9/3/13.
//  Copyright (c) 2013 Fahied. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *feedContainer;

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@property (weak, nonatomic) IBOutlet UIImageView *favoriteIconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;




@end
