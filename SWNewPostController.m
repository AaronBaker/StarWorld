//
//  SWNewPostController.m
//  StarWorld
//
//  Created by Aaron Baker on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWNewPostController.h"
#import "PRPFormEncodedPOSTRequest.h"

static NSString* kSWNewPostURL = @"http://pandora.starworlddata.com/posts/add";

@implementation SWNewPostController

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {

    if ((self = [super init])) {
        self.delegate = self;
        
        currentUser = [SWCurrentUser currentUserInstance];
        

        
        if (!currentUser.authenticated) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"You need to log in before you can post." 
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
    }
    
        
    
    return self;
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)postController:(TTPostController *)postController 
           didPostText:(NSString *)text 
            withResult:(id)result { 
    

    
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
