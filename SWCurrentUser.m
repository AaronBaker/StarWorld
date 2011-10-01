//
//  SWCurrentUser.m
//  StarWorld
//
//  Created by Aaron Baker on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWCurrentUser.h"


static NSString *const kSWDefaultsKeyUserIsAuthenticated = @"sw_user_is_authenticated";

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

- (void) login {
    
    self.authenticated = YES;
    
    self.username = @"Aaron";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:YES forKey:kSWDefaultsKeyUserIsAuthenticated];  
    
    
    
    for (NSHTTPCookie *newCookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {

        NSLog(@"New Cookie Value: '%@'\n",  [newCookie value]);

        
        self.cookie = [newCookie value];
    }
    
    
    
    
    
}

- (void) logout {
    
    self.authenticated = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:NO forKey:kSWDefaultsKeyUserIsAuthenticated];  
    
    NSLog(@"Trying to Delete Cookies!");
    
    
    for (NSHTTPCookie *dcookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        NSLog(@"Delete Cookie: %@",dcookie);

        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:dcookie];
        
    }
    

    
    NSLog(@"LOGOUT!");
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"CURRENT USER\nName: %@ \n Current X: %f\nCurrent Y: %f \n AUTH: %d\n",self.username,self.x,self.y,self.authenticated];
}


- (void) dealloc {
	[super dealloc];
}

@end
