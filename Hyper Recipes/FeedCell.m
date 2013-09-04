//
//  FeedCell.m
//  Hyper Recipes
//
//  Created by Fahied ENT on 9/3/13.
//  Copyright (c) 2013 Fahied. All rights reserved.
//

#import "FeedCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation FeedCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor = [UIColor colorWithWhite:0.02f alpha:1.0f];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    self.feedContainer.backgroundColor = [UIColor whiteColor];
    self.bFeedContainer.backgroundColor = [UIColor whiteColor];
    
    UIColor* mainColor = [UIColor colorWithRed:222.0/255 green:59.0/255 blue:47.0/255 alpha:1.0f];
    UIColor* neutralColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    
    NSString* fontName = @"GillSans-Italic";
    NSString* boldFontName = @"GillSans-Bold";
    
    self.nameLabel.textColor =  mainColor;
    self.nameLabel.font =  [UIFont fontWithName:boldFontName size:14.0f];
    
    self.bNameLabel.textColor =  mainColor;
    self.bNameLabel.font =  [UIFont fontWithName:boldFontName size:14.0f];
    
    self.dateLabel.textColor = neutralColor;
    self.dateLabel.font =  [UIFont fontWithName:boldFontName size:14.0f];
    
    self.descriptionLabel.textColor = neutralColor;
    self.descriptionLabel.font = [UIFont fontWithName:fontName size:12.0f];
    
    self.isFavoriteLabel.textColor = neutralColor;
    self.isFavoriteLabel.font =  [UIFont fontWithName:boldFontName size:12.0f];
    
    self.difficultyLabel.textColor = neutralColor;
    self.difficultyLabel.font =  [UIFont fontWithName:boldFontName size:12.0f];
    
    self.feedContainer.layer.cornerRadius = 3.0f;
    self.feedContainer.clipsToBounds = YES;
    
    self.bFeedContainer.layer.cornerRadius = 3.0f;
    self.bFeedContainer.clipsToBounds = YES;
    
    self.picImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.picImageView.clipsToBounds = YES;
    
    //self.selectionStyle = ;
}

@end
