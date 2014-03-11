//
//  NSString+BTStringExtensions.m
//  BTToolkit
//
//  Created by Thaddeus on 3/9/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "NSString+BTStringExtensions.h"

@implementation NSString (BTStringExtensions)

- (NSString *)bt_safeSubstringWithRange:(NSRange)range
{
    if(range.location == NSNotFound)
        return nil;
    
    return [self substringWithRange:range];
}

@end
