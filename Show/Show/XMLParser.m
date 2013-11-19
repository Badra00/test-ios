//
//  XMLParser.m
//  Show
//
//  Created by Badradine Boulahia on 14/11/2013.
//  Copyright (c) 2013 baboul. All rights reserved.
//

#import "XMLParser.h"
#import "Serie.h"

#define API_KEY @""

@implementation XMLParser
@synthesize currentItem;
@synthesize allItems;
@synthesize currentValue;
@synthesize parsing;
@synthesize receivedData;

- (void)startParse:(NSString *)url scope:(NSString*)scope
{
    //Set the status to parsing
    parsing = true;
    
    //Initialise the receivedData object
    receivedData = [[NSMutableData alloc] init];
    
    //Create the connection with the string URL and kick it off
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] delegate:self];
    [urlConnection start];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //Reset the data as this could be fired if a redirect or other response occurs
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //Append the received data each time this is called
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //Start the XML parser with the delegate pointing at the current object
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:receivedData];
    [parser setDelegate:self];
    [parser parse];
    
    parsing = false;
}

//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //Clear allItems each time we kick off a new parse
    [allItems removeAllObjects];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //If we find an item element, then ensure that the object knows we are inside it, and that the new item is allocated
    if ([elementName isEqualToString:@"show"])
    {
        currentItem = [[Serie alloc] init];
        inItemElement = true;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"showid"])
	{
		currentItem.idTvRage = currentValue;
	}
	if ([elementName isEqualToString:@"started"])
	{
        currentItem.startYear = currentValue;
	}
    if ([elementName isEqualToString:@"status"])
	{
        currentItem.status = currentValue;
	}
    if ([elementName isEqualToString:@"name"])
	{
		currentItem.name = currentValue;
	}
	if ([elementName isEqualToString:@"show"])
	{
        [allItems addObject:currentItem];
        [currentItem release];
		currentItem = nil;
		[currentValue release];
		currentValue = nil;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //When we find characters inside an element, we can add it to the current value, which is created if it is not initialized at present
    if (!currentValue)
    {
        currentValue = [[NSMutableString alloc] init];
    }
    [currentValue appendString:string];
}

/*
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
 */

@end
