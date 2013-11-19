//
//  M4MPromotionViewController.h
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFOpenFlowView.h"

@interface M4MPromotionViewController : UIViewController <AFOpenFlowViewDelegate, AFOpenFlowViewDataSource, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate,M4MHttpRequestDelegate>
@property (retain, nonatomic) IBOutlet UITableView *dishTableView;

- (IBAction)pressLogoutButton:(id)sender;

@end
