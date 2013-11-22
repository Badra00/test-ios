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

- (void)searchSeriesForName:(NSString *)urlAsString
{
    
    
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
//    NSLog(@"%@", urlAsString);
    
    [self.currentConnection cancel];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    self.currentConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (connection == self.currentConnection) {
        [self.delegate receivedSeriesXML:data];
    }
}

@end
