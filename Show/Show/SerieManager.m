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

- (void)searchSeriesForName:(NSString *)name
{
    [self.communicator searchSeriesForName:name];
}

#pragma mark - SerieCommunicatorDelegate

- (void)receivedSeriesXML:(NSData *)xmlFile
{
    parser = [[XMLParser alloc] init];
    
    [parser startParse:xmlFile];
    
    NSArray *series = parser.allItems;
    
    parser = nil;
    
   [self.delegate didReceiveSerie:series];
}

@end
