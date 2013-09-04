//
//  UIImage+Colorize.h
//  Selgersystem
//
//  Created by Fahied ENT on 8/13/13.
//  Copyright (c) 2013 JPG Norge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Colorize)


- (UIImage *)colorImage:(UIImage *)origImage withColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color;


@end
