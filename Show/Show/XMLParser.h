//
//  XMLParser.h
//  XMLParserTutorial
//
//  Created by Kent Franks on 5/6/11.
//  Copyright 2011 TheAppCodeBlog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serie.h"


@interface XMLParser : NSObject <NSXMLParserDelegate>
{
    
	NSMutableString	*currentNodeContent;
	NSMutableArray  *genres;
	NSXMLParser		*parser;
	NSManagedObject *newSerie;
	
}

@property (readonly, retain) NSMutableArray	*Series;

-(id) loadXMLByURL:(NSString *)urlString;


@end
