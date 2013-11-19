//
//  M4MOrdersViewController.h
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M4MOrdersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, M4MHttpRequestDelegate,UIAlertViewDelegate>

@property(nonatomic, retain)NSMutableArray *ordersArray;
@property(nonatomic, retain)IBOutlet UITableView *orderTable;

- (IBAction)submitPress:(id)sender;

- (IBAction)itemAllRemove:(id)sender;

@end
