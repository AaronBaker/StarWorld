//
//  Post.h
//  Starworld Test2
//
//  Created by Aaron Baker on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//




@interface SWPost : NSObject {
    NSString *name;
    NSString *content;
    float x;
    float y;
    NSDate *time;
    NSInteger ID;
    NSInteger starCount;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSDate *time;
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger starCount;


- (id)initWithName:(NSString *)postName 
              time:(NSDate *)postTime 
                 x:(float)postX 
                 y:(float)postY
                ID:(NSInteger)postID
         starCount:(NSInteger)postStarCount
           content:(NSString *)postContent;
@end
