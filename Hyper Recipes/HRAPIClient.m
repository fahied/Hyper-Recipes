//
//  HRAPIClient.m
//  Hyper Recipes
//
//  Created by Fahied on 8/31/13.
//  Copyright (c) 2013 Fahied. All rights reserved.
//

#import "HRAPIClient.h"

#define BASE_URL @"http://hyper-recipes.herokuapp.com"

@implementation HRAPIClient

+ (id)sharedClient {
    static HRAPIClient *__instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:BASE_URL];
        __instance = [[HRAPIClient alloc] initWithBaseURL:url];
    });
    return __instance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    return self;
}

@end
