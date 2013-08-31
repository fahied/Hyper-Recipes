//
//  Recipes.h
//  Hyper Recipes
//
//  Created by Fahied on 8/24/13.
//  Copyright (c) 2013 Fahied. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"

@interface Recipes : NSObject

+(void)getRecipesWithCompletion:(void (^)(BOOL success, NSError *error))completionBlock;


+(void)postRecipe:(Recipe*)recipe WithCompletion:(void (^)(BOOL success, NSError *error))completionBlock;


+(void)putRecipe:(Recipe*) recipe;

+(void)deleteRecipe:(NSInteger)recipeID;

@end
