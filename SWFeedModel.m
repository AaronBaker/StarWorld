//
//  SWFeedModel.m
//  Starworld Test2
//
//  Created by Aaron Baker on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWFeedModel.h"
#import "SWPost.h"


#import <extThree20JSON/extThree20JSON.h>


static NSString* kSWBaseURL = @"http://pandora.starworlddata.com/posts/posts_json2/";

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation SWFeedModel

@synthesize posts           = _posts;
@synthesize resultsPerPage  = _resultsPerPage;
@synthesize finished        = _finished;
@synthesize page            = _page;
@synthesize xSearch         = _xSearch;
@synthesize ySearch         = _ySearch;


///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithX:(float)x Y:(float)y {
    if ((self = [super init])) {
        
        currentUser = [SWCurrentUser currentUserInstance];
        
        _xSearch = currentUser.x;
        _ySearch = currentUser.y;
        _resultsPerPage = 50;
        _page = 1;
        _posts = [[NSMutableArray array] retain];
        
    }

    
    return self;    
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
    TT_RELEASE_SAFELY(_posts);
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    if (!self.isLoading) {  //Something possible important was removed from here.
        if (more) {
            _page++;
        }
        else {
            _page = 1;
            _finished = NO;
            [_posts removeAllObjects];
        }
        
        //LATER: Modify url so that it actually searches using coordinates
        
        //NSString* url = [NSString stringWithFormat:kTwitterSearchFeedFormat, _searchQuery, _resultsPerPage, _page];
        
        NSString* url = [NSString stringWithFormat:@"%@%f/%f",kSWBaseURL,currentUser.y,currentUser.x];
        
        NSLog(@"URL: %@",url);
        
        TTURLRequest* request = [TTURLRequest
                                 requestWithURL: url
                                 delegate: self];
        
        
    
        
        request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
        
        TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];

        
        
        
        request.response = response;
        
        
        
        TT_RELEASE_SAFELY(response);
        
        [request send];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    
    
    TTURLJSONResponse* response = request.response;
    
    
    NSLog(@"JSON RESPONSE COOKIES");
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
        NSLog(@"name: '%@'\n",   [cookie name]);
        NSLog(@"value: '%@'\n",  [cookie value]);
        NSLog(@"domain: '%@'\n", [cookie domain]);
        NSLog(@"path: '%@'\n",   [cookie path]);
    }
    
    //TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSArray* sections = [response.rootObject objectForKey:@"posts"];
    
    
    //NSLog(@"ENTRIES: %@",entries);
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSMutableArray* posts = [NSMutableArray arrayWithCapacity:[sections count]];
    
    
    for (NSDictionary* entries in sections) {
        for (NSDictionary* entry in entries) {
            
       
            
            NSDictionary *entryPost = [entry objectForKey:@"Post"];
            NSDictionary *entryUser = [entry objectForKey:@"User"];
            
            NSDate* date = [dateFormatter dateFromString:[entryPost objectForKey:@"created"]];
            
            NSString *username = [entryUser objectForKey:@"username"];
            
            float entryX = [[entryPost objectForKey:@"x"] floatValue];
            float entryY = [[entryPost objectForKey:@"y"] floatValue];
            
            SWPost* post = [[SWPost alloc]initWithName:username 
                                                  time:date 
                                                     x:entryX
                                                     y:entryY
                                               content:[entryPost objectForKey:@"body"]];
            
            //NSLog(@"Body: %@",[entryPost objectForKey:@"body"]);

            [posts addObject:post];
            TT_RELEASE_SAFELY(post);
        }
    }
    _finished = posts.count < _resultsPerPage;
    [_posts addObjectsFromArray: posts];
    
    TT_RELEASE_SAFELY(dateFormatter);
    
    [super requestDidFinishLoad:request];
}











@end
