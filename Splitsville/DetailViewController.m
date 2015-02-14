//
//  DetailViewController.m
//  Splitsville
//
//  Created by Alice Chang on 2/13/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setLinkItem:(NSDictionary *)newLinkItem {
    if (_linkItem != newLinkItem) {
        _linkItem = newLinkItem;
        [self configureView];
        NSLog(@"setter override");
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.linkItem) {
        self.detailDescriptionLabel.text = self.linkItem[@"title"];
        NSURL *url = [NSURL URLWithString:self.linkItem[@"link"]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
