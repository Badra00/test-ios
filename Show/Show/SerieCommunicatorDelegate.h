//
//  SerieCommunicatorDelegate.h
//  Show
//
//  Created by Badradine Boulahia on 20/11/2013.
//  Copyright (c) 2013 baboul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SerieCommunicator.h"

@protocol SerieCommunicatorDelegate

- (void) receivedSeriesXML:(NSData *)xmlFile;

@end