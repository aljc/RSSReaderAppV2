//
//  MyDataFetchClass.h
//  Splitsville
//
//  Created by Alice Chang on 2/13/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDataFetchClass : NSObject

+ (id)sharedSharedNetworking;
- (void)getFeedWithURL:(NSString*)url
               success:(void (^)(NSMutableArray *array, NSError *error))successCompletion
               failure:(void (^)(void))failureCompletion;


@end
