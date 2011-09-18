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
    
}

- (void) logout {
    
    self.authenticated = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:NO forKey:kSWDefaultsKeyUserIsAuthenticated];  
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in [[[cookieStorage cookiesForURL:[NSURL URLWithString:@"http://pandora.starworlddata.com"]] copy] autorelease]) {
        [cookieStorage deleteCookie:each];
    }
    
    
    for (NSHTTPCookie *each in [[[cookieStorage cookiesForURL:[NSURL URLWithString:@"http://173.230.142.162"]] copy] autorelease]) {
        [cookieStorage deleteCookie:each];
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
