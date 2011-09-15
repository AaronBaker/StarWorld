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
@interface SWFeedDataSource : TTListDataSource {
    SWFeedModel* _searchFeedModel;
    SWCurrentUser *currentUser;
}

-(id)initWithCoordinatesX: (float) x Y:(float)y;

@end
