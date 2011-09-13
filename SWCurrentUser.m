//
//  SWCurrentUser.m
//  StarWorld
//
//  Created by Aaron Baker on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWCurrentUser.h"



@implementation SWCurrentUser

@synthesize cookie;
@synthesize username;
@synthesize password;
@synthesize request;
@synthesize authenticated;
@synthesize x;
@synthesize y;

+ (SWCurrentUser*)currentUserInstance{
    static SWCurrentUser *currentUserInstance;
	
	@synchronized(self) {
		if(!currentUserInstance) {
			currentUserInstance = [[SWCurrentUser alloc] init];
		}
	}
	
	return currentUserInstance;
    
}

- (void) dealloc {
	[super dealloc];
}

@end
