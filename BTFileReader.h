//
//  BTFileReader.h
//  BTToolkit
//
//  Created by Thaddeus on 3/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTFileReader : NSObject

@property (nonatomic, assign, readonly) BOOL isEndOfFile;

- (id)initWithFilePath:(NSString *)filePath;
- (NSString *)readLine;

@end
