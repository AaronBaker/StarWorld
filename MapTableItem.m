//
//  MapTableItem.m
//  StarWorld
//
//  Created by Niki Bird on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapTableItem.h"

@implementation MapTableItem
@synthesize itemList;
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id) mapItemWithItems: (NSArray*) items {
    
    MapTableItem *mapItem = [[[self alloc] init] autorelease];
    mapItem.itemList = items;
    
    
    return mapItem;
}



@end
