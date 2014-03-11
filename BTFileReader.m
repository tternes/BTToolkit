//
//  BTFileReader.m
//  BTToolkit
//
//  Created by Thaddeus on 3/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "BTFileReader.h"
#import "BTARCHelpers.h"

@interface BTFileReader ()
@property (nonatomic, retain) NSFileHandle *fileHandle;
@property (nonatomic, assign) BOOL isEndOfFile;
@end

@implementation BTFileReader

- (id)initWithFilePath:(NSString *)filePath
{
    self = [super init];
    if(self)
    {
        self.isEndOfFile = NO;
        self.fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    }
    
    return self;
}

- (void)dealloc
{
    self.fileHandle = nil;
    BT_SUPER_DEALLOC;
}

- (NSString *)readLine
{
    if(!self.isEndOfFile)
    {
        NSMutableData *working = [NSMutableData data];
        for(;;)
        {
            NSData *byte = [self.fileHandle readDataOfLength:1];
            if(byte.length == 0)
            {
                self.isEndOfFile = YES;
                break;
            }

            const char *bit = (const char *)[byte bytes];
            if(bit[0] =='\n')
                break;
            else
                [working appendData:byte];
        }
        
        return [[NSString alloc] initWithData:working encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

@end
