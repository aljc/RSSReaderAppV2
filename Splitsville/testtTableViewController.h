//
//  testtTableViewController.h
//  Splitsville
//
//  Created by ajchang on 2/16/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

#import <UIKit/UIKit.h>


/* Custom protocol */
@protocol BookmarkToWebViewDelegate <NSObject>

- (void)bookmark:(id)sender sendsURL:(NSURL*)url;

@end

@interface testtTableViewController : UITableViewController

/* Delegate property */
@property (weak, nonatomic) id<BookmarkToWebViewDelegate> delegate;

@end
