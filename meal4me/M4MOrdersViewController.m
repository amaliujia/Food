//
//  M4MOrdersViewController.m
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "M4MOrdersViewController.h"
#import "M4MDishCell.h"

@interface M4MOrdersViewController ()

@end

@implementation M4MOrdersViewController

@synthesize ordersArray = _ordersArray;
@synthesize orderTable = _orderTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    self.ordersArray = nil;
    [self.ordersArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // request the history of user.
    id delegate = [[UIApplication sharedApplication] delegate];
    HttpClient* client = [delegate httpClient];
    [client setDelegate:self];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [ud objectForKey:@"myOrder"];
   // NSLog(@"%@",arr);
    self.ordersArray = [NSMutableArray arrayWithArray:arr];

//    self.view setBackgroundCo
    
    
    //add edit button
    if(arr.count > 0){
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.orderTable = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - M4M client delegate

- (void)M4MHttpRequestDidReceivedResult:(NSDictionary *)result withRequestType:(M4MHttpRequestType)requestType
{
    if (requestType == M4MHttpRequestTypeGetOrderHistory) {
//        self.ordersArray = result;
//        self.ordersArray = [self.historyResult valueForKey:@"order_list"];
//        self.dishInOrder = [self.historyResult valueForKey:@"dishInOrder_list"];
//        
//        NSLog(@"%@", self.historyResult);
//        NSLog(@"%@ %@", self.dishInOrder, self.ordersArray);
//        [self.myLogView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
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
    static NSString *CellIdentifier = @"orderCell";
    M4MDishCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSDictionary *currentDish = [self.ordersArray objectAtIndex:indexPath.row];    
    NSURL *imageUrl = [NSURL URLWithString:[currentDish objectForKey:@"image"]];
    //    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    [cell.photoView setImageURL:imageUrl];
    [cell.nameLabel setText:[currentDish valueForKey:@"dishName"]];
    [cell.descriptionLabel setText:[currentDish valueForKey:@"dishDescription"]];
    [cell.priceLabel setText:[NSString stringWithFormat:@"$%.2f", [[currentDish valueForKey:@"dishPrice"] doubleValue]]];
//    int i = ([[currentDish valueForKey:@"dishPrice"] intValue]) % 3;
//    NSLog(@"%d", i);
//    switch (i) {
//        case 0:
//            [cell.healthSignalView setBackgroundColor:[UIColor greenColor]];
//            break;
//        case 1:
//            [cell.healthSignalView setBackgroundColor:[UIColor yellowColor]];
//            break;
//        case 2:
//            [cell.healthSignalView setBackgroundColor:[UIColor redColor]];
//            
//        default:
//            break;
//    }
    
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


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
     // Delete the row from the data source
        
         [self.ordersArray removeObjectAtIndex:indexPath.row];
         [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
         [self.orderTable reloadData];
         NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
         [ud setValue:self.ordersArray forKey:@"myOrder"];
         if (self.ordersArray.count == 0) {
             self.navigationItem.rightBarButtonItem = nil;
             [self.navigationItem.rightBarButtonItem release];
         }
     }   
     else if (editingStyle == UITableViewCellEditingStyleInsert) {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }   
 }


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
//    // ...
//    // Pass the selected object to the new view controller.
//    dishVC.dish= [[self.menuResult objectForKey:@"dishList"] objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:dishVC animated:YES];
    
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.orderTable setEditing:editing animated:animated];
    if (editing) {
        // you can disable something
    } else
    {
        //re-enable something
    }
    

}


-(void)submitPress:(id)sender
{
//    NSArray *arr = [[NSArray alloc]init];
//    self.ordersArray = arr;
//    [arr release];
//    [self.ordersArray removeAllObjects];
//    [self.orderTable reloadData];
    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"submit your order" message:@"do you want to submit your order" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"OK", nil]autorelease];
    [alert show];
    
    
    
}


-(void)itemAllRemove:(id)sender
{
    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"remove all item" message:@"do you want to clean up my order" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"OK", nil]autorelease];
    [alert show];
}

#pragma alertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        ;
    }
    else {
        [self.ordersArray removeAllObjects];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setValue:self.ordersArray forKey:@"myOrder"];
        //[self.orderTable reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
