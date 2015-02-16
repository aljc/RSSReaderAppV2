//
//  DetailViewController.m
//  Splitsville
//
//  Created by Alice Chang on 2/13/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property NSArray* bookmarksCopyFromDefaults;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

//for testing purposes - reset user defaults
//Source: http://stackoverflow.com/questions/6358737/nsuserdefaults-reset
- (void)resetNSUserDefaults {
    NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (NSString *key in [defaultsDictionary allKeys]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)addToBookmarks:(UIBarButtonItem *)sender {
    
    if (self.linkItem == nil) {
        NSLog(@"You haven't selected an article yet");
        return;
    }
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _bookmarksCopyFromDefaults = [defaults arrayForKey:@"bookmarks"];
    
    //add objects already stored in bookmarks
    if (_bookmarksCopyFromDefaults != nil)
        [self.bookmarks addObjectsFromArray:_bookmarksCopyFromDefaults];
    
    //append latest article to bookmarks array
    [self.bookmarks addObject:self.linkItem];
    
    //replace bookmarks user defaults field with new consolidated array
    [defaults setObject:self.bookmarks forKey:@"bookmarks"];
    [defaults synchronize];
    
    NSLog(@"NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
    return;
}

//can't just use the default setter because we also want to update the view
//(call configureView) after we set it
- (void)setDetailItem:(NSDictionary *)newLinkItem { //**must be named setDetailItem to override existing function
    if (self.linkItem != newLinkItem) { //if view isn't already onscreen
        self.linkItem = newLinkItem;
        [self configureView];
        NSLog(@"setter override");
    }
}

//custom method to update the onscreen view
- (void)configureView {
    // Update the user interface for the detail item.
    if (self.linkItem) {
        NSLog(@"@configure view");
        NSURL *url = [NSURL URLWithString:self.linkItem[@"link"]];
        NSLog(@"url to load: %@", self.linkItem[@"link"]);
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    self.bookmarks = [[NSMutableArray alloc] init];
    _bookmarksCopyFromDefaults = [[NSArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
