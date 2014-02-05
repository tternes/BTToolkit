//
//  UIView+BTScreenshot.m
//  Napsee
//
//  Created by Thaddeus on 1/29/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "UIView+BTScreenshot.h"

@implementation UIView (BTScreenshot)

- (UIImage *)bt_imageOfView
{
    UIGraphicsBeginImageContext(self.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);

    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
    {
        // iOS 7
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    }
    else
    {
        // iOS 6
        [self.layer renderInContext:c];
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
