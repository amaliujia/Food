//
//  M4MMealViewController.m
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define METERS_PER_MILE 1609.344

#import "M4MMealViewController.h"
#import "M4MRestaurantViewController.h"
#import "M4MRestaurantCell.h"
#import "HttpClient.h"
#import "MapAnnotationExample.h"
#import "VPPMapHelper.h"

@interface M4MMealViewController ()
@property (nonatomic, retain) NSDictionary* restaurantsResult;
@end

@implementation M4MMealViewController
@synthesize mapView = _mapView;
@synthesize restaurantsTableView = _restaurantsTableView;
@synthesize restaurantsResult = _restaurantsResult;
@synthesize latitude,longitude;
@synthesize currentLocation = _currentLocation;

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
//    CLLocationManager *location;
//    
//    location = [[CLLocationManager alloc] init];
//    [location setDelegate:self];
//    [location setDesiredAccuracy:kCLLocationAccuracyBest];
//    [location setDistanceFilter:10];
//    [location startUpdatingLocation];
    
    
    self.currentLocation = [[CLLocationManager alloc] init];
    [self.currentLocation setDelegate:self];
    self.currentLocation.distanceFilter = kCLDistanceFilterNone; 
    self.currentLocation.desiredAccuracy = kCLLocationAccuracyHundredMeters; 
    [self.currentLocation startUpdatingLocation];
    
    
//    id delegate = [[UIApplication sharedApplication] delegate];
//    self.currentLocation.distanceFilter = kCLDistanceFilterNone; 
//    self.currentLocation.desiredAccuracy = kCLLocationAccuracyHundredMeters; 
//    HttpClient* client = [delegate httpClient];
//    
//    [client setDelegate:self];
//    [client requestNearbyRestaurantsWithLatitude:@"37.706368" andLongitude:@"-121.92421" andRadius:@"100" andIsPromoted:@"NO"];
    
//    NSDictionary *result = [client getNearbyRestaurantsWithLatitude:@"37.706368" andLongitude:@"-121.92421" andRadius:@"100" andIsPromoted:@"NO"];
//    self.restaurantsResult = result;
//    NSLog(@"%@", self.restaurantsResult);
    
    // configure mapview
//    CLLocationCoordinate2D zoomLocation;
//    zoomLocation.latitude = 37.706368;
//    zoomLocation.longitude= -121.92421;
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1*METERS_PER_MILE, 1*METERS_PER_MILE);
//    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];                
//    [self.mapView setRegion:adjustedRegion animated:YES];   
    
    
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setRestaurantsTableView:nil];
    [self setCurrentLocation:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
//    
//    latitude = newLocation.coordinate.latitude;
//    longitude = newLocation.coordinate.longitude;
//}

#pragma mark - M4M client delegate

- (void)M4MHttpRequestDidReceivedResult:(NSDictionary *)result withRequestType:(M4MHttpRequestType)requestType
{
    if (requestType == M4MHttpRequestTypeGetNearbyRestaurants) {
        NSLog(@"%@", [result valueForKey:@"numOfRestaurants"]);
        if ([[result valueForKey:@"numOfRestaurants"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"There isn't any restaurant across 10000 miles" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
            NSLog(@"thers isn't any restaurants nearby");
            return;
        } 
        self.restaurantsResult = result;
         NSDictionary *currentRestaurant = [[self.restaurantsResult objectForKey:@"restaurantList"] objectAtIndex:0];
        NSMutableArray *arr = [NSMutableArray array];
        MapAnnotationExample *ann = [[MapAnnotationExample alloc] init];
        ann.coordinate = CLLocationCoordinate2DMake([[currentRestaurant objectForKey:@"latitude"]doubleValue],[[currentRestaurant objectForKey:@"longitude"]doubleValue]);
        ann.title = [currentRestaurant objectForKey:@"restaurantName"];
        ann.pinAnnotationColor = MKPinAnnotationColorPurple;
        //ann.opensWhenShown = YES;
    
        [arr addObject:ann];
        [ann release];
        currentRestaurant = [[self.restaurantsResult objectForKey:@"restaurantList"] objectAtIndex:1];
        ann = [[MapAnnotationExample alloc] init];
        ann.coordinate = CLLocationCoordinate2DMake([[currentRestaurant objectForKey:@"latitude"]doubleValue],[[currentRestaurant objectForKey:@"longitude"]doubleValue]);
        ann.title = [currentRestaurant objectForKey:@"restaurantName"];
        //ann.image = [UIImage imageNamed:@"bikePin"];
        //ann.opensWhenShown = YES;
        [arr addObject:ann];
        [ann release];
//        ann = [[MapAnnotationExample alloc] init];
//        ann.coordinate = CLLocationCoordinate2DMake(latitude,longitud);
//        ann.title = @"Where am I";
//        ann.opensWhenShown = YES;
//        [arr addObject:ann];
//        [ann release];
        
        // sets up the map
        _mh = [[VPPMapHelper VPPMapHelperForMapView:self.mapView 
                                 pinAnnotationColor:MKPinAnnotationColorGreen 
                              centersOnUserLocation:NO
                              showsDisclosureButton:YES 
                                           delegate:self] retain];
        self.mapView.showsUserLocation = YES;
        
        _mh.userCanDropPin = NO;
        _mh.allowMultipleUserPins = YES;
        _mh.pinDroppedByUserClass = [MapAnnotationExample class];
        [_mh setMapAnnotations:arr];
        
        [_mh release];
        
        
        [arr removeAllObjects];

        [self.restaurantsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    }
    else if (requestType  == M4MHttpRequestTypeGetFavoriteRestaurants)
    {
        self.restaurantsResult = result;
        [self.restaurantsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    }
}

#pragma mark - location delegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    static int firstTime = 1;
    if (firstTime == 1) {
        
        id delegate = [[UIApplication sharedApplication] delegate];
        self.currentLocation.distanceFilter = kCLDistanceFilterNone; 
        self.currentLocation.desiredAccuracy = kCLLocationAccuracyHundredMeters; 
        HttpClient* client = [delegate httpClient];
        
       
        [client setDelegate:self];
//        [client requestNearbyRestaurantsWithLatitude:@"37.706368" andLongitude:@"-121.92421" andRadius:@"100" andIsPromoted:@"NO"];
        [client requestNearbyRestaurantsWithLatitude:[NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude] andLongitude:[NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude] andRadius:@"10000" andIsPromoted:@"NO"];
        
        firstTime--;
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
    return [[self.restaurantsResult valueForKey:@"numOfRestaurants"] intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"restCell";
    M4MRestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSDictionary *currentRestaurant = [[self.restaurantsResult objectForKey:@"restaurantList"] objectAtIndex:indexPath.row];    
    NSURL *imageUrl = [NSURL URLWithString:[currentRestaurant objectForKey:@"photo"]];
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    [cell.photoView setImageURL:imageUrl];
    [cell.nameLabel setText:[currentRestaurant valueForKey:@"restaurantName"]];
    [cell.typeLabel setText:[currentRestaurant valueForKey:@"restaurantType"]];
    [cell.distanceLabel setText:[NSString stringWithFormat:@"%.2f mi", [[currentRestaurant valueForKey:@"distance"] doubleValue]]];
    [cell.rateLabel setText:[NSString stringWithFormat:@"%d/5 stars", (arc4random() % 3 + 2)]];
    NSString *string = [NSString stringWithFormat:@"%@ %@,%@,%@ %@", [currentRestaurant valueForKey:@"stree1"], [currentRestaurant valueForKey:@"stree2"], [currentRestaurant valueForKey:@"city"], [currentRestaurant valueForKey:@"state"], [currentRestaurant valueForKey:@"zip"]];
    [cell.addressLabel setText:string];
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
    
    
    M4MRestaurantViewController *restarantVC = [self.storyboard instantiateViewControllerWithIdentifier:@"restarantViewController"];
     // ...
     // Pass the selected object to the new view controller.

    restarantVC.restaurant = [[self.restaurantsResult objectForKey:@"restaurantList"] objectAtIndex:indexPath.row];
     [self.navigationController pushViewController:restarantVC animated:YES];

}

- (void)dealloc {
    if (_mh != Nil) {
        [_mh release];
    }
    [_mapView release];
    [_restaurantsTableView release];
    [_currentLocation release];
    [super dealloc];
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

- (IBAction)changeSegment:(UISegmentedControl *)sender {
    id delegate = [[UIApplication sharedApplication] delegate];
    HttpClient* client = [delegate httpClient];
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [[self mapView] setHidden:YES];
            [client setDelegate:self];
            
            [client requestNearbyRestaurantsWithLatitude:[NSString stringWithFormat:@"%lf", self.currentLocation.location.coordinate.latitude] andLongitude:[NSString stringWithFormat:@"%lf", self.currentLocation.location.coordinate.longitude] andRadius:@"10000" andIsPromoted:@"NO"];
            
//            [client requestNearbyRestaurantsWithLatitude:@"37.706368" andLongitude:@"-121.92421" andRadius:@"100" andIsPromoted:@"NO"];
            break;
        case 2:
            [[self mapView] setHidden:YES];
            [client setDelegate:self];
//            [client requestNearbyRestaurantsWithLatitude:@"37.706368" andLongitude:@"-121.92421" andRadius:@"100" andIsPromoted:@"NO"];
//            [client requestFavoriteRestaurantsWithLatitude:@"37.706368" andLongitude:@"-121.92421" andRadius:@"100" andIsPromoted:@"NO" withOther:[delegate user_id]];
            
            [client requestFavoriteRestaurantsWithLatitude:[NSString stringWithFormat:@"%lf", self.currentLocation.location.coordinate.latitude] andLongitude:[NSString stringWithFormat:@"%lf", self.currentLocation.location.coordinate.longitude] andRadius:@"10000" andIsPromoted:@"NO" withOther:[delegate user_id]];
            
            break;
        case 1:
            [[self mapView] setHidden:NO];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark VPPMapHelperDelegate

- (void) open:(id<MKAnnotation>)annotation {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Annotation pressed" message:[NSString stringWithFormat:@"Welcome to %@",annotation.title] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
    [av release];
}

- (BOOL) annotationDroppedByUserShouldOpen:(id<MKAnnotation>)annotation {
	MapAnnotationExample *ann = (MapAnnotationExample*)annotation;
	
	ann.title = @"Hi there!";
	ann.pinAnnotationColor = MKPinAnnotationColorGreen;
	
	return YES;
}


@end
