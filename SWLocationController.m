//
//  SWLocationController.m
//  StarWorld
//
//  Created by Aaron Baker on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWLocationController.h"

@implementation SWLocationController

@synthesize locationManager;

- (id) init {
    self = [super init];
    
    currentUser = [SWCurrentUser currentUserInstance];
    
    if (self != nil) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self; // send loc updates to myself
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    currentUser.x = newLocation.coordinate.longitude;
    currentUser.y = newLocation.coordinate.latitude;
    
    NSLog(@"NEW LOCATION! x: %f, y: %f",currentUser.x,currentUser.y);
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	NSLog(@"**********************Location Error: %@", [error description]);
}

- (void)dealloc {
    [self.locationManager release];
    [super dealloc];
}

@end
