//
//  BTUIColorTests.m
//  BTToolkit
//
//  Created by Thaddeus on 2/1/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIColor+BTColorExtensions.h"

@interface BTUIColorTests : XCTestCase

@end

@implementation BTUIColorTests

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

- (void)testBlackWithHash
{
    UIColor *black = [UIColor bt_colorWithHexString:@"#000000"];
    XCTAssertEqual([black bt_redComponent], 0.0f, @"red should be 0");
    XCTAssertEqual([black bt_greenComponent], 0.0f, @"green should be 0");
    XCTAssertEqual([black bt_blueComponent], 0.0f, @"blue should be 0");
}

- (void)testBlackNoHash
{
    UIColor *black = [UIColor bt_colorWithHexString:@"000000"];
    XCTAssertEqual([black bt_redComponent], 0.0f, @"red should be 0");
    XCTAssertEqual([black bt_greenComponent], 0.0f, @"green should be 0");
    XCTAssertEqual([black bt_blueComponent], 0.0f, @"blue should be 0");
}

- (void)testWhiteNoHash
{
    UIColor *white = [UIColor bt_colorWithHexString:@"ffffff"];
    XCTAssertEqual([white bt_redComponent], 1.0f, @"red");
    XCTAssertEqual([white bt_greenComponent], 1.0f, @"green");
    XCTAssertEqual([white bt_blueComponent], 1.0f, @"blue");
}

- (void)testShortString
{
    UIColor *black = [UIColor bt_colorWithHexString:@"#00000"];
    XCTAssertNil(black, @"invalid string should return nil");
}

- (void)testABCDEFColorString
{
    UIColor *abcdef = [UIColor bt_colorWithHexString:@"#abcdef"]; //171 205 239
    XCTAssertEqual([abcdef bt_redComponent], 0.67058823529412f, @"red");
    XCTAssertEqual([abcdef bt_greenComponent], 0.80392156862745f, @"green");
    XCTAssertEqual([abcdef bt_blueComponent], 0.93725490196078f, @"blue");
}

- (void)testMixedCaseString
{
    UIColor *abcdef = [UIColor bt_colorWithHexString:@"#aBcDeF"]; //171 205 239
    XCTAssertEqual([abcdef bt_redComponent], 0.67058823529412f, @"red");
    XCTAssertEqual([abcdef bt_greenComponent], 0.80392156862745f, @"green");
    XCTAssertEqual([abcdef bt_blueComponent], 0.93725490196078f, @"blue");
}

- (void)testRedIsRed
{
    UIColor *red = [UIColor redColor];
    XCTAssertEqual([red bt_redComponent], 1.0f, "red float is 1");
    XCTAssertEqual([red bt_blueComponent], 0.0f, "blue is 0");
    XCTAssertEqual([red bt_greenComponent], 0.0f, "green is 0");
}

@end
