//
//  MasterViewController.m
//  Splitsville
//
//  Created by Alice Chang on 2/13/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MyDataFetchClass.h"
#import "ArticleTableViewCell.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@property BOOL nightReadingModeOn;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void)loadInitialData
{
    [[MyDataFetchClass sharedNetworking] getFeedWithURL:@"http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=8&q=http%3A%2F%2Fnews.google.com%2Fnews%3Foutput%3Drss" success:^(NSMutableArray *array, NSError *error) {
    
        self.links = array;
        NSLog(@"loading");
        
//        for (NSDictionary *link in self.links) {
//            NSLog(@"DownloadedData:%@\n%@\n%@\n%@",
//                  link[@"link"],
//                  link[@"contentSnippet"],
//                  link[@"publishedDate"],
//                  link[@"title"]);
//        }
//        
        //update the table on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        [self.refreshControl endRefreshing];
    } failure:^{
        dispatch_async(dispatch_get_main_queue(), ^{ //bring back to main thread
            NSLog(@"Problem with Data");
            [self.refreshControl endRefreshing];
        });
    }];

}

- (void)refreshTable {
    NSLog(@"Pull To Refresh");
    
    //Reload the data - repopulate the issuesData array! ***
    [self loadInitialData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 89.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.links = [[NSMutableArray alloc] init]; //initialize the array
    [self loadInitialData]; //now, populate the array!
    
    //refresh control
    UIRefreshControl *pullToRefresh = [[UIRefreshControl alloc] init];
    [pullToRefresh addTarget:self action:@selector(refreshTable)
            forControlEvents:UIControlEventValueChanged];
    self.refreshControl = pullToRefresh;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSLog(@"Prepare for segue");
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *link = [self.links objectAtIndex:indexPath.row];
        NSLog(@"link: %@", link);
        
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:link];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.links.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"articleCell" forIndexPath:indexPath];
    
    Boolean nightReadingModeOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"TurnNightReadingModeOn"];
    
    NSDictionary* currentArrayElement = [self.links objectAtIndex:indexPath.row];
    
    //NSLog(@"array: %@", currentArrayElement);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy hh:mm:ss ZZZZZ"]; //matches exactly the current date format
    [dateFormatter setDateStyle:NSDateFormatterShortStyle]; //** specify the date format you want to display
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:[currentArrayElement objectForKey:@"publishedDate"]];
    
    cell.title.text = [currentArrayElement objectForKey:@"title"];
    cell.date.text = [dateFormatter stringFromDate:[NSDate date]];
    cell.preview.text = [currentArrayElement objectForKey:@"contentSnippet"];
    
    //if night mode is turned on, then adjust the colors
    if (nightReadingModeOn == YES) {
        //NSLog(@"night mode ON");
        cell.backgroundColor = [UIColor blackColor];
        cell.title.textColor = [UIColor whiteColor];
        cell.date.textColor = [UIColor whiteColor];
        cell.preview.textColor = [UIColor whiteColor];
    }
    //else {
    //    //NSLog(@"night mode NOT ON");
    //}
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

//- (void)setPreferenceDefaults {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"TurnNightReadingModeOn"];
//    [defaults registerDefaults:appDefaults];
//    
//    NSLog(@"NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
//}

@end
