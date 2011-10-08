 //
//  Post.m
//  Starworld Test2
//
//  Created by Aaron Baker on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWPost.h"


@implementation SWPost

@synthesize name;
@synthesize content;
@synthesize x;
@synthesize y;
@synthesize time;
@synthesize ID;

- (id)initWithName:(NSString *)postName 
              time:(NSDate *)postTime 
                 x:(float)postX 
                 y:(float)postY
            ID:(NSInteger)postID
           content:(NSString *)postContent {
    
    if ((self = [super init])) {
        
        self.name = postName;
        self.content = postContent;
        self.x = postX;
        self.y = postY;
        self.ID = postID;
        self.time = postTime;
        
    }
    return self;
    
    
    
}
@end
