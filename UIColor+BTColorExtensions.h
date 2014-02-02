//
//  UIColor+BTColorExtensions.h
//  BTToolkit
//
//  Created by Thaddeus on 2/1/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BTColorExtensions)

+ (UIColor *)bt_colorWithHexString:(NSString *)hexColor;

- (CGFloat)bt_redComponent NS_AVAILABLE_IOS(5_0);
- (CGFloat)bt_greenComponent NS_AVAILABLE_IOS(5_0);
- (CGFloat)bt_blueComponent NS_AVAILABLE_IOS(5_0);

@end
