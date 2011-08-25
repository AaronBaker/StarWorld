//
//  Post.h
//  Starworld Test2
//
//  Created by Aaron Baker on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SWPost : NSObject {
    NSString *name;
    NSString *content;
    float x;
    float y;
    NSDate *time;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSDate *time;
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;


- (id)initWithName:(NSString *)name time:(NSDate *)time x:(float)x y:(float)y content:(NSString *)content;

@end
