//
//  AppDelegate.h
//  Hyper Recipes
//
//  Created by Fahied on 8/23/13.
//  Copyright (c) 2013 Fahied. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  Boolean that keep the status of network either it is online or offline
 */
@property (assign) BOOL isReachable;

@end
