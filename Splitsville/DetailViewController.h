//
//  DetailViewController.h
//  Splitsville
//
//  Created by Alice Chang on 2/13/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "testtTableViewController.h"

@interface DetailViewController : UIViewController <BookmarkToWebViewDelegate>

@property (strong, nonatomic) NSDictionary *linkItem;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property NSMutableArray *bookmarks; //NSMutableArray of NSDictionaries

- (IBAction)addToBookmarks:(UIBarButtonItem *)sender;
- (void)setDetailItem:(NSDictionary *)newLinkItem;

@end

