//
//  M4MRestarantViewController.m
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "M4MRestaurantViewController.h"
#import "M4MDishViewController.h"
#import "M4MDishCell.h"
#import "EGOImageView.h"
#import "AWNotification.h"

@interface M4MRestaurantViewController ()
@property (nonatomic, retain) NSDictionary *menuResult;

- (void)configureRestaurant;
@end

@implementation M4MRestaurantViewController
@synthesize restaurant = _restaurant;
@synthesize menuView = _menuView;
@synthesize menuResult = _menuResult;
@synthesize nameLabel = _nameLabel;
@synthesize photoView = _photoView;
@synthesize typeLabel = _typeLabel;
@synthesize addressLabel = _addressLabel;
@synthesize distanceLabel = _distantLabel;
@synthesize priceLabel = _priceLabel;
@synthesize likeLabel = _likeLabel;
@synthesize btnPressed = _btnPressed;

- (void)dealloc
{
    [_nameLabel release];
    [_photoView release];
    [_typeLabel release];
    [_addressLabel release];
    [_distantLabel release];
    [_priceLabel release];
    [_menuView release];
    [super dealloc];
    [self.restaurant release];
    [_menuResult release];
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
    [self configureRestaurant];
    
    id delegate = [[UIApplication sharedApplication] delegate];
    HttpClient* client = [delegate httpClient];
    [client setDelegate:self];
    
    [client requestRestaurantMenuWithId:[self.restaurant valueForKey:@"restaurantID"] andIsOnlyPromoted:@"0"];
    [client requestRestaurantLikeWithrestaurantId:[self.restaurant valueForKey:@"restaurantID"] andfavorite:@"0" andUserid:[delegate user_id]];
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setPhotoView:nil];
    [self setTypeLabel:nil];
    [self setAddressLabel:nil];
    [self setDistanceLabel:nil];
    [self setPriceLabel:nil];
    [self setMenuView:nil];
    [super viewDidUnload];
    [self setRestaurant:nil];
    [self setMenuResult:nil];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - M4M client delegate

- (void)M4MHttpRequestDidReceivedResult:(NSDictionary *)result withRequestType:(M4MHttpRequestType)requestType
{
    if (requestType == M4MHttpRequestTypeGetRestaurantMenu) {
        self.menuResult = result;
        [self.menuView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    }
    if (requestType == M4MHttpRequestTypeGetRestaurantLike) {
        [self.likeLabel setText:[NSString stringWithFormat:@"%@ like", [result valueForKey:@"like_count"]]];
       // NSLog(@"%d",[result valueForKey:@"like_count"]);
        NSLog(@"%@",[result description]);
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


- (void)configureRestaurant
{
    NSURL *imageUrl = [NSURL URLWithString:[self.restaurant objectForKey:@"photo"]];
    [self.photoView setImageURL:imageUrl];
    [self.nameLabel setText:[self.restaurant valueForKey:@"restaurantName"]];
    [self.typeLabel setText:[self.restaurant valueForKey:@"restaurantType"]];
    [self.distanceLabel setText:[NSString stringWithFormat:@"%.2f mi", [[self.restaurant valueForKey:@"distance"] doubleValue]]];
    [self.priceLabel setText:@"$$"];
    NSString *string = [NSString stringWithFormat:@"%@ %@,%@,%@ %@", [self.restaurant valueForKey:@"stree1"], [self.restaurant valueForKey:@"stree2"], [self.restaurant valueForKey:@"city"], [self.restaurant valueForKey:@"state"], [self.restaurant valueForKey:@"zip"]];
    [self.addressLabel setText:string];
    
}

-(void)segmentChanged:(id)sender
{
    id delegate = [[UIApplication sharedApplication] delegate];
    HttpClient* client = [delegate httpClient];
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [client setDelegate:self];
            [client requestRestaurantMenuWithId:[self.restaurant valueForKey:@"restaurantID"] andIsOnlyPromoted:@"0"];
            break;

        case 1:
            [client setDelegate:self];
            [client requestRestaurantMenuWithId:[self.restaurant valueForKey:@"restaurantID"] andIsOnlyPromoted:@"1"];
            break;
        case 2:
            [client setDelegate:self];
            [client requestRestaurantMenuWithId:[self.restaurant valueForKey:@"restaurantID"] andIsOnlyPromoted:@"0"];
            break;
        default:
            break;
    }

}

-(void)pressLikeBtn:(id)sender
{
//    NSString *tmp = [[self.likeLabel text]substringToIndex:1];
//    NSInteger num = [tmp integerValue];
//    num += 1;
//    NSLog(@"%d",num);
//    [self.likeLabel setText:[NSString stringWithFormat:@"%d like",num]];
}

-(void)addToMyFavorite:(id)sender
{
    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"add to my favorite" message:@"Do you want to add this restaurant to your favorite list" delegate:self cancelButtonTitle:@"not now" otherButtonTitles:@"OK", nil]autorelease];
    [alert show];
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//}



@end
