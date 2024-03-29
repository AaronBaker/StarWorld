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
#import "SWPostTableItem.h"
#import "SWAnnotationCallout.h"

@interface SWFeedListController : TTTableViewController <UIAlertViewDelegate,SWFeedDataSourceDelegate,MKMapViewDelegate> {
    SWCurrentUser *currentUser;
    MKMapView *mapView;
    SWFeedDataSource *feedDataSource;
    CLLocationDegrees lastLatitude;
    CLLocationDegrees lastLongitude;
    CLLocationDegrees lastLatitudeDelta;
    CLLocationDegrees lastLongitudeDelta;
    
    CLLocationDegrees currentLatitude;
    CLLocationDegrees currentLongitude;
    CLLocationDegrees currentLatitudeDelta;
    CLLocationDegrees currentLongitudeDelta;
    
    
    BOOL searchRemote;
    NSMutableArray *annotations;
    NSMutableDictionary *annotationsDictionary;
    
    UIButton *fullScreenButton;
    UIButton *locationLockButton;
}

@end
