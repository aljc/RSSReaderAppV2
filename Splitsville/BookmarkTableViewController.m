//
//  BookmarkTableViewController.m
//  Splitsville
//
//  Created by ajchang on 2/16/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

#import "BookmarkTableViewController.h"
#import "BookmarkTableViewCell.h"
#import "MyDataFetchClass.h"

@interface BookmarkTableViewController ()
@property NSArray* bookmarkLinks;
@end

@implementation BookmarkTableViewController

- (void)loadInitialData
{
    self.bookmarkLinks = [[NSArray alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults arrayForKey:@"bookmarks"]!=nil) {
        self.bookmarkLinks = [defaults arrayForKey:@"bookmarks"];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //http://www.appcoda.com/self-sizing-cells/
    self.tableView.estimatedRowHeight = 89.0; //set estimated row height of cell = height of existing prototype cell
    self.tableView.rowHeight = UITableViewAutomaticDimension; //self-sizing cells

    [self loadInitialData];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData]; //force a reload after the view appears
    //to ensure that all cells are displayed with correct row height upon
    //first load
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

    return self.bookmarkLinks.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookmarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookmarkCell" forIndexPath:indexPath];
    
    NSDictionary* currentArrayElement = [self.bookmarkLinks objectAtIndex:indexPath.row];
    
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
    NSDictionary* currentArrayElement = [self.bookmarkLinks objectAtIndex:indexPath.row];
    
    //both master view link and bookmark links count as "lastViewedArticle"s
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:currentArrayElement forKey:@"lastViewedArticle"];
    [defaults synchronize];
    
    [self.delegate bookmark:self sendsURL:[NSURL URLWithString:[currentArrayElement objectForKey:@"link"]]];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

// Override to support conditional editing of the table view
// This allows users to swipe to delete cells.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

//remove the linkItem from the list of bookmarks in NSUserDefaults
- (void)removeFromBookmarks:(NSDictionary*) linkItem {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *bkmks;
    
    //no bookmarks to remove
    if ([defaults arrayForKey:@"bookmarks"]==nil) {
        return;
    }
    else {
        bkmks = [defaults arrayForKey:@"bookmarks"];
    }
    
    int index;
    
    NSInteger len = bkmks.count;

    
    for (index=0; index < len; index++) {
        NSDictionary* d = [bkmks objectAtIndex:index];
        if ([[d objectForKey:@"title"] isEqualToString:[linkItem objectForKey:@"title"]])
            break;
    }
    
    //article not bookmarked
    if (index == len)
        return;
    
    NSMutableArray* newBookmarkLinks = [[NSMutableArray alloc]initWithCapacity:len-1];
    
    for (int j=0; j < len-1; j++) {
        if (j < index)
            [newBookmarkLinks addObject:[bkmks objectAtIndex:j]];
        else
            [newBookmarkLinks addObject:[bkmks objectAtIndex:j+1]];
    }
    
    //replace bookmarks user defaults field with new consolidated array
    [defaults setObject:newBookmarkLinks forKey:@"bookmarks"];
    [defaults synchronize];
    
    [self loadInitialData];
    

    //[self.tableView reloadData];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary* remove = [self.bookmarkLinks objectAtIndex:indexPath.row];
        [self removeFromBookmarks:remove];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } /* else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }  */
}

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
