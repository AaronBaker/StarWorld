//
//  SWDataSource.m
//  Starworld Test2
//
//  Created by Aaron Baker on 8/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWFeedDataSource.h"

#import "SWFeedModel.h"
#import "SWPost.h"
#import "SWUnitConverter.h"
#import "SWPostTableCell.h"
#import "SWPostTableItem.h"


// Three20 Additions
#import <Three20Core/NSDateAdditions.h>


@interface SWFeedDataSource (hidden)

- (NSString*)timeIntervalWithStartDate:(NSDate*)d1 withEndDate:(NSDate*)d2;

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SWFeedDataSource

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id)initWithCoordinatesX: (float) x Y:(float)y {
    if ((self = [super init])) {
        

        
        _searchFeedModel = [[SWFeedModel alloc] initWithX: x Y: y];

        
        
        

    }
    
    return self;    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_searchFeedModel);
    
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<TTModel>)model {
    return _searchFeedModel;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableViewDidLoadModel:(UITableView*)tableView {
    
    NSMutableArray* items = [[NSMutableArray alloc] init];
    NSMutableArray* sections = [[NSMutableArray alloc] init];

    
    currentUser = [SWCurrentUser currentUserInstance];

    
    CLLocationDegrees currentX = currentUser.x;
    CLLocationDegrees currentY = currentUser.y;
    
    CLLocationDegrees postX;
    CLLocationDegrees postY;
    
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentY longitude:currentX];
    CLLocation *postLocation;
    
    float distance;
    
    NSString *distanceString;
    NSString *sectionsString;
    
    //[sections addObject:@"GOLD"];
    
    
    
    
    
    
    for (NSMutableArray* dataSections in _searchFeedModel.posts) {
        
        
        if ([dataSections count] > 0) {
        
            
                        
            NSMutableArray* itemListMutable = [[NSMutableArray alloc] initWithCapacity:[dataSections count]];
            NSArray* itemList;
            
            //Before going through the posts, we first get the title for the label
            
            float highestDistance = 0.0;
            int postCount = 0;
            for (SWPost* post in dataSections) {
                
                postCount++;
                postX = post.x;
                postY = post.y;
                
                postLocation = [[CLLocation alloc] initWithLatitude:postY longitude:postX];
                distance = [currentLocation distanceFromLocation:postLocation];
                [postLocation release];
                
                
                
                if (distance > highestDistance) {
                    highestDistance = distance;
                }
            }
            
                        
            distanceString = [SWUnitConverter convertFromMetersRounded:highestDistance];
            
            
            if (postCount == 1) {
                sectionsString = [NSString stringWithFormat:@"%d post within %@",postCount,distanceString];
            } else {
                sectionsString = [NSString stringWithFormat:@"%d posts within %@",postCount,distanceString];

            }
                        
            [sections addObject:sectionsString];
            
            
            //Build each post an add them to the item list.
            for (SWPost* post in dataSections) {
                //TTDPRINT(@"Response text: %@", response.text);
                
                
                postX = post.x;
                postY = post.y;
                
                
                
                postLocation = [[CLLocation alloc] initWithLatitude:postY longitude:postX];
                
                distance = [currentLocation distanceFromLocation:postLocation];
                
                [postLocation release];
                
                distanceString = [SWUnitConverter convertFromMeters:distance];


                [itemListMutable addObject: [SWPostTableItem itemWithTitle:post.name 
                                                                   caption:distanceString 
                                                                      text:[[post.content stringByReplacingOccurrencesOfString:@"&"
                                                                                                                    withString:@"&amp;"]
                                                                            stringByReplacingOccurrencesOfString:@"<"
                                                                            withString:@"&lt;"] 
                                                                 timestamp:post.time 
                                                                        ID:post.ID 
                                                                       URL:nil]];
            }
            
            
            itemList = [NSArray arrayWithArray:itemListMutable];
            [items addObject:itemList];
            
        }
        
        
    }
    
//    if (!_searchFeedModel.finished) {
//        [items addObject:[TTTableMoreButton itemWithText:@"more…"]];
//    }
    
    self.items = items;
    self.sections = sections;
    
 
    
    TT_RELEASE_SAFELY(items);
    TT_RELEASE_SAFELY(sections);
}
///////////////////////////////////////////////////////////////////////////////////////////////////

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
    if([object isKindOfClass:[SWPostTableItem class]])
        return [SWPostTableCell class];
    else
        return [super tableView:tableView cellClassForObject:object];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForLoading:(BOOL)reloading {
    if (reloading) {
        return NSLocalizedString(@"Finding More Posts...", @"Starworld feed updating text");
    } else {
        return NSLocalizedString(@"Finding Nearest Posts...", @"Starworld feed loading text");
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForEmpty {
    return NSLocalizedString(@"No posts found :(\nPerhaps you would like to post one?", @"Starworld feed no results");
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForError:(NSError*)error {
    return NSLocalizedString(@"Sorry, there was an error loading the Starworld stream.", @"Starworld Stream Error");
}
///////////////////////////////////////////////////////////////////////////////////////////////////
//Constants
#define SECOND 1
#define MINUTE (60 * SECOND)
#define HOUR (60 * MINUTE)
#define DAY (24 * HOUR)
#define MONTH (30 * DAY)

- (NSString*)timeIntervalWithStartDate:(NSDate*)d1 withEndDate:(NSDate*)d2
{

    //Calculate the delta in seconds between the two dates
    NSTimeInterval delta = [d2 timeIntervalSinceDate:d1];
    
    if (delta < 1 * SECOND)
        delta = 1;
    
    if (delta < 1 * MINUTE)
    {
        return delta == 1 ? @"one second ago" : [NSString stringWithFormat:@"%d seconds", (int)delta];
    }
    if (delta < 2 * MINUTE)
    {
        return @"a minute ago";
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
        return months <= 1 ? @"one month ago" : [NSString stringWithFormat:@"%d months", months];
    }
    else
    {
        int years = floor((double)delta/MONTH/12.0);
        return years <= 1 ? @"one year ago" : [NSString stringWithFormat:@"%d years", years];
    }
}


@end
