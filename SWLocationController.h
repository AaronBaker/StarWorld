//
//  SWLocationController.h
//  StarWorld
//
//  Created by Aaron Baker on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWCurrentUser.h"


@interface SWLocationController : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    SWCurrentUser *currentUser;
}

@property (nonatomic, retain) CLLocationManager *locationManager;  
@property (nonatomic, retain) SWCurrentUser *currentUser;




+ (SWLocationController*)locationControllerInstance;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;


@end
