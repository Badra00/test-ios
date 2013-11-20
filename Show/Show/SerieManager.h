//
//  SerieManager.h
//  Show
//
//  Created by Badradine Boulahia on 20/11/2013.
//  Copyright (c) 2013 baboul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SerieCommunicatorDelegate.h"
#import "SerieManagerDelegate.h"
#import "XMLParser.h"

@class SerieCommunicator;

@interface SerieManager : NSObject<SerieCommunicatorDelegate>
{
    XMLParser *parser;
}

@property (strong, nonatomic) SerieCommunicator *communicator;
@property (weak, nonatomic) id<SerieManagerDelegate> delegate;

- (void)searchSeriesForName:(NSString *)name;

@end
