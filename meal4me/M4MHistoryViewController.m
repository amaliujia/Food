//
//  M4MHistoryViewController.m
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "M4MHistoryViewController.h"
#import "M4MLogCell.h"
#import "M4MFriendCell.h"
#import "M4MFriendLogViewController.h"

@interface M4MHistoryViewController ()
@property (nonatomic, retain) NSDictionary *historyResult;
@property (nonatomic, retain) NSDictionary *friendsResult;
@property (nonatomic, retain) NSArray *friendsArray;
@property (nonatomic, retain) NSArray *ordersArray;
@property (nonatomic, retain) NSArray *dishInOrder;

@end

@implementation M4MHistoryViewController
@synthesize friendView = _friendView;
@synthesize myLogView = _myLogView;
@synthesize friendsArray = _friendsArray;
@synthesize friendsResult = _friendsResult;
@synthesize dishInOrder = _dishInOrder;
@synthesize historyResult = _historyResult;
@synthesize ordersArray = _ordersArray;

- (void)dealloc
{
    [_friendView release];
    [_friendsArray release];
    [_myLogView release];
    [super dealloc];
    [_friendsResult release];
    [_historyResult release];
    [_ordersArray release];
    [_dishInOrder release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // request the history of user.
    id delegate = [[UIApplication sharedApplication] delegate];
    HttpClient* client = [delegate httpClient];
    [client setDelegate:self];
    
    
    [client requestOrderHistoryWith:[delegate valueForKey:@"user_id"]];
   
    
    // request the friends
    [client requestFriendsWithUserID:[delegate valueForKey:@"user_id"]];
    

    
    UIImage *bgImage = [UIImage imageNamed:@"viewbg"];
    [self.friendView setBackgroundColor:[UIColor colorWithPatternImage:bgImage]];

    


    

    

}

- (void)viewDidUnload
{
    [self setFriendView:nil];
    [self setFriendsArray:nil];
    [self setMyLogView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setFriendsResult:nil];
    [self setHistoryResult:nil];
    [self setOrdersArray:nil];
    [self setDishInOrder:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - M4M client delegate

- (void)M4MHttpRequestDidReceivedResult:(NSDictionary *)result withRequestType:(M4MHttpRequestType)requestType
{
    if (requestType == M4MHttpRequestTypeGetOrderHistory) {
        self.historyResult = result;
        self.ordersArray = [self.historyResult valueForKey:@"order_list"];
        self.dishInOrder = [self.historyResult valueForKey:@"dishInOrder_list"];
        
        NSLog(@"%@", self.historyResult);
        NSLog(@"%@ %@", self.dishInOrder, self.ordersArray);
        [self.myLogView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    } else if (requestType == M4MHttpRequestTypeGetFriends) {
        self.friendsResult = result;
        self.friendsArray = [self.friendsResult valueForKey:@"friends_list"];
        
        NSLog(@"%@", self.friendsResult);
        NSLog(@"%@", self.friendsArray);
        [self.friendView reloadData];
    }
}

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
    NSLog(@"%@",[currentLog description]);
    for (NSDictionary *dish in self.dishInOrder)
    {
        if ([[dish valueForKey:@"order_id"] intValue] == [[currentLog valueForKey:@"order_id"] intValue]) {
            price += [[dish valueForKey:@"dish_price"] doubleValue];
            orders = [orders stringByAppendingFormat:@"%@\n", [dish valueForKey:@"dish_name"]];
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
    
//    M4MDishViewController *dishVC = [self.storyboard instantiateViewControllerWithIdentifier:@"dishViewController"];
    // ...
    // Pass the selected object to the new view controller.
//    dishVC.dish= [[self.menuResult objectForKey:@"dishList"] objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:dishVC animated:YES];
    
}

#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self dismissModalViewControllerAnimated:YES];
        default:
            break;
    }
}


#pragma mark - GridView Data Source

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView
{
    NSLog(@"friends count = %d", [self.friendsArray count]);
    return [self.friendsArray count];
}

- (AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"friendCell%d",index];
    
    M4MFriendCell *cell = (M4MFriendCell *)[gridView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[M4MFriendCell alloc] initWithFrame:CGRectMake(0, 0, 72, 72) reuseIdentifier:cellIdentifier];
        [cell setName:[[self.friendsArray objectAtIndex:index] valueForKey:@"user_name"]];
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"friend.png"]];
        [image setFrame:CGRectMake(12, 8, 48, 48)];
        [cell addSubview:image];
    }
    
    return cell;
}

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{
    [gridView deselectItemAtIndex:index animated:YES];
    
    M4MFriendLogViewController *friendLogVC = [self.storyboard instantiateViewControllerWithIdentifier:@"friendLog"];
    NSDictionary *currentFriend = [self.friendsArray objectAtIndex:index];
    [friendLogVC.navigationItem setTitle:[currentFriend valueForKey:@"user_name"]];
    [friendLogVC setUserID:[currentFriend valueForKey:@"user_id"]];
    [self.navigationController pushViewController:friendLogVC animated:YES];
    
}


#pragma mark - viewcontroller methods


- (IBAction)pressLogoutButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout Meal4me" message:@"Do you want to logout your account?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    [alert release];
}

- (IBAction)changeSegment:(UISegmentedControl *)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [self.friendView setHidden:YES];
            break;
        case 1:
            [self.friendView setHidden:NO];
            break;
        default:
            break;
    }
}


@end
