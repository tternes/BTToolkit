//
//  BTINIParser.h
//  BTToolkit
//
//  Created by Thaddeus on 3/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTINIParser : NSObject <NSStreamDelegate>

#pragma mark - Initialization
- (id)initWithFilePath:(NSString *)path;

#pragma mark - Public

- (BOOL)hasSectionNamed:(NSString *)section;
- (NSUInteger)numberOfValuesInSection:(NSString *)section;

- (id)valueForName:(NSString *)name inSection:(NSString *)section;

@end
