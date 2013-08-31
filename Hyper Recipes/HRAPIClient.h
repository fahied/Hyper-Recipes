//
//  HRAPIClient.h
//  Hyper Recipes
//
//  Created by Fahied on 8/31/13.
//  Copyright (c) 2013 Fahied. All rights reserved.
//

#import "AFNetworking.h"

@interface HRAPIClient : AFHTTPClient

+ (id)sharedClient;

@end
