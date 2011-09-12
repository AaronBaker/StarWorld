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
    BOOL authenticated;
}

@property (nonatomic, copy) NSString *cookie;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) BOOL authenticated;

+ (SWCurrentUser*)currentUserInstance;

@end
