//
//  M4MAppDelegate.h
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpClient.h"

@interface M4MAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) HttpClient *httpClient;
@property (nonatomic, strong) NSString *user_id;



@end
