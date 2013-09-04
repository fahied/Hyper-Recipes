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

#import "HRAPIClient.h"


@implementation Recipes




/**
 *  Get the list of recipes in JSON format from server and mapp json objects to Core-Data Using RESTKIT API
 *
 *  @param completionBlock set bool success=YES if the operation was successful otherwise NO with an error.
 */
+(void)getRecipesWithCompletion:(void (^)(BOOL success, NSError *error))completionBlock
{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"; // google date format /RFC 3339
    
    //TODO: make server responsible to provide the records that have been newly made after a certain date or modified.
    
    // delete all records from core-data
    [Recipe MR_truncateAll];
    [Photo MR_truncateAll];
    
    //prepare to fetch new records from server
    
    RKManagedObjectStore *managedObjectStore = [RKManagedObjectStore defaultStore];
    
    // Create new Recipe mapping
    RKEntityMapping *recipeMapping = [RKEntityMapping mappingForEntityForName:@"Recipe" inManagedObjectStore:managedObjectStore];
    
    [recipeMapping setDateFormatters:[NSArray arrayWithObject:formatter]];
    
    [recipeMapping addAttributeMappingsFromDictionary:@{ @"id" :@"recipeID",@"name" :@"name",@"description":@"recipeDescription",
     @"instructions" :@"instructions",@"favorite" :@"favorite",@"difficulty" :@"difficulty", @"updated_at":@"modifiedDate"}];
    
    // Create new Photo mapping
    RKEntityMapping *photoMapping = [RKEntityMapping mappingForEntityForName:@"Photo" inManagedObjectStore:managedObjectStore];
    
    
    // NOTE: When your source and destination key paths are symmetrical, you can use addAttributesFromArray: as a shortcut instead of addAttributesFromDictionary:
    [photoMapping addAttributeMappingsFromArray:@[@"url"]];

    
    
    [recipeMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"photo" toKeyPath:@"photo" withMapping:photoMapping]];
    
    //pre
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:recipeMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    NSString *requestURL = @"http://hyper-recipes.herokuapp.com/recipes";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    
    RKManagedObjectRequestOperation *managedObjectRequestOperation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    
    managedObjectRequestOperation.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    
    
    [[NSOperationQueue currentQueue] addOperation:managedObjectRequestOperation];
    
    [managedObjectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        completionBlock(YES, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        completionBlock(NO, error);
    }];
}





/**
 *  Create new recipe on server and store ref in coredata
 *
 *  @param recipe          the core-data object corressponding to recipe
 *  @param completionBlock set bool success=YES if the operation was successful otherwise NO with an error.
 */
+(void)postRecipe:(Recipe*)recipe WithCompletion:(void (^)(BOOL success, NSError *error))completionBlock
{
    
    NSDictionary *params = @{
                             @"recipe[name]" : recipe.name,
                             @"recipe[difficulty]" : recipe.difficulty,
                             @"recipe[description]" : recipe.recipeDescription
                             };
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://hyper-recipes.s3.amazonaws.com/uploads/recipe/photo/19/Country_apple_dumplings-1500x1125.jpg"]];
    
    NSURLRequest *postRequest = [[HRAPIClient sharedClient] multipartFormRequestWithMethod:@"POST"
                                                                                      path:@"/recipes"
                                                                                parameters:params
                                                                 constructingBodyWithBlock:^(id formData) {
                                                                     [formData appendPartWithFileData:imageData
                                                                                                 name:@"recipe[photo]"
                                                                                             fileName:@"Country_apple_dumplings-1500x1125.jpg"
                                                                                             mimeType:@"image/jpg"];
                                                                 }];
    
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:postRequest];

    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201) {
            NSLog(@"Created, %@", responseObject);
            completionBlock(YES, nil);
        } else {
            completionBlock(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, error);
    }];
    
    [[HRAPIClient sharedClient] enqueueHTTPRequestOperation:operation];
}





/**
 *  Modify the content of an existing Recipe
 *
 *  @param recipe          the core-data object corressponding to recipe
 *  @param completionBlock set bool success=YES if the operation was successful otherwise NO with an error.
 */
+(void)putRecipe:(Recipe*)recipe WithCompletion:(void (^)(BOOL success, NSError *error))completionBlock
{
    
    NSDictionary *params = @{
                             @"recipe[name]" : recipe.name,
                             @"recipe[difficulty]" : recipe.difficulty,
                             @"recipe[description]" : recipe.recipeDescription
                             };
    
    //formulate route by appenting recipt at the end of the base route for updating recipes
    NSString *route = [@"/recipes/" stringByAppendingFormat:@"%@",/*recipe.recipeID*/@79];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://hyper-recipes.s3.amazonaws.com/uploads/recipe/photo/19/Country_apple_dumplings-1500x1125.jpg"]];
    
    NSURLRequest *putRequest = [[HRAPIClient sharedClient] multipartFormRequestWithMethod:@"PUT"
                                                                                      path:route
                                                                                parameters:params
                                                                 constructingBodyWithBlock:^(id formData) {
                                                                     [formData appendPartWithFileData:imageData
                                                                                                 name:@"recipe[photo]"
                                                                                             fileName:@"Country_apple_dumplings-1500x1125.jpg"
                                                                                             mimeType:@"image/jpg"];
                                                                 }];
    
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:putRequest];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Server give response code 204 if the operation was successfull
        if (operation.response.statusCode == 204) {
            NSLog(@"Created, %@", responseObject);
            completionBlock(YES, nil);
        } else {
            completionBlock(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, error);
    }];
    
    [[HRAPIClient sharedClient] enqueueHTTPRequestOperation:operation];    
    
}






/**
 *  Delete a perticular Recipe by ID
 *
 *  @param recipeID
 *  @param completionBlock set bool success=YES if the operation was successful otherwise NO with an error.
 */
+(void)deleteRecipe:(NSInteger)recipeID WithCompletion:(void (^)(BOOL success, NSError *error))completionBlock
{
        
    //formulate route by appenting recipt at the end of the base route for delete recipes
    NSString *route = [@"/recipes/" stringByAppendingFormat:@"%ld",(long)recipeID];
    
    NSURLRequest *putRequest = [[HRAPIClient sharedClient] requestWithMethod:@"DELETE" path:route parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:putRequest];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Server give response code 204 if the operation was successfull
        if (operation.response.statusCode == 204) {
            NSLog(@"deleted, %@", responseObject);
            completionBlock(YES, nil);
        } else {
            completionBlock(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, error);
    }];
    
    [[HRAPIClient sharedClient] enqueueHTTPRequestOperation:operation];

}









@end
