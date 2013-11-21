//
//  SerieCommunicator.m
//  Show
//
//  Created by Badradine Boulahia on 20/11/2013.
//  Copyright (c) 2013 baboul. All rights reserved.
//

#import "SerieCommunicator.h"
#import "SerieCommunicatorDelegate.h"

@interface SerieCommunicator () <NSURLConnectionDelegate>

@property (nonatomic, strong, readwrite) NSURLConnection *currentConnection;

@end

@implementation SerieCommunicator

- (void)searchSeriesForName:(NSString *)name
{
    NSString *urlAsString = [@"http://services.tvrage.com/feeds/search.php?show=" stringByAppendingString:name];
    
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
//    NSLog(@"%@", urlAsString);
    
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        [self.delegate receivedSeriesXML:data];
        
    }];
    
}

#pragma mark - NSURLConnectionDelegate


@end
