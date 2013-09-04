//
//  UIImage+Colorize.m
//  Selgersystem
//
//  Created by Fahied ENT on 8/13/13.
//  Copyright (c) 2013 JPG Norge. All rights reserved.
//

#import "UIImage+Colorize.h"

@implementation UIImage (Colorize)


- (UIImage *)colorImage:(UIImage *)origImage withColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(origImage.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, (CGRect){ {0,0}, origImage.size} );
    
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, origImage.size.height);
    CGContextConcatCTM(context, flipVertical);
    //pt is the CGPoint that you want as the origin of your image, if the image is not the exact size of the new image. If the sizes are exact it will be {0,0}.
    CGPoint pt = {0,0};
    
    CGContextDrawImage(context, (CGRect){ pt, origImage.size }, [origImage CGImage]);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
