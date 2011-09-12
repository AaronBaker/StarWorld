//
//  SWFeedListController.m
//  StarWorld
//
//  Created by Aaron Baker on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "SWFeedListController.h"
#import "SWFeedDataSource.h"
#import "SWLoginViewController.h"


@implementation SWFeedListController

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
    
    if ((self = [super init])) {
        
        self.tableViewStyle = UITableViewStylePlain;
        self.title = @"Near You";
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                                  initWithBarButtonSystemItem: UIBarButtonSystemItemCompose
                                                  target:@"tt://newpost"
                                                  action: @selector(openURLFromButton:)] autorelease];
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
                                                   initWithBarButtonSystemItem: UIBarButtonSystemItemOrganize
                                                   target:@"tt://login"
                                                   action: @selector(openURLFromButton:)] autorelease];
        
        

        
        
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
