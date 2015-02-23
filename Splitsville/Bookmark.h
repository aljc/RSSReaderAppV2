//
//  Bookmark.h
//  Splitsville
//
//  Created by ajchang on 2/23/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bookmark : NSObject <NSCoding>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *preview;
@property (strong, nonatomic) NSString *link;

@end
