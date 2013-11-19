//
//  M4MCommentViewController.h
//  meal4me
//
//  Created by Lancy on 15/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"

@interface M4MCommentViewController : UIViewController<M4MHttpRequestDelegate,DLStarRatingDelegate>
@property (retain, nonatomic) IBOutlet UITextView *commentText;
@property (retain, nonatomic) NSString *dish_id;
@property (nonatomic) NSInteger starRating;

- (IBAction)saveComment:(id)sender;
- (IBAction)closeCommentVC:(id)sender;

@end
