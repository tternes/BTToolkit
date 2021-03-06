//
//  BTINIParser.m
//  BTToolkit
//
//  Created by Thaddeus on 3/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "BTINIParser.h"
#import "BTFileReader.h"
#import "NSString+BTStringExtensions.h"
#import "BTARCHelpers.h"

typedef NS_ENUM(NSUInteger, BTINIParserState)
{
    BTINIParserInitial,
    BTINIParserIgnoreLine,
    BTINIParserSection,
    BTINIParserName,
    BTINIParserValue,
};

static NSString *BTGlobalSectionName = @"__BTGlobalSection__"; // TODO: possible collision

@interface BTINIParser ()
@property (nonatomic, retain) BTFileReader *fileReader;
@property (nonatomic, retain) NSMutableDictionary *sections;
@end

#define _SAFE_SECTION_NAME(x) x = (x == nil) ? BTGlobalSectionName : x

@implementation BTINIParser

- (id)initWithFilePath:(NSString *)path
{
    BOOL isDirectory = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] == NO)
    {
        // file does not exist
        BT_RELEASE_SELF;
        return nil;
    }
    
    if(isDirectory)
    {
        BT_RELEASE_SELF;
        return nil;
    }
    
    self = [super init];
    if(self)
    {
        self.fileReader = [[BTFileReader alloc] initWithFilePath:path];
        self.sections = [NSMutableDictionary dictionary];
        [self privateReadFile];
    }
    return self;
}

- (void)dealloc
{
    self.fileReader = nil;
    self.sections = nil;
    BT_SUPER_DEALLOC;
}

#pragma mark - Public

- (NSUInteger)numberOfValuesInGlobalSection
{
    if([self hasGlobalSection])
    {
        return [self numberOfValuesInSection:BTGlobalSectionName];
    }
    
    return 0;
}

- (NSUInteger)numberOfSections
{
    // remove empty section
    NSUInteger count = [self.sections.allKeys count];
    
    // don't include the empty section
    if([self hasGlobalSection])
        count--;

    return count;
}

- (NSArray *)sectionNames
{
    NSMutableArray *sectionNames = [NSMutableArray arrayWithArray:self.sections.allKeys];
    
    if([self hasGlobalSection])
    {
        __block NSUInteger removeIdx = NSNotFound;
        [sectionNames enumerateObjectsUsingBlock:^(NSString *section, NSUInteger idx, BOOL *stop) {

            if([section isEqualToString:BTGlobalSectionName])
            {
                *stop = YES;
                removeIdx = idx;
            }
        }];
        
        if(removeIdx != NSNotFound)
            [sectionNames removeObjectAtIndex:removeIdx];
    }

    return sectionNames;
}

- (BOOL)hasSectionNamed:(NSString *)section
{
    _SAFE_SECTION_NAME(section);
    return ([self.sections valueForKey:section]) ? YES : NO;
}

- (BOOL)hasGlobalSection
{
    return [self hasSectionNamed:BTGlobalSectionName];
}

- (NSUInteger)numberOfValuesInSection:(NSString *)section
{
    _SAFE_SECTION_NAME(section);
    return [[[self.sections valueForKey:section] allKeys] count];
}

- (id)valueForName:(NSString *)name inSection:(NSString *)section
{
    _SAFE_SECTION_NAME(section);
    return [[[self sections] valueForKey:section] valueForKey:name];
}

- (void)enumerateSection:(NSString *)section usingBlock:(void(^)(NSString *name, id value, BOOL *stop))block
{
    NSDictionary *sectionObject = [[self sections] valueForKey:section];
    [[sectionObject allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {

        id valueObject = [sectionObject valueForKey:key];
        block(key, valueObject, stop);
        
    }];
}

- (void)enumerateGlobalSectionUsingBlock:(void(^)(NSString *name, id value, BOOL *stop))block
{
    [self enumerateSection:BTGlobalSectionName usingBlock:block];
}

#pragma mark - Private

- (void)privateReadFile
{
    NSMutableString *currentSectionName = [NSMutableString stringWithString:BTGlobalSectionName];
    
    [self.sections setValue:[NSMutableDictionary dictionary] forKey:currentSectionName];
    while(!self.fileReader.isEndOfFile)
    {
        NSString *line = [self.fileReader readLine];
        
        BTINIParserState state = BTINIParserInitial;
        NSMutableString *currentName = [NSMutableString string];
        NSMutableString *currentValue = [NSMutableString string];
        
        if(line.length == 0)
            continue;

        for(NSUInteger i=0; i < line.length; i++)
        {
            unsigned char c = [line characterAtIndex:i];

            switch(state)
            {
                case BTINIParserInitial:
                    {
                        switch(c)
                        {
                            case ' ':
                            case '\t':
                            case '\n':
                            case '\r':
                                break;
                            case '[':
                                state = BTINIParserSection;
                                currentSectionName = [NSMutableString string];
                                break;
                            case ']':
                                state = BTINIParserInitial;
                                break;
                            case ';':
                                state = BTINIParserIgnoreLine;
                                break;
                                
                            default:
                                if(isprint(c))
                                {
                                    state = BTINIParserName;
                                    [currentName appendFormat:@"%c", c];
                                }
                                break;
                        }
                    }
                    break;
                    
                case BTINIParserSection:
                    switch(c)
                    {
                        case ']':
                            [self setValue:nil forName:nil inSection:currentSectionName];

                            state = BTINIParserInitial;
                            break;
                            
                        default:
                            if(isprint(c))
                            {
                                [currentSectionName appendFormat:@"%c", c];
                            }
                            break;
                    }
                    break;
                case BTINIParserName:
                    switch(c)
                    {
                        case '\n':
                        case '\r':
                            break;
                        case '[':
                            break;
                        case ']':
                            break;
                        case '=':
                            state = BTINIParserValue;
                            break;
                        case ';':
                            break;
                            
                        default:
                            if(isprint(c))
                            {
                                [currentName appendFormat:@"%c", c];
                            }
                            break;
                    }
                    
                    break;
                case BTINIParserValue:
                    switch(c)
                    {
                        case '\n':
                        case '\r':
                            break;
                        case '[':
                            [self setValue:currentValue forName:currentName inSection:currentSectionName];
                            currentName = [NSMutableString string];
                            currentValue = [NSMutableString string];
                            currentSectionName = [NSMutableString string];
                            state = BTINIParserSection;
                            break;
                        case ']':
                            break;
                        case '=':
                            break;
                        case ';':
                            [self setValue:currentValue forName:currentName inSection:currentSectionName];
                            currentName = [NSMutableString string];
                            currentValue = [NSMutableString string];
                            state = BTINIParserIgnoreLine;
                            break;
                            
                        default:
                            if(isprint(c))
                            {
                                [currentValue appendFormat:@"%c", c];
                            }
                            break;
                    }
                    break;
                    
                case BTINIParserIgnoreLine:
                    // nom nom nom
                    break;
            }
        }
        
        if(currentName.length && currentValue.length)
        {
            [self setValue:currentValue forName:currentName inSection:currentSectionName];
        }
    }
}

- (void)setValue:(NSString *)value forName:(NSString *)name inSection:(NSString *)section
{
    // make sure section exists
    if([self.sections valueForKey:section] == nil)
        [self.sections setValue:[NSMutableDictionary dictionary] forKey:section];

    NSString *trimmedName = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedValue = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(trimmedValue && trimmedName)
    {
        // set value
        [[self.sections valueForKey:section] setValue:trimmedValue forKey:trimmedName];
    }
    else if(trimmedName)
    {
        // remove value
        [[self.sections valueForKey:section] removeObjectForKey:trimmedName];
    }

}

@end
