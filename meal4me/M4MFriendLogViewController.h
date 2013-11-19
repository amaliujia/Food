//
//  M4MFriendLogViewController.h
//  meal4me
//
//  Created by Lancy on 14/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M4MFriendLogViewController : UITableViewController <M4MHttpRequestDelegate>

@property (nonatomic, retain) NSString *userID;

@end
