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
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title 
            caption:(NSString*)caption 
               text:(NSString*)text
          timestamp:(NSDate*)timestamp 
                 ID:(NSInteger)itemID
                URL:(NSString*)URL {
    SWPostTableItem* item = [[[self alloc] init] autorelease];
    item.title = title;
    item.caption = caption;
    item.text = text;
    item.timestamp = timestamp;
    item.ID = itemID;
    item.URL = URL;
    return item;
}


@end
