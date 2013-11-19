//
//  M4MLoginViewControllerViewController.m
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "M4MLoginViewControllerViewController.h"
#import "HttpClient.h"
#import "M4MAppDelegate.h"
#import "AWNotification.h"

@interface M4MLoginViewControllerViewController ()


@end

@implementation M4MLoginViewControllerViewController
@synthesize usernameTextfield = _usernameTextfield;
@synthesize passwordTextfield = _passwordTextfield;
@synthesize notification = _notification;



- (void)dealloc
{
    [super dealloc];
    [self.usernameTextfield release];
    [self.passwordTextfield release];
    [self.notification release];
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setUsernameTextfield:nil];
    [self setPasswordTextfield:nil];
    [self setNotification:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)finishUsernameInput:(UITextField *)sender {
    [self.passwordTextfield becomeFirstResponder];
}


- (void)setMainViewUserInteractionEnable:(NSNumber *)toogle
{
    [self.view setUserInteractionEnabled:[toogle boolValue]];
}

- (IBAction)pressLoginButton:(id)sender {
    id delegate = [[UIApplication sharedApplication] delegate];
    HttpClient* client = [delegate httpClient];
    [client setDelegate:self];
    
    NSString *username = [self.usernameTextfield text];
    NSString *password = [self.passwordTextfield text];
    
    // notification view
    AWNotification *notification = [[AWNotification alloc] initWithNotificationStyle:AWNotificationStylePill];
    self.notification = notification;
    notification.message = @"login...";
    notification.center = CGPointMake(160.0, 400.0); // optionally move the notification view around
    [notification show];
    [notification release];
    
    // ... the status of the process changes
//    notification.message = @"Almost finished...";
    
    
    // asynchonous request
    [client requestLoginWithUser:username andPassword:password];
    [self.view setUserInteractionEnabled:NO];
    
}

- (void)M4MHttpRequestDidReceivedResult:(NSDictionary *)result withRequestType:(M4MHttpRequestType)requestType
{
    id delegate = [[UIApplication sharedApplication] delegate];
    if (requestType == M4MHttpRequestTypeLogin) {
        NSDictionary *loginResult = result;
        if ([[loginResult valueForKey:@"message"] isEqualToString:@"Login Success"]) {
            [self.notification hideWithSuccessMessage:@"Login Success"];
            [delegate setUser_id:[loginResult valueForKey:@"userid"]];
            [self performSegueWithIdentifier:@"login" sender:self];
        } 
        else {
            NSLog(@"Login failed. %@", loginResult);
            [self.notification hideWithFailureMessage:@"Sorry, Login failed. "];
        }
    }
    [self.view setUserInteractionEnabled:YES];
}
@end
