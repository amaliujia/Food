//
//  M4MHistoryViewController.h
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"


@interface M4MHistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, AQGridViewDelegate, AQGridViewDataSource, M4MHttpRequestDelegate>
@property (retain, nonatomic) IBOutlet AQGridView *friendView;
@property (retain, nonatomic) IBOutlet UITableView *myLogView;

- (IBAction)pressLogoutButton:(id)sender;
- (IBAction)changeSegment:(id)sender;

@end
