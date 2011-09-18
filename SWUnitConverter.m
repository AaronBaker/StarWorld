//
//  SWUnitConverter.m
//  StarWorld
//
//  Created by Aaron Baker on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWUnitConverter.h"



@implementation SWUnitConverter


+ (NSString*) convertFromMeters: (float) distanceInMeters {
    
    #define FEET 1
    #define HALFMILE (2640 * FEET)
    #define MILES (5280 * FEET)
    
    #define METER 1
    #define HALFKILOMETER (METER * 500)
    #define KILOMETER (METER * 1000)
    
    //Hopefully, this does not cause performance issues later
    BOOL isMetric = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
    
    if (isMetric) {
        
        if (distanceInMeters < 500) {
            return [NSString stringWithFormat:@"%d meters", (int)round(distanceInMeters)];
        } else {
            return [NSString stringWithFormat:@"%.1f km", round(2.0f * (distanceInMeters / KILOMETER)) / 2.0f];
        }
        
    } else {
        
        float distanceInFeet = distanceInMeters * 3.2808;
        
        if (distanceInFeet < 1000) {
            
            return [NSString stringWithFormat:@"%d feet", (int)round(distanceInFeet)];
            
        } else {
            return [NSString stringWithFormat:@"%.1f miles", round(2.0f * (distanceInFeet / MILES)) / 2.0f];
        }
        
        
        
    }
        

    
}

@end
