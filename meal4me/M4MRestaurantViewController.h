//
//  M4MRestarantViewController.h
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface M4MRestaurantViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, M4MHttpRequestDelegate,UIAlertViewDelegate>

@property (nonatomic, retain) NSDictionary *restaurant;

@property (retain, nonatomic) IBOutlet UITableView *menuView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet EGOImageView *photoView;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (retain, nonatomic) IBOutlet UILabel *addressLabel;
@property (retain, nonatomic) IBOutlet UILabel *distanceLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UILabel *likeLabel;
@property (nonatomic) NSInteger btnPressed;


- (IBAction)pressLikeBtn:(id)sender;
- (IBAction)addToMyFavorite:(id)sender;
- (IBAction)segmentChanged:(id)sender;

@end
