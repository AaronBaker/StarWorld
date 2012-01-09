//
//  MapTableCell.h
//  StarWorld
//
//  Created by Niki Bird on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Three20/Three20.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKPointAnnotation.h>

@interface MapTableCell : TTTableTextItemCell <MKMapViewDelegate> {
    
    MKMapView *mapView;
    NSMutableArray *annotationsArray;
    BOOL initialized;
    
}

@end
