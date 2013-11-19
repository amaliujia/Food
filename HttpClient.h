//
//  HttpClient.h
//  OlixusSDK
//
//  Created by again on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol M4MHttpRequestDelegate;



typedef enum{
    M4MHttpRequestTypeLogin,
    M4MHttpRequestTypeGetNearbyRestaurants,
    M4MHttpRequestTypeGetFavoriteRestaurants,
    M4MHttpRequestTypeGetRestaurantMenu,
    M4MHttpRequestTypeGetFriends,
    M4MHttpRequestTypeGetOrderHistory,
    M4MHttpRequestTypeSaveOrder,
    M4MHttpRequestTypeSaveOrderComment,
    M4MHttpRequestTypeGetOrderComment,
    M4MHttpRequestTypeSaveDishComment,
    M4MHttpRequestTypeGetDishComent,
    M4MHttpRequestTypeGetDishNutrition,
    M4MHttpRequestTypeGetRestaurantLike
} M4MHttpRequestType;


@interface HttpClient : NSObject
{
    //    NSMutableURLRequest *request;
}


@property (nonatomic, retain) id<M4MHttpRequestDelegate> delegate;

-(void)initURLRequest:(NSMutableURLRequest *)_request WithHost:(const NSString *)_host andAnother:(const NSString *)_another;

-(NSDictionary *)getResultWithRequest:(NSMutableURLRequest *)_request;

//synchronous API function
-(NSDictionary *)loginWithUser:(NSString *)userName andPassword:(NSString *)passWord;
-(void)logout;
-(NSDictionary *)getNearbyRestaurantsWithLatitude:(NSString *)latitude andLongitude:(NSString *)longitude andRadius:(NSString *)radius andIsPromoted:(NSString *)promotion;
-(NSDictionary *)getFavoriteRestaurantsWithLatitude:(NSString *)latitude andLongitude:(NSString *)longitude andRadius:(NSString *)radius andIsPromoted:(NSString *)promotion withOther:(NSString *)userID;
-(NSDictionary *)getRestaurantMenuWithId:(NSString *)restaurantId andIsOnlyPromoted :(NSString *)promotion;
-(NSDictionary *)getFriendsWithUserID:(NSString *)user_id;
-(NSDictionary *)getOrderHistoryWith:(NSString *)user_id;
-(void)saveOrderWithUser:(NSString *)usename andID:(NSString *)userid andDataDetail:(NSString *)jsonFormData;
-(int)saveOrderComment:(NSString *)jsonFormComment;
-(NSDictionary *)getOrderCommentWithOrderId:(NSString *)order_id;
-(int)saveDishComment:(NSString *)jsonFormDishComment;
-(NSDictionary *)getDishCommentWithDishId:(NSString *)dish_id;
-(NSDictionary *)getDishNutritionWithDishId:(NSString *)dish_id;

// asynchronous api function
- (void)requestLoginWithUser:(NSString *)userName andPassword:(NSString *)passWord;
- (void)requestNearbyRestaurantsWithLatitude:(NSString *)latitude andLongitude:(NSString *)longitude andRadius:(NSString *)radius andIsPromoted:(NSString *)promotion;
- (void)requestFavoriteRestaurantsWithLatitude:(NSString *)latitude andLongitude:(NSString *)longitude andRadius:(NSString *)radius andIsPromoted:(NSString *)promotion withOther:(NSString *)userID;
- (void)requestRestaurantMenuWithId:(NSString *)restaurantId andIsOnlyPromoted :(NSString *)promotion;
- (void)requestFriendsWithUserID:(NSString *)user_id;
- (void)requestOrderHistoryWith:(NSString *)user_id;
- (void)requestSaveOrderWithUser:(NSString *)usename andID:(NSString *)userid andDataDetail:(NSString *)jsonFormData;
- (void)requestSaveOrderComment:(NSString *)jsonFormComment;
- (void)requestOrderCommentWithOrderId:(NSString *)order_id;
- (void)requestSaveDishComment:(NSString *)jsonFormDishComment;
- (void)requestDishCommentWithDishId:(NSString *)dish_id;
- (void)requestDishNutritionWithDishId:(NSString *)dish_id;
- (void)requestRestaurantLikeWithrestaurantId:(NSString *)restaurant_id andfavorite:(NSString *)favorite andUserid:(NSString *)user;

@end

@protocol M4MHttpRequestDelegate <NSObject>
@optional
- (void)M4MHttpRequestDidReceivedResult:(NSDictionary *)result withRequestType:(M4MHttpRequestType) requestType;

@end