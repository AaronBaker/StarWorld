//
//  SWFeedModel.h
//  Starworld Test2
//
//  Created by Aaron Baker on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWCurrentUser.h"

@interface SWFeedModel : TTURLRequestModel {

    
    NSMutableArray*  _posts;
    
    NSUInteger _page;             // page of search request
    
    NSUInteger _resultsPerPage;   // results per page, once the initial query is made
                                  // this value shouldn't be changed
    BOOL _finished;
    
    SWCurrentUser *currentUser;
    
    BOOL showStarred;
    
    BOOL searchRemote;
    
    CLLocationDegrees locationTop;
    CLLocationDegrees locationBottom;
    CLLocationDegrees locationLeft;
    CLLocationDegrees locationright;
    

}


@property (nonatomic, retain) NSMutableArray* posts;
@property (nonatomic, assign)   NSUInteger      resultsPerPage;

@property (nonatomic)   NSUInteger      page;

@property (nonatomic, readonly) BOOL            finished;
@property (atomic, assign) BOOL searchRemote;

@property CLLocationDegrees locationTop;
@property CLLocationDegrees locationBottom;
@property CLLocationDegrees locationLeft;
@property CLLocationDegrees locationRight;

- (id)initWithStarred:(BOOL) starred;

@end
