//
//  MyDataFetchClass.m
//  Splitsville
//
//  Created by Alice Chang on 2/13/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

#import "MyDataFetchClass.h"

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

- (void)getFeedWithURL:(NSString*)url
                 success:(void (^)(NSMutableArray *array, NSError *error))successCompletion
                 failure:(void (^)(void))failureCompletion
{
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url]
                                 completionHandler:^(NSData *data,
                                                     NSURLResponse *response,
                                                     NSError *error) {
                                     
                                     // handle response
//                                     NSLog(@"Data:%@",data);
//                                     NSLog(@"Response:%@",response);
//                                     NSLog(@"Error:%@",[error localizedDescription]);
                                    
                                     NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                     
                                     if (httpResp.statusCode == 200) {
                                         NSError *jsonError;
                                         
                                         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                                         //NSLog(@"DownloadedData:%@ \n---",dict);
                                         successCompletion([[[dict objectForKey:@"responseData"] objectForKey:@"feed"] objectForKey:@"entries"],nil);
                                     } else {
                                         NSLog(@"Fail Not 200:");
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             if (failureCompletion) failureCompletion();
                                         });
                                     }
                                 }] resume];
}


@end
