//
//  MyDataFetchClass.m
//  Splitsville
//
//  Created by Alice Chang on 2/13/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

#import "MyDataFetchClass.h"
#import <UIKit/UIKit.h>

@implementation MyDataFetchClass

// -----------------------------------------------------------------------------
#pragma mark - Initialization
// -----------------------------------------------------------------------------
+ (id)sharedNetworking
{
    static dispatch_once_t pred;
    static MyDataFetchClass *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init
{
    if ( self = [super init] ) {
        
    }
    return self;
}

#pragma - Requests

//Tests whether there is an available network to connect to
//Source: http://ios-blog.co.uk/tutorials/check-if-active-internet-connection-exists-on-ios-device/
- (BOOL) isNetworkAvailable {
    NSURL *sampleURL = [NSURL URLWithString:@"http://google.com"]; //sample url to load to test network availability
    NSData *data = [NSData dataWithContentsOfURL:sampleURL];
    if (data) {
        NSLog(@"Network is available");
        return YES;
    }
    else {
        NSLog(@"Network is not available");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"No Network Available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [alertView show];
        return NO;
    }
}

- (void)getFeedWithURL:(NSString*)url
                 success:(void (^)(NSMutableArray *array, NSError *error))successCompletion
                 failure:(void (^)(void))failureCompletion
{
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url]
                                 completionHandler:^(NSData *data,
                                                     NSURLResponse *response,
                                                     NSError *error) {
                                     
                                     [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                                     
                                     NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                     
                                     //if network is available and response was successful
                                     if ([self isNetworkAvailable] && httpResp.statusCode == 200) {
                                         NSError *jsonError;
                                         
                                         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                                         //NSLog(@"DownloadedData:%@ \n---",dict);
                                         successCompletion([[[dict objectForKey:@"responseData"] objectForKey:@"feed"] objectForKey:@"entries"],nil);
                                         
                                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                     } else {
                                         NSLog(@"Fail Not 200:");
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             if (failureCompletion) failureCompletion();
                                             
                                             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                         });
                                     }
                                 }] resume];
}


@end
