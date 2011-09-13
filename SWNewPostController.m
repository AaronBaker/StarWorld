//
//  SWNewPostController.m
//  StarWorld
//
//  Created by Aaron Baker on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWNewPostController.h"
#import "PRPFormEncodedPOSTRequest.h"

static NSString* kSWNewPostURL = @"http://173.230.142.162/posts/add";

@implementation SWNewPostController

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {

    if ((self = [super init])) {
        self.delegate = self;
    }
    
    currentUser = [SWCurrentUser currentUserInstance];    
    
    return self;
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)postController:(TTPostController *)postController 
           didPostText:(NSString *)text 
            withResult:(id)result { 
    NSLog(@"Text: %@", text); 
    NSLog(@"current x: %f",currentUser.x);
    
    NSString *xString = [NSString stringWithFormat:@"%f",currentUser.x];
    NSString *yString = [NSString stringWithFormat:@"%f",currentUser.y];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:text forKey:@"data[Post][body]"];
    [params setObject:xString forKey:@"data[Post][x]"];
    [params setObject:yString forKey:@"data[Post][y]"];
    
    NSURL *postURL = [NSURL URLWithString:kSWNewPostURL];
    
    currentUser.request = [PRPFormEncodedPOSTRequest requestWithURL:postURL
                                                     formParameters:params];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:currentUser.request
                                                 returningResponse:&response
                                                             error:&error];
    if (responseData) {
        
        NSLog(@"POSTED PERHAPS");
        NSLog(@"RESPONSE DATA: %@",[NSString stringWithCString:[responseData bytes] encoding:NSUTF8StringEncoding]);
        
        
    } else {
        NSLog(@"Error posting to %@ (%@)", kSWNewPostURL, error);
    }
    
    
} 


@end
