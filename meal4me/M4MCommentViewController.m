//
//  M4MCommentViewController.m
//  meal4me
//
//  Created by Lancy on 15/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "M4MCommentViewController.h"
#import "M4MAppDelegate.h"


@interface M4MCommentViewController ()

@end

@implementation M4MCommentViewController
@synthesize commentText;
@synthesize dish_id = _dish_id;
@synthesize starRating = _starRating;

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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewbg"]]]; 
    [self.commentText becomeFirstResponder];
    DLStarRatingControl *customNumberOfStars = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(0, 60, 320, 60) andStars:5 isFractional:YES];
    customNumberOfStars.delegate = self;
	customNumberOfStars.backgroundColor = [UIColor clearColor];
	customNumberOfStars.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	customNumberOfStars.rating = 2.5;
	[self.view addSubview:customNumberOfStars];
    [customNumberOfStars release];

    
}

- (void)viewDidUnload
{
    [self setCommentText:nil];
    [self setDish_id:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)saveComment:(id)sender {
    id delegate = [[UIApplication sharedApplication] delegate];
    HttpClient* client = [delegate httpClient];
    [client setDelegate:self];
    
    NSLog(@"%@", _dish_id);
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.dish_id, @"foreign_id", [delegate user_id], @"user_id", [NSString stringWithFormat:@"%d",self.starRating], @"rating", self.commentText.text, @"comments",  nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonstring = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@%@", dictionary, jsonstring);
    
    [client saveDishComment:jsonstring];
    
    [self closeCommentVC:sender];
}

#pragma mark -
#pragma mark Delegate implementation of NIB instatiated DLStarRatingControl

-(void)newRating:(DLStarRatingControl *)control :(float)rating {
	//self.stars.text = [NSString stringWithFormat:@"%0.1f star rating",rating];
    self.starRating = rating;
}


- (IBAction)closeCommentVC:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (void)dealloc {
    [commentText release];
    [_dish_id release];
    [super dealloc];
}
@end
