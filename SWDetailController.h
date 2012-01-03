//
//  SWDetailController.h
//  StarWorld
//
//  Created by Aaron Baker on 1/1/12.
//  Copyright (c) 2012 Inter Media Outdoors. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWPostTableItem.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKPointAnnotation.h>

@interface SWDetailController : UIViewController <MKMapViewDelegate> {
    
    MKMapView *mapView;
    MKPlacemark *mPlacemark;
    SWPostTableItem *item;
}

@property (nonatomic, retain) SWPostTableItem *item;

@end
