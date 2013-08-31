//
//  AppDelegate.m
//  Hyper Recipes
//
//  Created by Fahied on 8/23/13.
//  Copyright (c) 2013 Fahied. All rights reserved.
//

#import "AppDelegate.h"
#import <Reachability/Reachability.h>
#import <CoreData+MagicalRecord.h>

#import "Recipe.h"
#import "Photo.h"

#import "Recipes.h"


#define SERVER_URL @"http://hyper-recipes.herokuapp.com/"


// Use a class extension to expose access to MagicalRecord's private setter methods
@interface NSManagedObjectContext ()
+ (void)MR_setRootSavingContext:(NSManagedObjectContext *)context;
+ (void)MR_setDefaultContext:(NSManagedObjectContext *)moc;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
 
    // Detect the Network availablity using Reachablity Libaray
    [self configureReachablity];
    
    
    //
    // Configure RestKit's Core Data stack
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"HyperRecipes" ofType:@"momd"]];
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"HyperRecipes.sqlite"];
    NSError *error = nil;
    [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    [managedObjectStore createManagedObjectContexts];
    
    
    
    // Configure MagicalRecord to use RestKit's Core Data stack
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:managedObjectStore.persistentStoreCoordinator];
    [NSManagedObjectContext MR_setRootSavingContext:managedObjectStore.persistentStoreManagedObjectContext];
    [NSManagedObjectContext MR_setDefaultContext:managedObjectStore.mainQueueManagedObjectContext];
    
    
    // Initialize RestKit
    _objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:SERVER_URL]];
    
    Photo *photo = [Photo MR_createEntity];
    photo.url = @"https://hyper-recipes.s3.amazonaws.com/uploads/recipe/photo/8/BlueberryCobbler.jpg";
    
    Recipe *recipe = [Recipe MR_createEntity];
    recipe.photo = photo;

    recipe.name = @"Fahied TESTING AFNETWORK POST 1";
    recipe.recipeDescription = @"I, not events, have the power to make me happy or unhappy today. I can choose which it shall be. Yesterday is dead, tomorrow hasn't arrived yet. I have just one day, today, and I'm going to be happy in it.";
    recipe.instructions=  @" Follow the will!";
    recipe.favorite = @1;
    recipe.difficulty = @"1.0";
    
    [Recipes postRecipe:recipe WithCompletion:^(BOOL success, NSError *error)
    {
        if (success) {
            
            NSLog(@"recipe posted to server successfully");
            [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
                
                if (success) {
                    //TODO: refresh view by fetch Core-data items
                }
            }];
        }
        else
        {
            NSLog(@"recipe did not to server successfully");
            //TODO: keep record of un-sent items and post them to server as soon as the internet is avialable
        }
    }];


    [Recipes getRecipesWithCompletion:^(BOOL success, NSError *error)
    {
        NSLog(@"Refresh View");
    }];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma Utility Methods
/**
 *  Configure detection of network stastus using Reachablity open source libaray v3.1.1 
 */
-(void)configureReachablity
{
    
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        _isReachable = YES;
        NSLog(@"INTERNET REACHABLE!");
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        _isReachable= NO;
        NSLog(@"INTERNET UNREACHABLE!");
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}

@end
