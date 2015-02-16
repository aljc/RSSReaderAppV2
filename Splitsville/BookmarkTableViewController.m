//
//  testtTableViewController.m
//  Splitsville
//
//  Created by ajchang on 2/16/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

#import "BookmarkTableViewController.h"
#import "BookmarkTableViewCell.h"
#import "MyDataFetchClass.h"

@interface BookmarkTableViewController ()
@property NSArray* links;
@end

@implementation BookmarkTableViewController

- (void)loadInitialData
{
    self.links = [[NSArray alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults arrayForKey:@"bookmarks"]!=nil) {
        self.links = [defaults arrayForKey:@"bookmarks"];
    }

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"self: %@", self);
//    self.delegate =

    [self loadInitialData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.links.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"testt");
    BookmarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookmarkCell" forIndexPath:indexPath];
    
    NSDictionary* currentArrayElement = [self.links objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy hh:mm:ss ZZZZZ"]; //matches exactly the current date format
    [dateFormatter setDateStyle:NSDateFormatterShortStyle]; //** specify the date format you want to display
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:[currentArrayElement objectForKey:@"publishedDate"]];
    
    cell.bookmarkTitle.text = [currentArrayElement objectForKey:@"title"];
    cell.bookmarkDate.text = [dateFormatter stringFromDate:[NSDate date]];
    cell.bookmarkPreview.text = [currentArrayElement objectForKey:@"contentSnippet"];
    
    return cell;
}


//Note: must override this function in order to specify a custom action when a cell is tapped!
//Sending the URL of the tapped bookmark cell to the detailviewcontroller so that the DVC
//can load the webview for you.
- (void)tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     NSDictionary* currentArrayElement = [self.links objectAtIndex:indexPath.row];
    
    [self.delegate bookmark:self sendsURL:[NSURL URLWithString:[currentArrayElement objectForKey:@"link"]]];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//// Override to support conditional editing of the table view
//// This allows users to swipe to delete cells.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//
//
//
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } /* else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }  */
//}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
