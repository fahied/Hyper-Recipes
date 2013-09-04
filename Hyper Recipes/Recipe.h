//
//  Recipe.h
//  Hyper Recipes
//
//  Created by Fahied ENT on 9/4/13.
//  Copyright (c) 2013 Fahied. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSString * difficulty;
@property (assign) BOOL favorite;
@property (nonatomic, retain) NSString * instructions;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * recipeDescription;
@property (nonatomic, retain) NSNumber * recipeID;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) Photo *photo;

@end
