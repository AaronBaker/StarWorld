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
#import "SWAnnotation.h"

@interface MapTableCell (hidden)

- (NSArray*) getAnnotationsFromMapTableItem: (MapTableItem*) item;
- (void) addMKPointAnnotationToMapView:(MKPointAnnotation*)annotation;
- (MKMapRect) getMapRectUsingAnnotations:(NSArray*)theAnnotations;
- (void) zoomToAnnotation:(MKPointAnnotation*)annotation;

@end



@implementation MapTableCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	self = [super initWithStyle:style reuseIdentifier:identifier];
    
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 180)];

    
    [self addSubview:mapView];
    
    initialized = NO;
    
    return self;
    
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
    if (_item != object) {
        
        if (initialized == NO) {
        
            [super setObject:object];

            MapTableItem* item = object;
            [self getAnnotationsFromMapTableItem:item];

                    
            [mapView addAnnotations:annotationsArray];
            mapView.delegate = self;
           
            MKCoordinateRegion region = MKCoordinateRegionForMapRect([self getMapRectUsingAnnotations:annotationsArray]);
            
            if (region.span.latitudeDelta < 0.027) {
                region.span.latitudeDelta = 0.027;
            }
            
            if (region.span.longitudeDelta < 0.027) {
                region.span.longitudeDelta = 0.027;
            }
            [mapView setRegion:region];
            mapView.showsUserLocation = YES;
            
            
            self.textLabel.text = @"";
            
            initialized = YES;
        
        }

        
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray*) getAnnotationsFromMapTableItem: (MapTableItem*) item {
    

    NSArray *placemarkSections = item.itemList;
    
    annotationsArray = [[NSMutableArray alloc] init];
    int itemCount = 0;
    
    for (id placemarkSection in placemarkSections) {
        
        if (itemCount < 20) {
        
            
            for (id placemarkData in placemarkSection) {
                
                if ([placemarkData isKindOfClass:[SWPostTableItem class]]) {
                    
                    itemCount++;

                    
                    SWPostTableItem *placemarkItem = placemarkData;
                    
                                    
                    SWAnnotation *point = [[SWAnnotation alloc] init];
                    
                    CLLocationCoordinate2D pointCoords;
                    pointCoords.latitude = placemarkItem.y;
                    pointCoords.longitude = placemarkItem.x;
                    
                    point.coordinate = pointCoords;
                    point.title = placemarkItem.text;
                    
                    
                    //point.subtitle = placemarkItem.text;
                    
                    
                    //SWAnnotation *annotation = [SWAnnotation MKPointAnnotationWithCoordinate:[placemarkItem getCoordinate]];
                    
                    
                    
                    
                    [annotationsArray addObject:point];
                    
                    
                    
                    [point release];
                    
                    
                }
         
                
            }
        }
    }
    NSLog(@"item count: %d",itemCount);

    return annotationsArray;
    
}



- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    NSLog(@"I REALLY NEED THIS VIEW TO FIRE NOT SURE WHY ITS NOT");
    NSLog(@"ANNOTATION: %@",annotation);
    
    if ([annotation isKindOfClass:[SWAnnotation class]]) {
    
        MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
        annView.pinColor = MKPinAnnotationColorPurple;
        annView.animatesDrop=TRUE;
        annView.canShowCallout = YES;
        annView.calloutOffset = CGPointMake(-5, 5);
        
        UIButton *disclosureButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure]; 
        annView.canShowCallout = YES;    
        annView.rightCalloutAccessoryView = disclosureButton;
        
        
        return annView;
    } else {
        
        return nil;
    }
        
	
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectInset(self.contentView.bounds,
                                       kTableCellHPadding, kTableCellVPadding);
}



/* this simply adds a single pin and zooms in on it nicely */
- (void) zoomToAnnotation:(MKPointAnnotation*)annotation {
    MKCoordinateSpan span = {0.027, 0.027};
    MKCoordinateRegion region = {[annotation coordinate], span};
    [mapView setRegion:region animated:YES];
}

/* This returns a rectangle bounding all of the pins within the supplied
 array */
- (MKMapRect) getMapRectUsingAnnotations:(NSArray*)theAnnotations {
    MKMapPoint points[[theAnnotations count]];
    
    for (int i = 0; i < [theAnnotations count]; i++) {
        MKPointAnnotation *annotation = [theAnnotations objectAtIndex:i];
        points[i] = MKMapPointForCoordinate(annotation.coordinate);
    }
    
    MKPolygon *poly = [MKPolygon polygonWithPoints:points count:[theAnnotations count]];
    
    return [poly boundingMapRect];
}

/* this adds the provided annotation to the mapview object, zooming 
 as appropriate */
- (void) addMKPointAnnotationToMapView:(MKPointAnnotation*)annotation {
    if ([annotationsArray count] == 1) {
        // If there is only one annotation then zoom into it.
        [self zoomToAnnotation:annotation];
    } else {
        // If there are several, then the default behaviour is to show all of them
        //
        MKCoordinateRegion region = MKCoordinateRegionForMapRect([self getMapRectUsingAnnotations:annotationsArray]);
        
        if (region.span.latitudeDelta < 0.027) {
            region.span.latitudeDelta = 0.027;
        }
        
        if (region.span.longitudeDelta < 0.027) {
            region.span.longitudeDelta = 0.027;
        }
        [mapView setRegion:region];
    }
    
    [mapView addAnnotation:annotation];
    [mapView selectAnnotation:annotation animated:YES];
}





///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    // XXXjoe Compute height based on font sizes
    
    CGFloat cellHeight = 180;
    
    
    return cellHeight;
}








@end
