//
//  M4MDishViewController.h
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface M4MDishViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, M4MHttpRequestDelegate,UIAlertViewDelegate>

@property (retain, nonatomic) NSDictionary *dish;
@property (retain, nonatomic) IBOutlet EGOImageView *photoView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (retain, nonatomic) IBOutlet UITableView *detailTableView;
@property (retain, nonatomic) IBOutlet UITextField *commentTextField;

- (IBAction)changeSegment:(id)sender;
- (IBAction)didEndAddComment:(id)sender;
- (IBAction)orderBtnPress:(id)sender;

@end
