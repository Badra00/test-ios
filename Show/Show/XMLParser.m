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

- (void)startParse:(NSData *)xmlFile
{
//    NSString *strData = [[NSString alloc]initWithData:xmlFile encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", strData);
    
    //Start the XML parser with the delegate pointing at the current object
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlFile];
    [parser setDelegate:self];
    [parser parse];
    
    
    
    parsing = false;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    allItems = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //TVRAGE
    if ([elementName isEqualToString:@"show"])
    {
        currentItem = [[Serie alloc] init];
        inItemElement = true;
    }
    
    //TVDB
    if ([elementName isEqualToString:@"Series"])
    {
        currentItem = [[Serie alloc] init];
        inItemElement = true;
    }
    
    currentValue = nil;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //TVRAGE
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
		currentItem = nil;
		currentValue = nil;
	}
    
    //TVDB
    if ([elementName isEqualToString:@"seriesid"])
	{
		currentItem.idTvDb = currentValue;
	}
    if ([elementName isEqualToString:@"banner"])
	{
		currentItem.bannerName = currentValue;
	}
    if ([elementName isEqualToString:@"Overview"])
	{
		currentItem.synopsys = currentValue;
    }
    if ([elementName isEqualToString:@"SeriesName"])
	{
		currentItem.name = currentValue;
    }
    if ([elementName isEqualToString:@"language"])
	{
		currentItem.language = currentValue;
    }
    if ([elementName isEqualToString:@"Series"])
	{
        if ([currentItem.language isEqualToString:self.language]) {
            [allItems addObject:currentItem];
        }
        currentItem = nil;
        currentValue = nil;
	}
    
}



- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //When we find characters inside an element, we can add it to the current value, which is created if it is not initialized at present
    if (!currentValue)
    {
        currentValue = [[NSMutableString alloc] init];
        [currentValue appendString:string];
    } else if(![string isEqualToString:@"\n"]){
        [currentValue appendString:string];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self.delegate finishParshing];
}

@end
