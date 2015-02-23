//
//  Bookmark.m
//  Splitsville
//
//  Created by ajchang on 2/23/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

#import "Bookmark.h"

@implementation Bookmark

- (void)encodeWithCoder:(NSCoder*)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.preview forKey:@"preview"];
    [aCoder encodeObject:self.link forKey:@"link"];
}

- (id) initWithCoder:(NSCoder*)aDecoder {
    self = [super init];
    
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.date = [aDecoder decodeObjectForKey:@"date"];
    self.preview = [aDecoder decodeObjectForKey:@"preview"];
    self.link = [aDecoder decodeObjectForKey:@"link"];
    
    return self;
}

@end
