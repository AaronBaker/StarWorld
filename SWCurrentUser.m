//
//  SWCurrentUser.m
//  StarWorld
//
//  Created by Aaron Baker on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWCurrentUser.h"
#import <extThree20JSON/extThree20JSON.h>

static NSString *const kSWDefaultsKeyUserIsAuthenticated = @"sw_user_is_authenticated";


@interface SWCurrentUser (hidden)

-(void)getStars;

@end


@implementation SWCurrentUser



@synthesize cookie;
@synthesize username;
@synthesize password;
@synthesize request;
@synthesize authenticated;
@synthesize x;
@synthesize y;
@synthesize starredPostIDs;

+ (SWCurrentUser*)currentUserInstance{
    static SWCurrentUser *currentUserInstance;

    
	@synchronized(self) {
		if(!currentUserInstance) {
			
            currentUserInstance = [[SWCurrentUser alloc] init];
            currentUserInstance.starredPostIDs = [[NSMutableArray alloc] init];
            

		}
	}
	
	return currentUserInstance;
    
}

////////////////////////////////////////////////////////////////////////////////
- (void) login {
    
    self.authenticated = YES;
    
    //self.username = @"Aaron";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:YES forKey:kSWDefaultsKeyUserIsAuthenticated];  
    
    
    
    for (NSHTTPCookie *newCookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {

        NSLog(@"New Cookie Value: '%@'\n",  [newCookie value]);

        self.cookie = [newCookie value];
    }
    
    
    [self getStars];
    
    
}
////////////////////////////////////////////////////////////////////////////////
- (void) logout {
    
    self.authenticated = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:NO forKey:kSWDefaultsKeyUserIsAuthenticated];  
    
    NSLog(@"Trying to Delete Cookies!");
    
    
    for (NSHTTPCookie *dcookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        NSLog(@"Delete Cookie: %@",dcookie);

        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:dcookie];
        
    }
    
    [self.starredPostIDs removeAllObjects];
    
    NSLog(@"LOGOUT!");
    
}





////////////////////////////////////////////////////////////////////////////////


- (NSString *)description
{
    return [NSString stringWithFormat:@"CURRENT USER\nName: %@ \n Current X: %f\nCurrent Y: %f \n AUTH: %d\n",self.username,self.x,self.y,self.authenticated];
}




- (void) dealloc {
	
    [starredPostIDs release];
    [super dealloc];
}


////////////////////////////////////////////////////////////////////////////////
- (void) setStarForPostID: (NSNumber*) postID {
    
    
    //First add the star to the local array
    [self.starredPostIDs addObject:postID];
    
    //Then, we add the star to the server
    NSString *addStarURL = [NSString stringWithFormat:@"http://pandora.starworlddata.com/posts/add_star/%@",postID];
    
    
    addStarRequest = [TTURLRequest requestWithURL: addStarURL
                                         delegate: self];
    addStarRequest.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    addStarRequest.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    
    
    
    addStarRequest.response = [[[TTURLDataResponse alloc] init] autorelease];
    
    [addStarRequest send];
    
}


////////////////////////////////////////////////////////////////////////////////
- (void) removeStarForPostID: (NSNumber*) postID {
    
    
    //First remove the star from the local array
    [self.starredPostIDs removeObject:postID];
    
    //Then, remove the star from the server
    NSString *removeStarURL = [NSString stringWithFormat:@"http://pandora.starworlddata.com/posts/remove_star/%@",postID];
    
    
    removeStarRequest = [TTURLRequest requestWithURL: removeStarURL
                                         delegate: self];
    
    removeStarRequest.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    removeStarRequest.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    
    
    
    removeStarRequest.response = [[[TTURLDataResponse alloc] init] autorelease];
    
    [removeStarRequest send];    
    
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void) getStars {
    
    
    
    getStarRequest = [TTURLRequest requestWithURL: @"http://pandora.starworlddata.com/users/get_stars"
                                                   delegate: self];
    
    getStarRequest.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    getStarRequest.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    
    
    
    getStarRequest.response = [[[TTURLJSONResponse alloc] init] autorelease];
    
    [getStarRequest send];
    
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTURLRequestDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidStartLoad:(TTURLRequest*)request {

}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)URLrequest {
    
    
    //If we are retreving a list of stars, do this:
    if ([URLrequest isEqual:getStarRequest]) {
        NSLog(@"IT IS SO EQUAl!");
        
        
        TTURLJSONResponse* response = URLrequest.response;
        
        NSDictionary *starsDict = [response.rootObject objectForKey:@"stars"];
        
        for (NSArray *starKey in starsDict) {
            
            NSString *starPostIDString = [starsDict objectForKey:starKey];
            
            NSNumber *starPostID = [NSNumber numberWithInt:[starPostIDString integerValue]];
            
            
            [self setStarForPostID:starPostID];
            
        }
        
    }
    
    
    
    
    
    

}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
}






@end
