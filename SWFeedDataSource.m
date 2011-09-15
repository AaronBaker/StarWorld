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
        NSLog(@"DATA SOURCE INIT");
        currentUser = [SWCurrentUser currentUserInstance];

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
    
    
    currentUser = [SWCurrentUser currentUserInstance];

    
    CLLocationDegrees currentX = currentUser.x;
    CLLocationDegrees currentY = currentUser.y;
    
    NSLog(@"currentX: %f",currentX);
    NSLog(@"current.X: %f",currentUser.x);
    
    CLLocationDegrees postX;
    CLLocationDegrees postY;
    
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentY longitude:currentX];
    CLLocation *postLocation;
    
    float distance;
    
    for (SWPost* post in _searchFeedModel.posts) {
        //TTDPRINT(@"Response text: %@", response.text);

        
        NSDate *now = [NSDate date];
        
        postX = post.x;
        postY = post.y;
        
        NSLog(@"postX: %f",postX);
        
        postLocation = [[CLLocation alloc] initWithLatitude:postY longitude:postX];
        
        distance = [currentLocation distanceFromLocation:postLocation];
        
        NSLog(@"currentloc: %@",currentLocation);
        
        TTStyledText* styledText = [TTStyledText textFromXHTML:
                                    [NSString stringWithFormat:@"%@\n<b>%@</b>\n%@\n%f\n%f\nDIST:%f",
                                     [[post.content stringByReplacingOccurrencesOfString:@"&"
                                                                            withString:@"&amp;"]
                                      stringByReplacingOccurrencesOfString:@"<"
                                      withString:@"&lt;"],
                                     post.name,[self timeIntervalWithStartDate:post.time withEndDate:now],post.x,post.y,distance]
                                                    lineBreaks:YES URLs:YES];
        // If this asserts, it's likely that the tweet.text contains an HTML character that caused
        // the XML parser to fail.
        TTDASSERT(nil != styledText);
        [items addObject:[TTTableStyledTextItem itemWithText:styledText]];
        
        
//        
//        TTTableItem *tableItem = 
//        [TTTableSubtitleItem itemWithText:post.content subtitle:@"cheese" 
//                                      URL:Nil];
//        [items addObject:tableItem];
//        
        
        
        
    }
    
    if (!_searchFeedModel.finished) {
        [items addObject:[TTTableMoreButton itemWithText:@"more…"]];
    }
    
    self.items = items;
    
    NSLog(@"table items: %@",self.items);
    
    TT_RELEASE_SAFELY(items);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForLoading:(BOOL)reloading {
    if (reloading) {
        return NSLocalizedString(@"Finding Nearest Posts...", @"Starworld feed updating text");
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
    return NSLocalizedString(@"Sorry, there was an error loading the Starworld stream.", @"");
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
    NSLog(@"START DATE: %@",d1);
    NSLog(@"END DATE: %@",d2);

    
    //Calculate the delta in seconds between the two dates
    NSTimeInterval delta = [d2 timeIntervalSinceDate:d1];
    
    if (delta < 1 * MINUTE)
    {
        return delta == 1 ? @"one second ago" : [NSString stringWithFormat:@"%d seconds ago", (int)delta];
    }
    if (delta < 2 * MINUTE)
    {
        return @"a minute ago";
    }
    if (delta < 45 * MINUTE)
    {
        int minutes = floor((double)delta/MINUTE);
        return [NSString stringWithFormat:@"%d minutes ago", minutes];
    }
    if (delta < 90 * MINUTE)
    {
        return @"an hour ago";
    }
    if (delta < 24 * HOUR)
    {
        int hours = floor((double)delta/HOUR);
        return [NSString stringWithFormat:@"%d hours ago", hours];
    }
    if (delta < 48 * HOUR)
    {
        return @"yesterday";
    }
    if (delta < 30 * DAY)
    {
        int days = floor((double)delta/DAY);
        return [NSString stringWithFormat:@"%d days ago", days];
    }
    if (delta < 12 * MONTH)
    {
        int months = floor((double)delta/MONTH);
        return months <= 1 ? @"one month ago" : [NSString stringWithFormat:@"%d months ago", months];
    }
    else
    {
        int years = floor((double)delta/MONTH/12.0);
        return years <= 1 ? @"one year ago" : [NSString stringWithFormat:@"%d years ago", years];
    }
}


@end
