//
//  SWFeedListController.h
//  StarWorld
//
//  Created by Aaron Baker on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Three20/Three20.h>
#import "SWCurrentUser.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKPointAnnotation.h>
#import "SWFeedDataSource.h"


@interface SWFeedListController : TTTableViewController <UIAlertViewDelegate> {
    SWCurrentUser *currentUser;
    MKMapView *mapView;
    SWFeedDataSource *feedDataSource;
}

@end
