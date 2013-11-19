//
//  HttpClient.m
//  OlixusSDK
//
//  Created by again on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HttpClient.h"
#import "JSON.h"

@interface HttpClient()

@property (nonatomic, retain) NSMutableArray *connectionArray;
@property (nonatomic, retain) NSMutableArray *recieveData;

@end


@implementation HttpClient
@synthesize recieveData = _recieveData;
@synthesize delegate = _delegate;
@synthesize connectionArray = _connectionArray;

const int M4MHttpRequestTypeCount = 100;

const NSString *host = @"http://www.olixus.com:6688";
const NSString *login = @"/mobiles/mlogin/";
const NSString *nearbyRestaurants = @"/mobiles/getNearbyRestaurants/";
const NSString *favoriteRestaurants = @"/mobiles/getFavoriteRestaurants/";
const NSString *restaurantMenu = @"/mobiles/getRestaurantMenu/";
const NSString *friends = @"/mobiles/getFriends/";
const NSString *orderHistory  = @"/mobiles/getOrderHistory/";
const NSString *orderSave = @"/mobiles/saveOrder/";
const NSString *orderCommentSave = @"/mobiles/saveOrderComment/";
const NSString *orderComment = @"/mobiles/getOrderComment/";
const NSString *dishCommentSave = @"/mobiles/saveDishComment/";
const NSString *dishComment = @"/mobiles/getDishComment/";
const NSString *dishNutritionFormer = @"/mobiles/restaurant/";
const NSString *dishNutritionLatter = @"/dish_evaluation_mobile/";
const NSString *restaurantLikeFormer = @"/mobiles/restaurant/";
const NSString *restaurantLikeLater = @"/like_restaurant/";


- (void)dealloc
{
    NSLog(@"just test git");
    _delegate = nil;
    [_delegate release];
    _connectionArray = nil; 
    [_connectionArray release];
    _recieveData = nil;
    [_recieveData release];
    [super dealloc];
}


- (id)init
{
    self = [super init];
    if (self) {
        self.connectionArray = [[NSMutableArray alloc] init];
        self.recieveData = [[NSMutableArray alloc] init];
        for (int i = 0; i < M4MHttpRequestTypeCount; i++) {
            [self.connectionArray addObject:[NSNull null]];
            [self.recieveData addObject:[[NSMutableData alloc] init]];
        }
        ;
    }
    return self;  
}

- (void)initURLRequest:(NSMutableURLRequest *)_request WithHost:(const NSString *)_host andAnother:(const NSString *)_another
{
    //    NSLog(@"%@%@",_host,_another);
    [_request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_host,_another]]];  
    [_request setHTTPMethod:@"POST"]; 
    [_request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];  
    
}


#pragma mark - Connect delegate methonds

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"didFinishLoading");

    M4MHttpRequestType requestType = M4MHttpRequestTypeLogin;
    for (requestType = M4MHttpRequestTypeLogin; connection != [self.connectionArray objectAtIndex:requestType]; requestType++);

    NSString *result = [[NSMutableString alloc] initWithData:[self.recieveData objectAtIndex:requestType] encoding:NSUTF8StringEncoding];
    NSLog(@"the result is: %@", result);
    if (result == nil) {
        NSLog(@"error: did Receive nil");
    } else {
        [self.delegate M4MHttpRequestDidReceivedResult:[result JSONValue] withRequestType:requestType];
    }
    
    [result release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    M4MHttpRequestType requestType = M4MHttpRequestTypeLogin;
    for (requestType = M4MHttpRequestTypeLogin; connection != [self.connectionArray objectAtIndex:requestType]; requestType++);
    [[self.recieveData objectAtIndex:requestType] setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    M4MHttpRequestType requestType = M4MHttpRequestTypeLogin;
    for (requestType = M4MHttpRequestTypeLogin; connection != [self.connectionArray objectAtIndex:requestType]; requestType++);
    [[self.recieveData objectAtIndex:requestType] appendData:data];

}

#pragma mark - api

- (void)requestLoginWithUser:(NSString *)userName andPassword:(NSString *)passWord;
{
    NSString *post = nil;  
    post = [[[NSString alloc] initWithFormat:@"username=%@&password=%@",userName, passWord]autorelease];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
    NSMutableURLRequest *_request = [[NSMutableURLRequest alloc] init]; 
    [self initURLRequest:_request WithHost:host andAnother:login];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:_request delegate:self];
    [self.connectionArray replaceObjectAtIndex:M4MHttpRequestTypeLogin withObject:connection];
    
    [_request release];  
}

- (void)requestNearbyRestaurantsWithLatitude:(NSString *)latitude andLongitude:(NSString *)longitude andRadius:(NSString *)radius andIsPromoted:(NSString *)promotion
{
    NSString *post = nil;  
    post = [[NSString alloc] initWithFormat:@"latitude=%@&longitude=%@&radius=%@&promotion=%@",latitude,longitude,radius,promotion];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
    NSMutableURLRequest *_request = [[[NSMutableURLRequest alloc] init]autorelease];
    [self initURLRequest:_request WithHost:host andAnother:nearbyRestaurants];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:_request delegate:self];
    [self.connectionArray replaceObjectAtIndex:M4MHttpRequestTypeGetNearbyRestaurants withObject:connection];
}
- (void)requestFavoriteRestaurantsWithLatitude:(NSString *)latitude andLongitude:(NSString *)longitude andRadius:(NSString *)radius andIsPromoted:(NSString *)promotion withOther:(NSString *)userID
{
    NSString *post = nil;  
    post = [[NSString alloc] initWithFormat:@"latitude=%@&longitude=%@&radius=%@&promotion=%@&user_id=&",latitude,longitude,radius,promotion,userID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
    NSMutableURLRequest *_request = [[[NSMutableURLRequest alloc] init]autorelease];
    [self initURLRequest:_request WithHost:host andAnother:favoriteRestaurants];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:_request delegate:self];
    [self.connectionArray replaceObjectAtIndex:M4MHttpRequestTypeGetFavoriteRestaurants withObject:connection];
}
- (void)requestRestaurantMenuWithId:(NSString *)restaurantId andIsOnlyPromoted :(NSString *)promotion
{
    NSString *post = nil;  
    post = [[NSString alloc] initWithFormat:@"restaurant_id=%@&promotion=%@",restaurantId,promotion];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
    NSMutableURLRequest *_request = [[[NSMutableURLRequest alloc] init]autorelease];
    [self initURLRequest:_request WithHost:host andAnother:restaurantMenu];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:_request delegate:self];
    [self.connectionArray replaceObjectAtIndex:M4MHttpRequestTypeGetRestaurantMenu withObject:connection];
    
}
- (void)requestFriendsWithUserID:(NSString *)user_id
{
    NSString *post = nil;  
    post = [[NSString alloc] initWithFormat:@"user_id=%@",user_id];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
    NSMutableURLRequest *_request = [[[NSMutableURLRequest alloc] init]autorelease];
    [self initURLRequest:_request WithHost:host andAnother:friends];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:_request delegate:self];
    [self.connectionArray replaceObjectAtIndex:M4MHttpRequestTypeGetFriends withObject:connection];
}
- (void)requestOrderHistoryWith:(NSString *)user_id
{
    NSString *post = nil;  
    post = [[NSString alloc] initWithFormat:@"user_id=%@",user_id];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
    NSMutableURLRequest *_request = [[[NSMutableURLRequest alloc] init]autorelease];
    [self initURLRequest:_request WithHost:host andAnother:orderHistory];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
   
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:_request delegate:self];
    [self.connectionArray replaceObjectAtIndex:M4MHttpRequestTypeGetOrderHistory withObject:connection];
}
- (void)requestSaveOrderWithUser:(NSString *)usename andID:(NSString *)userid andDataDetail:(NSString *)jsonFormData
{
    
}
- (void)requestSaveOrderComment:(NSString *)jsonFormComment
{
    
}
- (void)requestOrderCommentWithOrderId:(NSString *)order_id
{
    
}
- (void)requestSaveDishComment:(NSString *)jsonFormDishComment
{
    
}
- (void)requestDishCommentWithDishId:(NSString *)dish_id
{
    NSString *post = nil;  
    post = [[NSString alloc] initWithFormat:@"dish_id=%@",dish_id];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
    NSMutableURLRequest *_request = [[[NSMutableURLRequest alloc] init]autorelease];
    [self initURLRequest:_request WithHost:host andAnother:dishComment];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:_request delegate:self];
    [self.connectionArray replaceObjectAtIndex:M4MHttpRequestTypeGetDishComent withObject:connection];
}
- (void)requestDishNutritionWithDishId:(NSString *)dish_id
{
    NSString *DishNutrition = [NSString stringWithFormat:@"%@%@%@",dishNutritionFormer,dish_id,dishNutritionLatter];
    NSLog(@"%@",DishNutrition);  
    NSMutableURLRequest *_request = [[[NSMutableURLRequest alloc] init]autorelease];
    [_request setHTTPMethod:@"GET"];
    [_request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host,DishNutrition]]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:_request delegate:self];
    [self.connectionArray replaceObjectAtIndex:M4MHttpRequestTypeGetDishNutrition withObject:connection];
}

- (void)requestRestaurantLikeWithrestaurantId:(NSString *)restaurant_id andfavorite:(NSString *)favorite andUserid:(NSString *)user
{
    NSString *restaurantNutrition = [NSString stringWithFormat:@"%@%@%@",restaurantLikeFormer,restaurant_id,restaurantLikeLater];
    NSLog(@"%@",restaurantNutrition);  
    NSString *post = nil;  
    post = [[NSString alloc] initWithFormat:@"favorite=%@&user_id=%@",favorite, restaurant_id];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
    NSMutableURLRequest *_request = [[[NSMutableURLRequest alloc] init]autorelease];
    [self initURLRequest:_request WithHost:host andAnother:restaurantNutrition];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:_request delegate:self];
    [self.connectionArray replaceObjectAtIndex:M4MHttpRequestTypeGetRestaurantLike withObject:connection];
}




#pragma mark - synchronous api


-(NSDictionary *)getResultWithRequest:(NSMutableURLRequest *)_request
{
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[[NSError alloc] init]autorelease];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:_request returningResponse:&urlResponse error:&error];
    
    
    
    NSMutableString *result = [[NSMutableString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"The result string is :%@",result); 
    return [result JSONValue];
}


- (void)getResultWithRequestOptions:(NSDictionary *)requestOptions
{
    NSMutableURLRequest *request = [requestOptions valueForKey:@"request"];
    M4MHttpRequestType requestType = [[requestOptions valueForKey:@"requestType"] intValue];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[[NSError alloc] init]autorelease];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSMutableString *result = [[NSMutableString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"The result string is :%@",result); 
    [self.delegate M4MHttpRequestDidReceivedResult:[result JSONValue] withRequestType:requestType];
}


-(NSDictionary *)loginWithUser:(NSString *)userName andPassword:(NSString *)passWord
{
    NSString *post = nil;  
    post = [[[NSString alloc] initWithFormat:@"username=%@&password=%@",userName, passWord]autorelease];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
    NSMutableURLRequest *_request = [[NSMutableURLRequest alloc] init]; 
    [self initURLRequest:_request WithHost:host andAnother:login];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    //[NSURLConnection connectionWithRequest:request delegate:self ];  
    
    //同步请求的的代码
    //returnData就是返回得到的数据
    NSDictionary *_result = [self getResultWithRequest:_request];
    NSLog(@"%@",_result);
    [_request release];
    return _result;
}



-(void)logout
{
    //    DataRetriever *shareDataRetrieve = [DataRetriever sharedRetriever];
    //    [shareDataRetrieve clearData];
    
}


-(NSDictionary *)getNearbyRestaurantsWithLatitude:(NSString *)latitude andLongitude:(NSString *)longitude andRadius:(NSString *)radius andIsPromoted:(NSString *)promotion
{
    NSString *post = nil;  
    post = [[NSString alloc] initWithFormat:@"latitude=%@&longitude=%@&radius=%@&promotion=%@",latitude,longitude,radius,promotion];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
    NSMutableURLRequest *_request = [[[NSMutableURLRequest alloc] init]autorelease];
    [self initURLRequest:_request WithHost:host andAnother:nearbyRestaurants];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    NSDictionary *result = [self getResultWithRequest:_request];
    //    DataRetriever *shareDataRetrieve = [DataRetriever sharedRetriever];
    //    shareDataRetrieve.NearbyRestaurants = result;
    return result;
}

-(NSDictionary *)getFavoriteRestaurantsWithLatitude:(NSString *)latitude andLongitude:(NSString *)longitude andRadius:(NSString *)radius andIsPromoted:(NSString *)promotion withOther:(NSString *)userID
{
    NSDictionary *result = nil;
    NSString *post = nil;  
    post = [[NSString alloc] initWithFormat:@"user_id=%@&latitude=%@&longitude=%@&radius=%@&promotion=%@",userID, latitude,longitude,radius,promotion];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
    NSMutableURLRequest *_request = [[[NSMutableURLRequest alloc] init]autorelease];
    [self initURLRequest:_request WithHost:host andAnother:nearbyRestaurants];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    result = [self getResultWithRequest:_request];
    //    DataRetriever *shareDataRetrieve = [DataRetriever sharedRetriever];
    //    shareDataRetrieve.FavoriteRestaurants = result;
    return result;
}

-(NSDictionary *)getRestaurantMenuWithId:(NSString *)restaurantId andIsOnlyPromoted :(NSString *)promotion
{
    NSString *post = nil;  
    post = [[NSString alloc] initWithFormat:@"restaurant_id=%@&promotion=%@",restaurantId,promotion];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
    NSMutableURLRequest *_request = [[[NSMutableURLRequest alloc] init]autorelease];
    [self initURLRequest:_request WithHost:host andAnother:restaurantMenu];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    NSDictionary *result = [self getResultWithRequest:_request];
    //    DataRetriever *shareDataRetrieve = [DataRetriever sharedRetriever];
    //    shareDataRetrieve.RestaurantMenu = result;
    return result;
}

-(NSDictionary *)getFriendsWithUserID:(NSString *)user_id
{
    NSString *post = nil;  
    post = [[NSString alloc] initWithFormat:@"user_id=%@",user_id];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
    NSMutableURLRequest *_request = [[[NSMutableURLRequest alloc] init]autorelease];
    [self initURLRequest:_request WithHost:host andAnother:friends];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    NSDictionary *result = [self getResultWithRequest:_request];
    //    DataRetriever *shareDataRetrieve = [DataRetriever sharedRetriever];
    //    shareDataRetrieve.Friends = result;
    return result;
    
}

-(NSDictionary *)getOrderHistoryWith:(NSString *)user_id
{
    NSString *post = nil;  
    post = [[NSString alloc] initWithFormat:@"user_id=%@",user_id];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
    NSMutableURLRequest *_request = [[[NSMutableURLRequest alloc] init]autorelease];
    [self initURLRequest:_request WithHost:host andAnother:orderHistory];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    NSDictionary *result = [self getResultWithRequest:_request];
    //    DataRetriever *shareDataRetrieve = [DataRetriever sharedRetriever];
    //    shareDataRetrieve.OrderHistory = result;
    return result;
}

-(void)saveOrderWithUser:(NSString *)usename andID:(NSString *)userid andDataDetail:(NSString *)jsonFormData
{
    
}

//jsonFormCommet包括：foreign_id，user_id，rating，comments
-(int)saveOrderComment:(NSString *)jsonFormComment
{
    NSString *post = nil;  
    post = [[NSString alloc] initWithFormat:@"data=%@",jsonFormComment];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
    NSMutableURLRequest *_request = [[[NSMutableURLRequest alloc] init]autorelease];
    [self initURLRequest:_request WithHost:host andAnother:orderSave];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    NSDictionary *result = [self getResultWithRequest:_request];
    return [[result objectForKey:@"result"]intValue];
}

-(NSDictionary *)getOrderCommentWithOrderId:(NSString *)order_id
{
    NSString *post = nil;  
    post = [[NSString alloc] initWithFormat:@"order_id=%@",order_id];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
    NSMutableURLRequest *_request = [[[NSMutableURLRequest alloc] init]autorelease];
    [self initURLRequest:_request WithHost:host andAnother:orderComment];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    NSDictionary *result = [self getResultWithRequest:_request];
    return result;
}

//jsonFormDishComment包括：foreign_id，user_id，rating，comments
-(int)saveDishComment:(NSString *)jsonFormDishComment
{
    NSString *post = nil;  
    post = [[NSString alloc] initWithFormat:@"data=%@",jsonFormDishComment];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
    NSMutableURLRequest *_request = [[[NSMutableURLRequest alloc] init]autorelease];
    [self initURLRequest:_request WithHost:host andAnother:dishCommentSave];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    NSDictionary *result = [self getResultWithRequest:_request];
    return [[result objectForKey:@"result"]intValue];
}

-(NSDictionary *)getDishCommentWithDishId:(NSString *)dish_id
{
    NSString *post = nil;  
    post = [[NSString alloc] initWithFormat:@"dish_id=%@",dish_id];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
    NSMutableURLRequest *_request = [[[NSMutableURLRequest alloc] init]autorelease];
    [self initURLRequest:_request WithHost:host andAnother:dishComment];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:postData];
    NSDictionary *result = [self getResultWithRequest:_request];
    return result;
}

-(NSDictionary *)getDishNutritionWithDishId:(NSString *)dish_id
{
    NSString *DishNutrition = [NSString stringWithFormat:@"%@%@%@",dishNutritionFormer,dish_id,dishNutritionLatter];
    NSLog(@"%@",DishNutrition);  
    NSMutableURLRequest *_request = [[[NSMutableURLRequest alloc] init]autorelease];
    [_request setHTTPMethod:@"GET"];
    [_request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host,DishNutrition]]];
    NSDictionary *result = [self getResultWithRequest:_request];
    return result;
}


// synchronous code





@end
