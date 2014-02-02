//
//  UIColor+BTColorExtensions.m
//  BTToolkit
//
//  Created by Thaddeus on 2/1/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "UIColor+BTColorExtensions.h"

@implementation UIColor (BTColorExtensions)

+ (UIColor *)bt_colorWithHexString:(NSString *)hexColor
{
    hexColor = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // strip # if it appears
    if ([hexColor hasPrefix:@"#"])
        hexColor = [hexColor substringFromIndex:1];
    
    // string should be 6 characters
    if ([hexColor length] != 6)
    {
        return nil;
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *red = [hexColor substringWithRange:range];
    
    range.location = 2;
    NSString *green = [hexColor substringWithRange:range];
    
    range.location = 4;
    NSString *blue = [hexColor substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:red] scanHexInt:&r];
    [[NSScanner scannerWithString:green] scanHexInt:&g];
    [[NSScanner scannerWithString:blue] scanHexInt:&b];
    
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1.0f];
}

- (CGFloat)bt_redComponent
{
    CGFloat r = 0.0f;
    [self getRed:&r green:nil blue:nil alpha:nil];
    return r;
}

- (CGFloat)bt_greenComponent
{
    CGFloat g = 0.0f;
    [self getRed:nil green:&g blue:nil alpha:nil];
    return g;
}

- (CGFloat)bt_blueComponent
{
    CGFloat b = 0.0f;
    [self getRed:nil green:nil blue:&b alpha:nil];
    return b;
}

@end
