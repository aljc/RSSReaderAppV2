//
//  MasterViewController.h
//  Splitsville
//
//  Created by Alice Chang on 2/13/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

/* Custom protocol */
@protocol MasterToDetailViewControllerDelegate <NSObject>

- (void)master:(id)sender sendsLoadStatus:(BOOL)isDoneLoading;

@end

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property NSMutableArray *links;

/* Delegate property */
@property (weak, nonatomic) id<MasterToDetailViewControllerDelegate> delegate;

@end

