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


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SWFeedDataSource

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id)initWithCoordinatesX: (float) x Y:(float)y {
    if ((self = [super init])) {
        _searchFeedModel = [[SWFeedModel alloc] initWithX: x Y: y];
        NSLog(@"DATA SOURCE INIT");
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
    
    
    for (SWPost* post in _searchFeedModel.posts) {
        //TTDPRINT(@"Response text: %@", response.text);
        NSLog(@"POST CONTENT: %@",post.content);
        NSLog(@"POST TIME: %@",post.time);
        
        
        
        TTStyledText* styledText = [TTStyledText textFromXHTML:
                                    [NSString stringWithFormat:@"%@\n<b>%@</b>",
                                     [[post.content stringByReplacingOccurrencesOfString:@"&"
                                                                            withString:@"&amp;"]
                                      stringByReplacingOccurrencesOfString:@"<"
                                      withString:@"&lt;"],
                                     post.name]
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


@end
