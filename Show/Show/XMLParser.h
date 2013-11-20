//
//  XMLParser.h
//  Show
//
//  Created by Badradine Boulahia on 14/11/2013.
//  Copyright (c) 2013 baboul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serie.h"

@protocol XMLParserDelegate <NSObject>

- (void)finishParshing;

@end

@interface XMLParser : NSObject <NSXMLParserDelegate> {
    //This variable will eventually (once the asynchronous event has completed) hold all the RSSItems in the feed
    NSMutableArray *allItems;
    
    //This variable will be used to build up the data coming back from NSURLConnection
    NSMutableData *receivedData;
    
    //This item will be declared and created each time a new RSS item is encountered in the XML
    Serie *currentItem;
    
    //This stores the value of the XML element that is currently being processed
    NSMutableString *currentValue;
    
    //This allows the creating object to know when parsing has completed
    BOOL parsing;
    
    //This internal variable allows the object to know if the current property is inside an item element
    BOOL inItemElement;
}

@property (nonatomic, readonly) NSMutableArray *allItems;
@property (nonatomic, retain) NSData *receivedData;
@property (nonatomic, retain) Serie *currentItem;
@property (nonatomic, retain) NSMutableString *currentValue;
@property (weak, nonatomic) id<XMLParserDelegate> delegate;
@property BOOL parsing;

//This method kicks off a parse of a URL at a specified string
- (void)startParse:(NSData *)xmlFile;

@end