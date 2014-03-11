//
//  NSString+BTStringExtensions.h
//  BTToolkit
//
//  Created by Thaddeus on 3/9/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BTStringExtensions)

- (NSString *)bt_safeSubstringWithRange:(NSRange)range;

@end
