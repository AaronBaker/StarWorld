//
//  SWFeedListController.m
//  StarWorld
//
//  Created by Aaron Baker on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "SWFeedListController.h"
#import "SWFeedDataSource.h"
#import <Foundation/Foundation.h>


@implementation SWFeedListController

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
    
    if ((self = [super init])) {
        
        self.tableViewStyle = UITableViewStylePlain;
        self.title = @"Near You";
        
        SWFeedDataSource *dataSource = [[[SWFeedDataSource alloc]
                                         initWithCoordinatesX:34 Y:12] autorelease]; 
        
        //This dummy view prevents empty cells from displaying
        self.tableView.tableFooterView = [[UIView new] autorelease];
        
        self.dataSource = dataSource;
        
    }
    return self;
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}



@end
