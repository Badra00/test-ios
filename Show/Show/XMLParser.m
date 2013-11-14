//
//  XMLParser.m
//  XMLParserTutorial
//
//  Created by Kent Franks on 5/6/11.
//  Copyright 2011 TheAppCodeBlog. All rights reserved.
//

#import "XMLParser.h"
#import "Serie.h"

@implementation XMLParser
@synthesize Series;

-(id) loadXMLByURL:(NSString *)urlString
{
	NSURL *url		= [NSURL URLWithString:urlString];
	NSData	*data   = [[NSData alloc] initWithContentsOfURL:url];
	parser			= [[NSXMLParser alloc] initWithData:data];
	parser.delegate = self;
	[parser parse];
	return self;
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
	if ([elementname isEqualToString:@"show"])
	{
		// Create a new device
        newSerie = [NSEntityDescription insertNewObjectForEntityForName:@"Serie" inManagedObjectContext:context];
	}
    if ([elementname isEqualToString:@"genres"])
	{
		genres = [NSMutableArray alloc];
	}
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementname isEqualToString:@"showid"])
	{
		[newSerie setValue:currentNodeContent forKey:@"idTvRage"];
	}
	if ([elementname isEqualToString:@"started"])
	{
        [newSerie setValue:currentNodeContent forKey:@"startYear"];
	}
    if ([elementname isEqualToString:@"status"])
	{
        [newSerie setValue:currentNodeContent forKey:@"status"];
	}
    if ([elementname isEqualToString:@"genre"])
	{
		[genres addObject:currentNodeContent];
	}
    if ([elementname isEqualToString:@"genres"])
	{
        [newSerie setValue:genres forKey:@"genre"];
	}
	if ([elementname isEqualToString:@"show"])
	{
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
		[newSerie release];
		newSerie = nil;
		[currentNodeContent release];
		currentNodeContent = nil;
	}
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	currentNodeContent = (NSMutableString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void) dealloc
{
	[parser release];
	[super dealloc];
}

@end
