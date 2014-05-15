//
//  BTINIParser.h
//  BTToolkit
//
//  Created by Thaddeus on 3/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTINIParser : NSObject <NSStreamDelegate>

#pragma mark -

/**
 *  Creates the parser object and parses the document at the specified location
 *
 *  @param path Full path (directory and filename) to the ini file on the local filesystem
 *
 *  @return Returns an initialized parser object if the file was successfully parsed, or nil if an error occurs.
 */
- (id)initWithFilePath:(NSString *)path;

#pragma mark -

/**
 *  Indicates if the document includes a keys outside the context of a section (located before the first [section] declaration)
 *
 *  @return YES if there are properties in the global section, otherwise NO
 */
- (BOOL)hasGlobalSection;

/**
 *  The number of sections contained in the document. This does not include the global section, if it exists (which can be determined with hasGlobalSection)
 *
 *  @return Number of sections
 */
- (NSUInteger)numberOfSections;

/**
 *  Provides a list of section names contained in the document. This does not include the global section.
 *
 *  @return An array of NSString objects corresponding to the names of sections in the document.
 */
- (NSArray *)sectionNames;

/**
 *  Determines if the document contains a section matching the specified name
 *
 *  @param section The name of the section
 *
 *  @return YES if the document contains a section matching the specified name; NO if the section is not found
 */
- (BOOL)hasSectionNamed:(NSString *)section;

/**
 *  Called to determine the number of values in a particular section
 *
 *  @param section The name of the section
 *
 *  @return The number of key-value pairs contained in the section
 */
- (NSUInteger)numberOfValuesInSection:(NSString *)section;

/**
 *  Retrieves the value for a specified property name
 *
 *  @param name    Name of the property to be retrieved
 *  @param section Name of the section the property should be returned from. Specify nil if the global section should be used.
 *
 *  @return Returns an object representing the specified property, or nil if an error occurs
 */
- (id)valueForName:(NSString *)name inSection:(NSString *)section;

@end
