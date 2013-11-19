//
//  M4MPromotionViewController.m
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "M4MPromotionViewController.h"
#import "EGOImageView.h"
#import "M4MDishCell.h"
#import "M4MDishViewController.h"

@interface M4MPromotionViewController ()
@property (retain, nonatomic) NSDictionary* restaurantsResult;
@property (retain, nonatomic) NSDictionary* menuResult;

- (void)configureRestFlow;

@end

@implementation M4MPromotionViewController
@synthesize dishTableView = _dishTableView;
@synthesize restaurantsResult = _restaurantsResult;
@synthesize menuResult = _menuResult;

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
    id delegate = [[UIApplication sharedApplication] delegate];
    HttpClient* client = [delegate httpClient];
    [client setDelegate:self];
    [client requestNearbyRestaurantsWithLatitude:@"37.706368" andLongitude:@"-121.92421" andRadius:@"100" andIsPromoted:@"YES"];


    

    
}

- (void)viewDidUnload
{
    [self setRestaurantsResult:nil];
    [self setMenuResult:nil];
    [self setDishTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_restaurantsResult release];
    [_menuResult release];
    [_dishTableView release];
    [super dealloc];
}

#pragma mark - M4M client delegate

- (void)M4MHttpRequestDidReceivedResult:(NSDictionary *)result withRequestType:(M4MHttpRequestType)requestType
{
    if (requestType == M4MHttpRequestTypeGetNearbyRestaurants) {
        self.restaurantsResult = result;
        [self configureRestFlow];
    }
}


- (void)configureRestFlow
{
    AFOpenFlowView *flowView = [[[AFOpenFlowView alloc] initWithFrame:CGRectMake(0, 0, 320, 140)] autorelease]	;
    [flowView setNumberOfImages:[[self.restaurantsResult valueForKey:@"numOfRestaurants"] intValue]];
    [flowView setViewDelegate:self];
    [flowView setDataSource:self];
    for (int i = 0; i < flowView.numberOfImages; i++)
    {
        NSDictionary *currentRest = [[self.restaurantsResult valueForKey:@"restaurantList"] objectAtIndex:i];
        EGOImageView *imageView = [[[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] autorelease];
        [imageView setImageURL:[NSURL URLWithString:[currentRest valueForKey:@"photo"]]];
        imageView.image = [UIImage imageWithCGImage:[imageView.image CGImage] scale:1.3 orientation:UIImageOrientationUp];
        [flowView setImage:imageView.image forIndex:i];

    }
    [self.view addSubview:flowView];
    
    [self openFlowView:flowView selectionDidChange:0];

    
}

#pragma mark - open Flow delegate

- (void)reloadMenu:(NSNumber *)index
{
    NSLog(@"ok");
    id delegate = [[UIApplication sharedApplication] delegate];
    HttpClient* client = [delegate httpClient];
    NSDictionary *currentRest = [[self.restaurantsResult valueForKey:@"restaurantList"] objectAtIndex:[index intValue]];
    NSDictionary *result = [client getRestaurantMenuWithId:[currentRest valueForKey:@"restaurantID"] andIsOnlyPromoted:@"0"];
    self.menuResult = result;
    
    [self.dishTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
}

- (UIImage *)defaultImage
{
    return [UIImage imageNamed:@"restFlowDef"];
    
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView requestImageForIndex:(int)index 
{
    
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index {
	NSLog(@"Cover Flow selection did change to %d", index);
    
    
    //multi-thread tring..
    [self performSelectorInBackground:@selector(reloadMenu:) withObject:[NSNumber numberWithInt:index]];

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
    return [[self.menuResult valueForKey:@"numOfDishes"] intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dishCell";
    M4MDishCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSDictionary *currentDish = [[self.menuResult objectForKey:@"dishList"] objectAtIndex:indexPath.row];    
    NSURL *imageUrl = [NSURL URLWithString:[currentDish objectForKey:@"image"]];
    //    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    [cell.photoView setImageURL:imageUrl];
    [cell.nameLabel setText:[currentDish valueForKey:@"dishName"]];
    [cell.descriptionLabel setText:[currentDish valueForKey:@"dishDescription"]];
    [cell.priceLabel setText:[NSString stringWithFormat:@"$%.2f", [[currentDish valueForKey:@"dishPrice"] doubleValue]]];
    int i = ([[currentDish valueForKey:@"dishPrice"] intValue]) % 3;
    NSLog(@"%d", i);
    switch (i) {
        case 0:
            [cell.healthSignalView setBackgroundColor:[UIColor greenColor]];
            break;
        case 1:
            [cell.healthSignalView setBackgroundColor:[UIColor yellowColor]];
            break;
        case 2:
            [cell.healthSignalView setBackgroundColor:[UIColor redColor]];

        default:
            break;
    }
    
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
    
    M4MDishViewController *dishVC = [self.storyboard instantiateViewControllerWithIdentifier:@"dishViewController"];
    // ...
    // Pass the selected object to the new view controller.
    dishVC.dish= [[self.menuResult objectForKey:@"dishList"] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:dishVC animated:YES];
    
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


#pragma mark - viewcontroller methods


- (IBAction)pressLogoutButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout Meal4me" message:@"Do you want to logout your account?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    [alert release];
}



@end
