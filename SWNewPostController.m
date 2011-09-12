//
//  SWNewPostController.m
//  StarWorld
//
//  Created by Aaron Baker on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWNewPostController.h"


@implementation SWNewPostController

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
    
    if ((self = [super init])) {
        self.delegate = self;
    }
    return self;
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)postController:(TTPostController *)postController 
           didPostText:(NSString *)text 
            withResult:(id)result { 
    NSLog(@"Text: %@", text); 
} 


@end
