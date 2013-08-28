//
//  Photo.h
//  Hyper Recipes
//
//  Created by Fahied on 8/24/13.
//  Copyright (c) 2013 Fahied. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recipe;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Recipe *recipe;

@end
