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
#import "SWStarPostTableCell.h"
#import "SWTextTableCell.h"
#import "SWTextTableItem.h"
#import "MapTableItem.h"
#import "MapTableCell.h"

// Three20 Additions
#import <Three20Core/NSDateAdditions.h>


@interface SWFeedDataSource (hidden)

- (NSString*)timeIntervalWithStartDate:(NSDate*)d1 withEndDate:(NSDate*)d2;
- (void) addBonusCellText;
- (void) addMapCell;
- (void) newPostLinkPressed;

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SWFeedDataSource
@synthesize myItems;
@synthesize delegate;
@synthesize searchRemote;
@synthesize searchFeedModel = _searchFeedModel;
///////////////////////////////////////////////////////////////////////////////////////////////////
-(id)initWithStarred:(BOOL)starred {
    if ((self = [super init])) {
        

        
        _searchFeedModel = [[SWFeedModel alloc] initWithStarred:starred];

        
        showStarred = starred;
        
        
        

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
    
    myItems = [[NSMutableArray alloc] init];
    mySections = [[NSMutableArray alloc] init];

    
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
    
    float shortestDistance = 10000.0;
    
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
                
                if (distance < shortestDistance) {
                    shortestDistance = distance;
                }
                
                                
            }
            
                        
            distanceString = [SWUnitConverter convertFromMetersRounded:highestDistance];
            
            
            if (postCount == 1) {
                sectionsString = [NSString stringWithFormat:@"%d post within %@",postCount,distanceString];
            } else {
                sectionsString = [NSString stringWithFormat:@"%d posts within %@",postCount,distanceString];

            }
            
            
            //This line was generating great section strings.
            //It's not anymore.
            //[mySections addObject:sectionsString];
            [mySections addObject:@""];
            
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
                                                                      text:[post.content 
                                                                            stringByReplacingOccurrencesOfString:@"<"
                                                                            withString:@"&lt;"] 
                                                                 timestamp:post.time 
                                                                        ID:post.ID 
                                                                 starcount:post.starCount
                                                                         x:postX
                                                                         y:postY
                                                                       URL:nil]];
            }
            
            
            
            
            
            itemList = [NSArray arrayWithArray:itemListMutable];
            [myItems addObject:itemList];
            
        }
        
        
    }
    
//    if (!_searchFeedModel.finished) {
//        [items addObject:[TTTableMoreButton itemWithText:@"more…"]];
//    }
    
    
    //[self addMapCell];
    
    if (shortestDistance > 310 && self.searchRemote == NO)
        [self addBonusCellText];
    if (myItems.count < 1)
        [self addBonusCellText];
    
    
    self.items = myItems;
    self.sections = mySections;
    
    [delegate populateMapWithItems:myItems];
    
    TT_RELEASE_SAFELY(myItems);
    TT_RELEASE_SAFELY(mySections);
    
}///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addMapCell {
    
    MapTableItem *mapItem = [MapTableItem mapItemWithItems:myItems];
    NSArray *sectionItemHolder = [NSArray arrayWithObject:mapItem];
    
    [mySections insertObject:@"" atIndex:0];
    [myItems insertObject:sectionItemHolder atIndex:0];
    
    
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addBonusCellText {
    
//    TTTableLongTextItem *bonus = [TTTableLongTextItem itemWithText:@"There are no posts nearby you. Would you like to post one?" 
//                                                               URL:@"tt://main/newpost"];
    
    if (!showStarred) {
        
        SWTextTableItem *bonus = [SWTextTableItem itemWithText:@"This is Sad. \ue413 There are no posts nearby. Would you like to post one?" delegate:self selector:@selector(newPostLinkPressed)];
    
        NSArray *sectionItemHolder = [NSArray arrayWithObject:bonus];
        
        [mySections insertObject:@"No Posts within 1000 feet" atIndex:0];
        [myItems insertObject:sectionItemHolder atIndex:0];
        
    } else {
        
        
        SWTextTableItem *bonus = [SWTextTableItem itemWithText:@"You can tap the \ue32f to add stars to a post. Starred posts show up here."];
    
        NSArray *sectionItemHolder = [NSArray arrayWithObject:bonus];
        
        [mySections insertObject:@"No Nearby Starred Posts" atIndex:0];
        [myItems insertObject:sectionItemHolder atIndex:0];
  
    }
    
    
    
    

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) newPostLinkPressed {
    
    if (currentUser.authenticated) {
        [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"tt://main/newpost"] applyAnimated:YES]];
        
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hold On!" 
                                                          message:@"You need to log in before you can post." 
                                                         delegate:self 
                                                cancelButtonTitle:@"Oh, Nevermind." 
                                                otherButtonTitles:@"New Account", @"Login", nil];
        
        [message show];
        [message release];
    }
    
        
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
	
	if([title isEqualToString:@"Oh, Nevermind."])
	{
		NSLog(@"Nevermind was selected.");
	}
	else if([title isEqualToString:@"New Account"])
	{
		NSLog(@"New Account was selected.");
        [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"tt://main/register"]];
	}
	else if([title isEqualToString:@"Login"])
	{
		NSLog(@"Login was selected.");
        [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"tt://main/login"]];
        
	}	
}

///////////////////////////////////////////////////////////////////////////////////////////////////



- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
    if([object isKindOfClass:[SWPostTableItem class]]) {
        if (showStarred) {
            return [SWStarPostTableCell class];
        } else {
            return [SWPostTableCell class];
        }
    } else if ([object isKindOfClass:[SWTextTableItem class]]) {
        return [SWTextTableCell class];
    } else if ([object isKindOfClass:[MapTableItem class]]) {
        return [MapTableCell class];
    }
    else {
        return [super tableView:tableView cellClassForObject:object];
    }
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
    return NSLocalizedString(@"OH NO! Please try again later.", @"Starworld feed no results");
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
