//
//  SWCurrentUser.h
//  StarWorld
//
//  Created by Aaron Baker on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SWCurrentUser : NSObject <TTURLRequestDelegate> {
    NSString *cookie;
    NSString *username;
    NSString *password;
    NSMutableURLRequest *request;
    BOOL authenticated;
    float x;
    float y;
    NSMutableArray *starredPostIDs;
    TTURLRequest* getStarRequest;
    TTURLRequest* addStarRequest;
    TTURLRequest* removeStarRequest;
}

@property (nonatomic, copy) NSString *cookie;
@property (nonatomic, retain) NSMutableArray *starredPostIDs;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, retain) NSMutableURLRequest *request;
@property (nonatomic, assign) BOOL authenticated;
@property (assign) float x;
@property (assign) float y;
+ (SWCurrentUser*)currentUserInstance;
- (void) login;
- (void) logout;
- (void) setStarForPostID: (NSNumber*) postID;
- (void) removeStarForPostID: (NSNumber*) postID;


@end
