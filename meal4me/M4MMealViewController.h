//
//  M4MMealViewController.h
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/Mapkit.h>
#import "VPPMapHelper.h"

@interface M4MMealViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, M4MHttpRequestDelegate,VPPMapHelperDelegate,CLLocationManagerDelegate>
{
    VPPMapHelper *_mh;
    double latitude;
    double longitud;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UITableView *restaurantsTableView;

@property (nonatomic, retain) CLLocationManager *currentLocation;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

- (IBAction)changeSegment:(id)sender;
- (IBAction)pressLogoutButton:(id)sender;

@end
