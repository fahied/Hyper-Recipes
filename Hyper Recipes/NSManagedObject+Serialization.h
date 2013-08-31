//
//  NSManagedObject+Serialization.h
//  Hyper Recipes
//
//  Created by Fahied on 8/31/13.
//  Copyright (c) 2013 Fahied. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Serialization)

- (NSDictionary*) toDictionary;
-(NSString*)toJSONstring;

- (void) populateFromDictionary:(NSDictionary*)dict;

+ (NSManagedObject*) createManagedObjectFromDictionary:(NSDictionary*)dict
                                             inContext:(NSManagedObjectContext*)context;

@end
