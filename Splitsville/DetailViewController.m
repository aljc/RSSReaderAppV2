//
//  DetailViewController.m
//  Splitsville
//
//  Created by Alice Chang on 2/13/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//



#import "DetailViewController.h"

#import <Social/Social.h>



@interface DetailViewController ()

@property NSArray* bookmarksCopyFromDefaults;
@property BOOL finishedLoading;
@property UIView *loadingView;
@property UIImageView *starView;

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

//check if a given link is already an article that's been bookmarked (for loading the star on a link clicked from the bookmarks view)

- (BOOL) isURLInBookmarks:(NSURL*)url {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray* bookmarks = [defaults arrayForKey:@"bookmarks"];

    if (bookmarks == nil)
        return false;
    
    for (NSDictionary* d in bookmarks) {
        if ([[NSURL URLWithString:[d objectForKey:@"link"]] isEqual:url]) {
            NSLog(@"iN BOOKMARKS");
            return true;
        }
    }
    
    return false;
}

//returns true if the article is already in the bookmarks stored in NSUserDefaults, otherwise false

- (BOOL) isBookmarked:(NSDictionary*) linkItem {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray* bookmarks = [defaults arrayForKey:@"bookmarks"];
    
    if (bookmarks == nil)
        return false;
    
    for (NSDictionary* d in bookmarks) {
        if ([[d objectForKey:@"title"] isEqualToString:[linkItem objectForKey:@"title"]]) {
            NSLog(@"isbookmarked: already bookmarked");
            return true;
        }
    }
    
    NSLog(@"isbookmarked: new bookmark");

    return false;
    
}



- (IBAction)addToBookmarks:(UIBarButtonItem *)sender {
    //[self resetNSUserDefaults];
    
    if (self.linkItem == nil) {
        NSLog(@"You haven't selected an article yet");
        
        return;
        
    }
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _bookmarksCopyFromDefaults = [defaults arrayForKey:@"bookmarks"];
    
    //add objects already stored in bookmarks
    
    if (_bookmarksCopyFromDefaults != nil)
        [self.bookmarks addObjectsFromArray:_bookmarksCopyFromDefaults];
    
    //append latest article to bookmarks array if not already bookmarked
    
    if ([self isBookmarked:self.linkItem] == false){
        [self.bookmarks addObject:self.linkItem];
        
        //replace bookmarks user defaults field with new consolidated array
        
        [defaults setObject:self.bookmarks forKey:@"bookmarks"];
        [defaults synchronize];
    }

    NSLog(@"NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
    
    
    return;
    
}



//can't just use the default setter because we also want to update the view

//(call configureView) after we set it

- (void)setDetailItem:(NSDictionary *)newLinkItem { //**must be named setDetailItem to override existing function
    
    if (self.linkItem != newLinkItem) { //if view isn't already onscreen
        self.linkItem = newLinkItem;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.linkItem forKey:@"lastViewedArticle"];
        [defaults synchronize];
        
        
        [self configureView];
        NSLog(@"setter override");
        
    }
}



//Displays a twitter sheet to allow user to tweet about article
//Source: http://pinkstone.co.uk/how-to-post-to-facebook-and-twitter-using-social-framework/

- (IBAction)configureSocial:(UIBarButtonItem *)sender {
    if (self.linkItem == nil) {
        NSLog(@"You haven't selected an article yet");
        return;
    }
    
    SLComposeViewController *socialController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    
    // present controller
    
    [self presentViewController:socialController animated:YES completion:nil];
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



//Source: https://github.com/uchicago-mobi/2015-Winter-Forum/issues/149

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /*** programatically create and add loading view (activity indicator), when web view is loading ***/
    
    _loadingView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2.0 - 50, self.view.frame.size.height / 2.0 - 50, 80, 80)];
    _loadingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    _loadingView.layer.cornerRadius = 5;
    
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(_loadingView.frame.size.width / 2.0, 35);
    [activityView startAnimating];
    activityView.tag = 102;
    [_loadingView addSubview:activityView];
    
    
    UILabel* loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, 80, 30)];
    loadingLabel.text = @"Loading";
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    [_loadingView addSubview:loadingLabel];
    
    [self.view addSubview:_loadingView];
    
    
    //programmatically positioning the star based on iPad/iPhone,
    //and making it visible if the link is favorited
    //star on right for iPads
    
    _starView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [_starView setFrame:CGRectMake(self.view.frame.size.width-50, 100, 50, 50)];
    }
    
    //star on left for iPhones
    
    else
    {
        [_starView setFrame:CGRectMake(0, 100, 50, 50)];
        
    }
    [self.webView addSubview:_starView];
    
    
    //hide the star if the link is not favoritd
    
    if (![self isBookmarked:self.linkItem]) {
        NSLog(@"hidden");
        [_starView removeFromSuperview];
    }
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lastViewedArticle"]!=nil) {
        self.linkItem = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastViewedArticle"];
    }
    
    [self configureView];
    self.bookmarks = [[NSMutableArray alloc] init];
    _bookmarksCopyFromDefaults = [[NSArray alloc] init];
    
}



- (void)viewWillAppear:(BOOL)animated

{
    
    
    //present the splash screen view controller after DVC is loaded, but before its view appears on screen
    
    //show the splash screen while data is being downloaded.
    
    
    
    NSLog(@"view will appear");
    
    
    
    //only present the splash screen once, i.e. when the data is still downloading
    
    //    if (!self.finishedLoading) {
    
    //        UIViewController *splashScreen = [[UIViewController alloc] init];
    
    //        splashScreen.view.backgroundColor = [UIColor greenColor];
    
    //        [self presentViewController:splashScreen animated:NO completion:^{
    
    //            NSLog(@"Splash screen is showing");
    
    //        }];
    
    //
    
    //        //be listening for a "finished loading" notification, and trigger the dismissSplash function when that happens
    
    //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSplash:) name:@"mobi.uchicago.finishedLoading" object:nil];
    
    //    }
    
    //
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"mobi.uchicago.finishedLoading" object:nil];
}



- (void)dismissSplash:(NSNotification*)notif {
    NSLog(@"dismiss splash");
    self.finishedLoading = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Segues



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"@DETAIL PREPARE FOR SEGUE %@", [segue identifier]);
    //Note: must give this segue an identifier in storyboard! **
    if ([[segue identifier] isEqualToString:@"popoverSegue"]) {
        NSLog(@"Prepare for bookmark segue");
        BookmarkTableViewController* bvc = (BookmarkTableViewController*)segue.destinationViewController;
        
        
        //NOTE: THIS MEANS THAT THE BOOKMARK VIEW CONTROLLER, WHICH IS ABOUT TO BE SHOWN,
        
        //WILL BE ASSIGNED A DELEGATE VALUE OF *SELF*, WHICH IS STILL CURRENTLY *THIS* DETAILVIEWCONTROLLER!
        
        bvc.delegate = self;
        
        //The following will make the popover segue possible on ios8 iPhones! (not just iPads)
        //Source: http://rbnsn.me/posts/2014/09/08/ios-8-popover-presentations/
        UIPopoverPresentationController *popPC = bvc.popoverPresentationController;
        popPC.delegate = self;
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark - BookmarkDelegateProtocol Methods

//BVC sends URL to be loaded to DVC, so DVC can load the webview.

//Will be called from the BookmarkViewController, which has set this DetailViewController as its delegate.

//Grab the URL of the *tapped bookmark cell* from the BVC and load the webview.

- (void)bookmark:(id)sender sendsURL:(NSURL*)url {
    if ([self isURLInBookmarks:url]) {
        [self.webView addSubview:_starView];
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}



#pragma mark - UIWebView delegate methods

- (void) webViewDidStartLoad:(UIWebView *)webView {
    
    //_loadingView.hidden = NO; //Note: this will make the loading view flicker.
    
    //better to just hide the loading view the first time it hits webViewDidFinishLoad.
    
}



- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    _loadingView.hidden = YES;
    
}



@end

