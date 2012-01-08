//
//  MapTableCell.m
//  StarWorld
//
//  Created by Niki Bird on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapTableCell.h"
#import "MapTableItem.h"
#import "SWPostTableItem.h"


@implementation MapTableCell

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	self = [super initWithStyle:style reuseIdentifier:identifier];
    
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 180)];
    
   
    
    [self addSubview:mapView];
    
    
    
    return self;
    
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
    if (_item != object) {
        [super setObject:object];
        MapTableItem* item = object;
        
        
        NSArray *placemarkSections = item.itemList;
        
        NSLog(@"THIS IS THE KEY:");
        
        for (id placemarkSection in placemarkSections) {
            for (SWPostTableItem* placemarkData in placemarkSection) {
                NSLog(@"%@",placemarkData.text);
                
            }
        }
        
        
        self.textLabel.text = @"BEACH CHEESE";
        
        
        
        

        
    }
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectInset(self.contentView.bounds,
                                       kTableCellHPadding, kTableCellVPadding);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    // XXXjoe Compute height based on font sizes
    
    CGFloat cellHeight = 180;
    
    
    return cellHeight;
}


@end
