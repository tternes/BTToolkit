//
//  BTINITests.m
//  BTToolkit
//
//  Created by Thaddeus on 3/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BTINIParser.h"

@interface BTINITests : XCTestCase
@property (nonatomic, strong) BTINIParser *ini;
@property (nonatomic, strong) BTINIParser *invalidPath;
@end

@implementation BTINITests

- (void)setUp
{
    [super setUp];

    NSString *iniFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"ini_parser_test" ofType:@"ini"];
    self.ini = [[BTINIParser alloc] initWithFilePath:iniFilePath];
    
    self.invalidPath = [[BTINIParser alloc] initWithFilePath:@"/something/that/does/not/exist.ini"];
}

- (void)tearDown
{
    [super tearDown];
    self.ini = nil;
    self.invalidPath = nil;
}

- (void)testLoading
{
    XCTAssert(self.ini, @"loaded ini file successfully");
}

- (void)testGlobalCount
{
    XCTAssertEqual([self.ini numberOfValuesInGlobalSection], (NSUInteger)3, @"should be 3 items in global section");
}

- (void)testSectionAccess
{
    NSUInteger numberofSections = [self.ini numberOfSections];
    XCTAssert(numberofSections == 14, @"14 sections in file");
    
    NSArray *sections = [self.ini sectionNames];
    XCTAssert([sections count] == 14, @"14 sections returned in name list");
    
    XCTAssert([self.ini hasGlobalSection], @"has global section");
}

- (void)testDataAccess
{
    // no section
    XCTAssert([[self.ini valueForName:@"a" inSection:nil] isEqualToString:@"b"], @"a=b");
    XCTAssert([[self.ini valueForName:@"c" inSection:nil] isEqualToString:@"d"], @"c=d");
    XCTAssert([[self.ini valueForName:@"e" inSection:nil] isEqualToString:@"f"], @"e=f");
    
    // earth
    XCTAssert([[self.ini valueForName:@"sky" inSection:@"earth"] isEqualToString:@"blue"], @"sky is blue");
    XCTAssert([[self.ini valueForName:@"sun" inSection:@"earth"] isEqualToString:@"yellow"], @"sky is blue");
    XCTAssert([[self.ini valueForName:@"grass" inSection:@"earth"] isEqualToString:@"green"], @"sky is blue");
    
    // pluto
    XCTAssert([[self.ini valueForName:@"sky" inSection:@"pluto"] isEqualToString:@"dark"], @"sky is dark on pluto");
    XCTAssert([[self.ini valueForName:@"sun" inSection:@"pluto"] isEqualToString:@"cold"], @"the sun is cold on pluto");
    XCTAssert([[self.ini valueForName:@"grass" inSection:@"pluto"] isEqualToString:@"none"], @"pluto has no grass");
    
    // car
    XCTAssert([[self.ini valueForName:@"engine" inSection:@"car"] isEqualToString:@"v8"], @"car has a v8");
    XCTAssert([[self.ini valueForName:@"transmission" inSection:@"car"] isEqualToString:@"auto"], @"car is auto");
    XCTAssert([[self.ini valueForName:@"wheels" inSection:@"car"] isEqualToString:@"4"], @"car has four wheels");
    
    XCTAssert([[self.ini valueForName:@"color" inSection:@"first section"] isEqualToString:@"red"], @"color=red in [first section]");
    XCTAssert([[self.ini valueForName:@"space" inSection:@"first section"] isEqualToString:@"blue"], @"space=blue in [first section]");
    
    // crazy section
    XCTAssert([[self.ini valueForName:@"valid" inSection:@"valid section"] isEqualToString:@"invalid"], @"");
    
    XCTAssert([[self.ini valueForName:@"a" inSection:@"inline first"] isEqualToString:@"400"], @"");
    XCTAssert([[self.ini valueForName:@"b" inSection:@"inline second"] isEqualToString:@"800"], @"");
    XCTAssert([[self.ini valueForName:@"a" inSection:@"inline third"] isEqualToString:@"500"], @"");
    
    XCTAssert([[self.ini valueForName:@"a key" inSection:@"spaced out"] isEqualToString:@"a value"], @"");
    XCTAssert([[self.ini valueForName:@"another" inSection:@"spaced out"] isEqualToString:@"1 2 3 4 5 6      9"], @"");
    
    XCTAssert([[self.ini valueForName:@"the" inSection:@"inline third"] isEqualToString:@"end"], @"");
}

- (void)testInvalidFilePath
{
    XCTAssertNil(self.invalidPath, @"invalid path was not loaded");
    XCTAssertEqual([self.invalidPath numberOfSections], (NSUInteger)0, @"no sections in an invalid file");
    XCTAssertNil([self.invalidPath sectionNames], @"no section names in invalid file");
}

- (void)testPropertyEnumeration
{
    __block NSUInteger expectedValueCount = 3;
    XCTAssertEqual([self.ini numberOfValuesInSection:@"car"], expectedValueCount, @"");

    [self.ini enumerateSection:@"car" usingBlock:^(NSString *name, id value, BOOL *stop) {

        NSLog(@"property in car section: %@=%@", name, value);
        XCTAssertNotNil(value, @"value should not be nil");
        expectedValueCount--;
        
    }];
    
    XCTAssertEqual(expectedValueCount, (NSUInteger)0, @"counted all expected properties in cars");
}

- (void)testGlobalSectionEnumeration
{
    __block NSUInteger expectedValueCount = 3;
    XCTAssertEqual([self.ini numberOfValuesInGlobalSection], expectedValueCount, @"should be three valid properties in ini_parser_test.ini");
    
    [self.ini enumerateGlobalSectionUsingBlock:^(NSString *name, id value, BOOL *stop) {
        
        NSLog(@"property in global: %@=%@", name, value);
        XCTAssert(value, @"value should not be nil");
        expectedValueCount--;
        
    }];
    
    XCTAssertEqual(expectedValueCount, (NSUInteger)0, @"counted all global properties");
}

- (void)testPropertyEnumerationStop
{
    __block NSUInteger expectedValueCount = 3;
    XCTAssertEqual([self.ini numberOfValuesInSection:@"car"], expectedValueCount, @"");

    [self.ini enumerateSection:@"car" usingBlock:^(NSString *name, id value, BOOL *stop) {
        
        NSLog(@"property in section: %@=%@", name, value);
        XCTAssert(value, @"value should not be nil");
        expectedValueCount--;
        
        *stop = YES;
        
    }];
    
    XCTAssertEqual(expectedValueCount, (NSUInteger)2, @"should have only enumerated the first property");
}

@end
