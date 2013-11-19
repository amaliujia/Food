//
//  M4MLoginViewControllerViewController.h
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWNotification.h"

@interface M4MLoginViewControllerViewController : UIViewController <UITextFieldDelegate, M4MHttpRequestDelegate>
@property (retain, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextfield;

@property (retain, nonatomic) AWNotification *notification;

- (IBAction)finishUsernameInput:(id)sender;

- (IBAction)pressLoginButton:(id)sender;

@end
