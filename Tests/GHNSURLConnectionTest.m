//
//  GHNSURLConnectionTest.m
//  GHUnitIPhone
//
//  Created by Gabriel Handford on 11/14/10.
//  Copyright 2010. All rights reserved.
//

#import "GHAsyncTestCase.h"

@interface GHNSURLConnectionTest : GHAsyncTestCase { }
@end

@implementation GHNSURLConnectionTest

- (void)testURLConnection {
  
  // Call prepare to setup the asynchronous action.
  // This helps in cases where the action is synchronous and the
  // action occurs before the wait is actually called.
  [self prepare];
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]];
  NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
  
  // Wait until notify called for timeout (seconds); If notify is not called with kGHUnitWaitStatusSuccess then
  // we will throw an error.
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
  
  [connection release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  GHTestLog(@"%@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  // Notify of success, specifying the method where wait is called.
  // This prevents stray notifies from affecting other tests.
  [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testURLConnection)];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  // Notify of connection failure
  [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testURLConnection)];
}

@end
