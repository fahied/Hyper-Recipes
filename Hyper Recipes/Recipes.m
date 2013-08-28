//
//  Recipes.m
//  Hyper Recipes
//
//  Created by Fahied on 8/24/13.
//  Copyright (c) 2013 Fahied. All rights reserved.
//

#import "Recipes.h"
#import "Recipe.h"
#import "Photo.h"
#import <CoreData+MagicalRecord.h>
#import <RestKit/RestKit.h>

@implementation Recipes


+(BOOL)didDownloadAllRecipes
{
    [Recipe MR_truncateAll];
    
    
    RKManagedObjectStore *managedObjectStore = [RKManagedObjectStore defaultStore];
    
    RKEntityMapping *recipeMapping = [RKEntityMapping mappingForEntityForName:@"Recipe" inManagedObjectStore:managedObjectStore];
    
    [recipeMapping addAttributeMappingsFromDictionary:@{ @"id" :@"recipeID",@"name" :@"name",@"description":@"recipeDescription",
     @"instructions" :@"instructions",@"favorite" :@"favorite",@"difficulty" :@"difficulty"}];
    
    // Create our new Person mapping
    //RKObjectMapping* personMapping = [RKObjectMapping mappingForClass:[Person class] ];
    RKEntityMapping *photoMapping = [RKEntityMapping mappingForEntityForName:@"Photo" inManagedObjectStore:managedObjectStore];
    
    
    // NOTE: When your source and destination key paths are symmetrical, you can use addAttributesFromArray: as a shortcut instead of addAttributesFromDictionary:
    [photoMapping addAttributeMappingsFromArray:@[@"url"]];

    
    
    [recipeMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"photo" toKeyPath:@"photo" withMapping:photoMapping]];
    
    
    
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
//    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:photoMapping pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//    
//    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:recipeMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    
    
    NSString *requestURL = @"http://hyper-recipes.herokuapp.com/recipes";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    
    RKManagedObjectRequestOperation *managedObjectRequestOperation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    
    managedObjectRequestOperation.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    
    
    [[NSOperationQueue currentQueue] addOperation:managedObjectRequestOperation];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Vent!" message:@"Applikasjonen oppdateres" delegate:nil cancelButtonTitle:@"Vent...!" otherButtonTitles: nil];
    [alert show];
    [managedObjectRequestOperation setCompletionBlock:^{
        NSLog(@"MyOp completed");
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }];
    
    return YES;
}

@end
