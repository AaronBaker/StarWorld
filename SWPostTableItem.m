//
//  SWPostTableItem.m
//  StarWorld
//
//  Created by Aaron Baker on 10/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SWPostTableItem.h"

@implementation SWPostTableItem
@synthesize ID;
@synthesize starCount;
@synthesize x;
@synthesize y;
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title 
            caption:(NSString*)caption 
               text:(NSString*)text
          timestamp:(NSDate*)timestamp 
                 ID:(NSInteger)itemID
          starcount:(NSInteger)itemStarCount
                  x:(float)x
                  y:(float)y
                URL:(NSString*)URL {
    SWPostTableItem* item = [[[self alloc] init] autorelease];
    item.title = title;
    item.caption = caption;
    item.text = text;
    item.timestamp = timestamp;
    item.ID = itemID;
    item.starCount = itemStarCount;
    item.URL = URL;
    item.x = x;
    item.y = y;
    return item;
}

- (NSString*) description {
    
    return [NSString stringWithFormat:@"X: %f, Y: %f, TEXT: %@",self.x,self.y,self.text];
    
}


- (CLLocationCoordinate2D) getCoordinate {
    
    CLLocationCoordinate2D coord;
    
    coord.latitude = self.y;
    coord.longitude = self.x;
    
    return coord;
    
    
}

@end
