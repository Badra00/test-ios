//
//  SerieCommunicator.h
//  Show
//
//  Created by Badradine Boulahia on 20/11/2013.
//  Copyright (c) 2013 baboul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SerieCommunicatorDelegate.h"

@protocol SerieCommunicatorDelegate;

@interface SerieCommunicator : NSObject

@property (weak, nonatomic) id<SerieCommunicatorDelegate> delegate;

- (void)searchSeriesForName:(NSString *)urlAsString forLanguage:(NSString *)language;

@end
