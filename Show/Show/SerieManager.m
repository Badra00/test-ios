//
//  SerieManager.m
//  Show
//
//  Created by Badradine Boulahia on 20/11/2013.
//  Copyright (c) 2013 baboul. All rights reserved.
//

#import "SerieManager.h"
#import "SerieCommunicator.h"
#import "XMLParser.h"

@implementation SerieManager

- (void)searchSeriesForName:(NSString *)name forLanguage:(NSString *)language
{
    [self.communicator searchSeriesForName:name forLanguage:language];
}

#pragma mark - SerieCommunicatorDelegate

- (void)receivedSeriesXML:(NSData *)xmlFile forLanguage:(NSString *)language
{
    parser = [[XMLParser alloc] init];
    parser.language = language;
    
    [parser startParse:xmlFile];
    
    NSArray *series = parser.allItems;
    
    parser = nil;
    
   [self.delegate didReceiveSerie:series];
}

@end
