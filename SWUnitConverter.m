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



///////////////////////////////////////////////////////////////////////////////////////////////////
//Constants
#define SECOND 1
#define MINUTE (60 * SECOND)
#define HOUR (60 * MINUTE)
#define DAY (24 * HOUR)
#define MONTH (30 * DAY)

+ (NSString*)timeIntervalWithStartDate:(NSDate*)d1 withEndDate:(NSDate*)d2
{
    
    //Calculate the delta in seconds between the two dates
    NSTimeInterval delta = [d2 timeIntervalSinceDate:d1];
    
    if (delta < 1 * SECOND)
        delta = 1;
    
    if (delta < 1 * MINUTE)
    {
        return delta == 1 ? @"1 second" : [NSString stringWithFormat:@"%d seconds", (int)delta];
    }
    if (delta < 2 * MINUTE)
    {
        return @"1 min";
    }
    if (delta < 45 * MINUTE)
    {
        int minutes = floor((double)delta/MINUTE);
        return [NSString stringWithFormat:@"%d mins", minutes];
    }
    if (delta < 90 * MINUTE)
    {
        return @"1 hour";
    }
    if (delta < 24 * HOUR)
    {
        int hours = floor((double)delta/HOUR);
        return [NSString stringWithFormat:@"%d hours", hours];
    }
    if (delta < 48 * HOUR)
    {
        return @"1 day";
    }
    if (delta < 30 * DAY)
    {
        int days = floor((double)delta/DAY);
        return [NSString stringWithFormat:@"%d days", days];
    }
    if (delta < 12 * MONTH)
    {
        int months = floor((double)delta/MONTH);
        return months <= 1 ? @"1 month" : [NSString stringWithFormat:@"%d months", months];
    }
    else
    {
        int years = floor((double)delta/MONTH/12.0);
        return years <= 1 ? @"1 year" : [NSString stringWithFormat:@"%d years", years];
    }
}




@end
