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


static NSString* kSWBaseURL = @"http://www.starworld.com.php5-21.websitetestlink.com/posts.json";

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

- (id)initWithX: (float) x Y:(float)y {
    if ((self = [super init])) {
        _xSearch = x;
        _ySearch = y;
        _resultsPerPage = 10;
        _page = 1;
        _posts = [[NSMutableArray array] retain];
    }
    
    NSLog(@"INIT MODEL");
    
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
        
        NSLog(@"FEED MODEL LOAD");
        
        //LATER: Modify url so that it actually searches using coordinates
        
        //NSString* url = [NSString stringWithFormat:kTwitterSearchFeedFormat, _searchQuery, _resultsPerPage, _page];
        
        NSString* url = kSWBaseURL;
        
        TTURLRequest* request = [TTURLRequest
                                 requestWithURL: url
                                 delegate: self];
        
        NSLog(@"Request: %@",request);
        
        
        request.cachePolicy = cachePolicy;
        request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
        
        TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
        
        NSLog(@"Response: %@",response);
        
        
        request.response = response;
        TT_RELEASE_SAFELY(response);
        
        [request send];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    
    NSLog(@"FEED MODEL FINISH LOAD");
    
    TTURLJSONResponse* response = request.response;
    
    
    
    //TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSArray* entries = response.rootObject;
    
    
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"EEE, dd MMMM yyyy HH:mm:ss ZZ"];
    
    NSMutableArray* posts = [NSMutableArray arrayWithCapacity:[entries count]];
    
    for (NSDictionary* entry in entries) {
        
        NSDictionary *entryData = [entry objectForKey:@"Post"];

        NSDate* date = [dateFormatter dateFromString:[entryData objectForKey:@"created"]];

        SWPost* post = [[SWPost alloc]initWithName:@"Aaron" 
                                              time:date 
                                                 x:43.25 
                                                 y:76.34 
                                           content:[entryData objectForKey:@"title"]];
        
        
        //post.content = @"bob";
        NSLog(@"Post Content: %@",post.content);
        
        [posts addObject:post];
        TT_RELEASE_SAFELY(post);
    }
    _finished = posts.count < _resultsPerPage;
    [_posts addObjectsFromArray: posts];
    
    TT_RELEASE_SAFELY(dateFormatter);
    
    [super requestDidFinishLoad:request];
}











@end
