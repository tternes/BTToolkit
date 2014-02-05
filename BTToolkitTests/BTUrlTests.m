//
//  BTUrlTests.m
//  BTToolkit
//
//  Created by Thaddeus on 2/4/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSURL+BTCommonUrls.h"

@interface BTUrlTests : XCTestCase

@end

@implementation BTUrlTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDocumentsDirectory
{
    NSURL *docs = [NSURL bt_documentsDirectoryUrl];
    XCTAssert(docs, @"valid document url");
    XCTAssert([[[docs pathComponents] lastObject] isEqualToString:@"Documents"], @"last component is documents");
    XCTAssert([[docs scheme] isEqualToString:@"file"], @"url is a file");
    XCTAssertNil([docs host], @"no host - localhost");
}

- (void)testWriteInDocumentsDirectory
{
    NSURL *docs = [NSURL bt_documentsDirectoryUrl];
    NSURL *outputUrl = [docs URLByAppendingPathComponent:@"testWriteInDocumentsDirectory.txt"];
    
    NSError *writeError = nil;
    NSString *theDate = [[NSDate date] description];
    [theDate writeToURL:outputUrl atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
    XCTAssertNil(writeError, @"error writing to file");
}

@end
