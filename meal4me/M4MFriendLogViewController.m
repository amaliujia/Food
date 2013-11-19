//
//  M4MFriendLogViewController.m
//  meal4me
//
//  Created by Lancy on 14/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "M4MFriendLogViewController.h"
#import "M4MLogCell.h"

@interface M4MFriendLogViewController ()
@property (nonatomic, retain) NSDictionary *historyResult;
@property (nonatomic, retain) NSArray *ordersArray;
@property (nonatomic, retain) NSArray *dishInOrder;

@end

@implementation M4MFriendLogViewController
@synthesize userID = _userID;
@synthesize historyResult = _historyResult;
@synthesize ordersArray = _ordersArray;
@synthesize dishInOrder = _dishInOrder;

- (void)dealloc
{
    [super dealloc];
    [_userID release];
    [_historyResult release];
    [_ordersArray release];
    [_dishInOrder release];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", self.userID);
    
    id delegate = [[UIApplication sharedApplication] delegate];
    HttpClient* client = [delegate httpClient];
    [client setDelegate:self];
    
    [client requestOrderHistoryWith:self.userID];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.userID = nil;
    self.historyResult = nil;
    self.ordersArray = nil;
    self.dishInOrder = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - M4M Http delegate
- (void)M4MHttpRequestDidReceivedResult:(NSDictionary *)result withRequestType:(M4MHttpRequestType)requestType
{
    if (requestType == M4MHttpRequestTypeGetOrderHistory) {
        self.historyResult = result;
        self.ordersArray = [self.historyResult valueForKey:@"order_list"];
        self.dishInOrder = [self.historyResult valueForKey:@"dishInOrder_list"];
        
        NSLog(@"%@", self.historyResult);
        NSLog(@"%@ %@", self.dishInOrder, self.ordersArray);
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    } 
}



#pragma mark - Table view data source

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.ordersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"logCell";
    M4MLogCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSDictionary *currentLog = [self.ordersArray objectAtIndex:indexPath.row];    
    [cell.timeLabel setText:[currentLog valueForKey:@"order_time"]];
    [cell.restNameLabel setText:[currentLog valueForKey:@"restaurant_name"]];
    NSString *orders = [[[NSString alloc] init] autorelease];
    CGFloat price = 0;
    for (NSDictionary *dish in self.dishInOrder)
    {
        if ([[dish valueForKey:@"order_id"] intValue] == [[currentLog valueForKey:@"order_id"] intValue]) {
            price += [[dish valueForKey:@"dish_price"] doubleValue];
            orders = [orders stringByAppendingFormat:@"%@ ", [dish valueForKey:@"dish_name"]];
        }
    }
    [cell.orderListLabel setText:orders];
    [cell.priceLabel setText:[NSString stringWithFormat:@"$%.2f", price]];
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
