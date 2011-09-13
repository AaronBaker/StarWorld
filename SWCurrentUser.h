//
//  SWCurrentUser.h
//  StarWorld
//
//  Created by Aaron Baker on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SWCurrentUser : NSObject {
    NSString *cookie;
    NSString *username;
    NSString *password;
    NSMutableURLRequest *request;
    BOOL authenticated;
    float x;
    float y;
}

@property (nonatomic, copy) NSString *cookie;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, retain) NSMutableURLRequest *request;
@property (nonatomic, assign) BOOL authenticated;
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
+ (SWCurrentUser*)currentUserInstance;

@end
