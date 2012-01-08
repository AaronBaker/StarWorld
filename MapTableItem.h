//
//  MapTableItem.h
//  StarWorld
//
//  Created by Niki Bird on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Three20/Three20.h>

@interface MapTableItem : TTTableTextItem {
    
    NSArray *itemList;
}

@property (nonatomic,retain) NSArray *itemList;

+ (id) mapItemWithItems: (NSArray*) items;


@end
