//
//  SWUnitConverter.h
//  StarWorld
//
//  Created by Aaron Baker on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SWUnitConverter : NSObject {
    
}

+ (NSString*)timeIntervalWithStartDate:(NSDate*)d1 withEndDate:(NSDate*)d2;
+ (NSString*) convertFromMeters: (float) distanceInMeters;
+ (NSString*) convertFromMetersRounded: (float) distanceInMeters;
@end
