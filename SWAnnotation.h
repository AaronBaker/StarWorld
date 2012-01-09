//
//  SWAnnotation.h
//  StarWorld
//
//  Created by Niki Bird on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKPointAnnotation.h>

@interface SWAnnotation : NSObject <MKAnnotation> {
    
@private    
    
	CLLocationCoordinate2D _coordinate;
	NSString * _title;
	NSString * _subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

+ (SWAnnotation *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate;
+ (SWAnnotation *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle;
+ (SWAnnotation *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle;

- (SWAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate;
- (SWAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle;
- (SWAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle;

@end
