//
//  SWDataSource.h
//  Starworld Test2
//
//  Created by Aaron Baker on 8/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "SWCurrentUser.h"

@class SWFeedModel;

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface SWFeedDataSource : TTSectionedDataSource <UIAlertViewDelegate> {
    SWFeedModel* _searchFeedModel;
    SWCurrentUser *currentUser;
    BOOL showStarred;
    NSMutableArray *myItems;
    NSMutableArray *mySections;
}

-(id)initWithStarred:(BOOL) starred;

@property (atomic,retain) NSMutableArray *myItems;

@end
