//
//  SWPostTableItem.h
//  StarWorld
//
//  Created by Aaron Baker on 10/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Three20/Three20.h>


@interface SWPostTableItem : TTTableMessageItem {
    
    NSInteger ID;
    NSInteger starCount;
    float x;
    float y;
    
}

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger starCount;
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;

+ (id)itemWithTitle:(NSString*)title 
            caption:(NSString*)caption 
               text:(NSString*)text
          timestamp:(NSDate*)timestamp 
                 ID:(NSInteger)itemID
          starcount:(NSInteger)itemStarCount
                  x:(float)x
                  y:(float)y
                URL:(NSString*)URL;

- (NSString*) description;

- (CLLocationCoordinate2D) getCoordinate;

@end


