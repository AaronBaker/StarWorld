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


static NSString* kSWBaseURL = @"http://pandora.starworlddata.com/posts";
static NSString* kSWFeedPath = @"posts_json";
static NSString* kSWStarPath = @"posts_starred_json";
static NSString* kSWRemotePath = @"mapquery_json";

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation SWFeedModel

@synthesize posts           = _posts;
@synthesize resultsPerPage  = _resultsPerPage;
@synthesize finished        = _finished;
@synthesize page            = _page;
@synthesize searchRemote;
@synthesize locationTop;
@synthesize locationBottom;
@synthesize locationLeft;
@synthesize locationRight;


///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithStarred:(BOOL)starred {
    if ((self = [super init])) {
        
        currentUser = [SWCurrentUser currentUserInstance];
        

        _resultsPerPage = 50;
        _page = 1;
        _posts = [[NSMutableArray array] retain];
        
        showStarred = starred;
        
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
    
        
        NSString* dataPath = kSWFeedPath;
        NSString* url;
        if (showStarred)
            dataPath = kSWStarPath;
        
        if (searchRemote) {
            dataPath = kSWRemotePath;
            url = [NSString stringWithFormat:@"%@/%@/%f/%f/%f/%f",kSWBaseURL,dataPath,locationLeft,locationRight,locationTop,locationBottom];
        } else {
        
        
        url = [NSString stringWithFormat:@"%@/%@/%f/%f",kSWBaseURL,dataPath,currentUser.y,currentUser.x];
        }
        
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
    
    
//    NSLog(@"JSON RESPONSE COOKIES");
//    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
//    {
//        NSLog(@"name: '%@'\n",   [cookie name]);
//        NSLog(@"value: '%@'\n",  [cookie value]);
//        NSLog(@"domain: '%@'\n", [cookie domain]);
//        NSLog(@"path: '%@'\n",   [cookie path]);
//    }
    
    //TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSArray* responseSections = [response.rootObject objectForKey:@"posts"];
    
    
    
    
    //NSLog(@"ENTRIES: %@",entries);
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSMutableArray* sections = [NSMutableArray arrayWithCapacity:[responseSections count]];
    
    for (NSDictionary* entries in responseSections) {
        
        
        NSMutableArray* posts = [NSMutableArray arrayWithCapacity:[entries count]];
        
        for (NSDictionary* entry in entries) {
            
       
            
            NSDictionary *entryPost = [entry objectForKey:@"Post"];
            NSDictionary *entryUser = [entry objectForKey:@"User"];
            
            NSDate* date = [dateFormatter dateFromString:[entryPost objectForKey:@"created"]];
            
            NSString *username = [entryUser objectForKey:@"username"];
            
            float entryX = [[entryPost objectForKey:@"x"] floatValue];
            float entryY = [[entryPost objectForKey:@"y"] floatValue];
            
            NSInteger postID = [[entryPost objectForKey:@"id"] intValue];
            NSInteger postStarCount = [[entryPost objectForKey:@"star_count"] intValue];
            
            SWPost* post = [[SWPost alloc]initWithName:username 
                                                  time:date 
                                                     x:entryX
                                                     y:entryY
                                                    ID:postID 
                                             starCount:postStarCount
                                               content:[entryPost objectForKey:@"body"]];
            
            //NSLog(@"Body: %@",[entryPost objectForKey:@"body"]);
            
            //NSLog(@"POST ID: %d",postID);

            [posts addObject:post];
            TT_RELEASE_SAFELY(post);
        }
        
        [sections addObject:posts];
        
    }
    //_finished = posts.count < _resultsPerPage;
    _finished = YES;

    
    [_posts addObjectsFromArray: sections];
    
    TT_RELEASE_SAFELY(dateFormatter);
    
    [super requestDidFinishLoad:request];
}











@end
