//
//  M4MAppDelegate.m
//  meal4me
//
//  Created by Lancy on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "M4MAppDelegate.h"


@interface M4MAppDelegate()

@end;
@implementation M4MAppDelegate
@synthesize window = _window;
@synthesize httpClient = _httpClient;
@synthesize user_id = _user_id;


- (HttpClient *)httpClient
{
    if (_httpClient == nil) {
        _httpClient = [[HttpClient alloc] init];
    }
    return _httpClient;
}

- (NSString *)user_id
{
    if (_user_id == nil) {
        _user_id = [[NSString alloc] init];
    }
    return _user_id;
}

- (void)dealloc
{
    _httpClient = nil;
    [_httpClient release];
    [_window release];
    [_user_id release];
    [super dealloc];
}

- (void)customizeAppearance
{
    double color[10][3] = {{51, 102, 51},
        {0, 51, 0},
        {255, 249, 230},
        {102, 153, 102},
        {118, 166, 139},
        {138, 140, 112}
    };
    UIColor *color0 = [UIColor colorWithRed:color[0][0]/255.0 green:color[0][1]/255.0 blue:color[0][2]/255.0 alpha:1];
    UIColor *color1 = [UIColor colorWithRed:color[1][0]/255.0 green:color[1][1]/255.0 blue:color[1][2]/255.0 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:color[2][0]/255.0 green:color[2][1]/255.0 blue:color[2][2]/255.0 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:color[3][0]/255.0 green:color[3][1]/255.0 blue:color[3][2]/255.0 alpha:1];
    UIColor *color4 = [UIColor colorWithRed:color[4][0]/255.0 green:color[4][1]/255.0 blue:color[4][2]/255.0 alpha:1];
    UIColor *color5 = [UIColor colorWithRed:color[5][0]/255.0 green:color[5][1]/255.0 blue:color[5][2]/255.0 alpha:1];
    
    [[UINavigationBar appearance] setTintColor:color3];
    [[UISegmentedControl appearance] setTintColor:color3];
    [[UITabBar appearance] setTintColor:color1];
    [[UITabBar appearance] setSelectedImageTintColor:color2];
    
    [[UITableView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewbg"]]]; 
    [[UITableView appearance] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[UITableViewCell appearance] setSelectionStyle:UITableViewCellSelectionStyleGray];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self customizeAppearance];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
