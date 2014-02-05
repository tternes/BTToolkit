//
//  NSURL+BTCommonUrls.m
//  BTToolkit
//
//  Created by Thaddeus on 2/4/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "NSURL+BTCommonUrls.h"

@implementation NSURL (BTCommonUrls)

+ (NSURL *)bt_documentsDirectoryUrl
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
