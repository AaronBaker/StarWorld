//
//  SWFeedListController.m
//  StarWorld
//
//  Created by Aaron Baker on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "SWFeedListController.h"    
#import "SWLoginViewController.h"
#import "UIBarButtonItem+SWAdditions.h"
#import "SWPostTableItem.h"
#import "SWAnnotation.h"

@interface SWFeedListController (hidden)

-(void)setBarButtons;
-(void)logoutButtonPushed;
-(void)holdOnButtonPushed;
- (NSArray*) getAnnotationsFromItemList: (NSArray*) items;
-(void)fitMapUsingAnnotations: (NSArray*) annotations;
- (MKMapRect) getMapRectUsingAnnotations:(NSArray*)theAnnotations;
@end


@implementation SWFeedListController

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
    
    if ((self = [super init])) {
        
        currentUser = [SWCurrentUser currentUserInstance];
        
        while (currentUser.x == 0.0f) {
            
            //AARON!  You really should make something happen if location can't be set.
            NSLog(@"STUCK");
            // If A job is finished, a flag should be set. and the flag can be a exit condition of this while loop
            
            // This executes another run loop.
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            
        }
        
        self.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:1]autorelease];
        
        self.tableViewStyle = UITableViewStylePlain;
        
        UIImage *logo = [UIImage imageNamed:@"sw-tiny.png"];
        
        
        self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:logo] autorelease];
        
        
        self.navigationBarTintColor = [UIColor blackColor];
        

        ///////////////////SET THE MAP VIEW/////////////////////////
        mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];        
        self.tableView.tableHeaderView = mapView;
        mapView.showsUserLocation = YES;

        
        
        
        
        
        currentUser = [SWCurrentUser currentUserInstance];
        
        
        feedDataSource = [[[SWFeedDataSource alloc]
                                         initWithStarred:NO] autorelease]; 
        [feedDataSource setDelegate:self];
        
        
        
        self.dataSource = feedDataSource;
        
        NSLog(@"DATA SOURCE: %@",self.dataSource);
        
        //This dummy view prevents empty cells from displaying
        self.tableView.tableFooterView = [[UIView new] autorelease];
        
        
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    }
    
    return self;
    
}



- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    
    
    if ([object isKindOfClass:[SWPostTableItem class]]) {
        SWPostTableItem *item = object;
        
        
        TTURLAction *action =  [[[TTURLAction actionWithURLPath:@"tt://main/detail"] 
                                 applyQuery:[NSDictionary dictionaryWithObject:item forKey:@"kSWitem"]]
                                applyAnimated:YES];
        
        
        [[TTNavigator navigator] openURLAction:action];
    } else {
    
        [super didSelectObject:object atIndexPath:indexPath];
    }
    

    
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)populateMapWithItems: (NSArray*) items {
    
    NSLog(@"I AM CALLING IT ITEMS: %@ ",items);
    
    NSArray *annotations = [self getAnnotationsFromItemList:items];    
    [mapView addAnnotations:annotations];
    
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray*) getAnnotationsFromItemList: (NSArray*) items {
    
    
    NSArray *placemarkSections = items;
    
    NSMutableArray* annotationsArray = [[[NSMutableArray alloc] init]autorelease];
    int itemCount = 0;
    
    for (id placemarkSection in placemarkSections) {
        
        if (itemCount < 20) {
            
            
            for (id placemarkData in placemarkSection) {
                
                if ([placemarkData isKindOfClass:[SWPostTableItem class]]) {
                    
                    itemCount++;
                    
                    
                    SWPostTableItem *placemarkItem = placemarkData;
                    
                    
                    SWAnnotation *point = [[SWAnnotation alloc] init];
                    
                    CLLocationCoordinate2D pointCoords;
                    pointCoords.latitude = placemarkItem.y;
                    pointCoords.longitude = placemarkItem.x;
                    
                    point.coordinate = pointCoords;
                    point.title = placemarkItem.text;
                    
                    
                    //point.subtitle = placemarkItem.text;
                    
                    
                    //SWAnnotation *annotation = [SWAnnotation MKPointAnnotationWithCoordinate:[placemarkItem getCoordinate]];
                    
                    
                    
                    
                    [annotationsArray addObject:point];
                    
                    
                    
                    [point release];
                    
                    
                }
                
                
            }
        }
    }
    NSLog(@"item count: %d",itemCount);
    
    return annotationsArray;
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)fitMapUsingAnnotations: (NSArray*) annotations {
    MKCoordinateRegion region = MKCoordinateRegionForMapRect([self getMapRectUsingAnnotations:annotations]);
    
    if (region.span.latitudeDelta < 0.027) {
        region.span.latitudeDelta = 0.027;
    }
    
    if (region.span.longitudeDelta < 0.027) {
        region.span.longitudeDelta = 0.027;
    }
    [mapView setRegion:region];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
/* This returns a rectangle bounding all of the pins within the supplied
 array */
- (MKMapRect) getMapRectUsingAnnotations:(NSArray*)theAnnotations {
    MKMapPoint points[[theAnnotations count]];
    
    for (int i = 0; i < [theAnnotations count]; i++) {
        MKPointAnnotation *annotation = [theAnnotations objectAtIndex:i];
        points[i] = MKMapPointForCoordinate(annotation.coordinate);
    }
    
    MKPolygon *poly = [MKPolygon polygonWithPoints:points count:[theAnnotations count]];
    
    return [poly boundingMapRect];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setBarButtons {
    
    if (currentUser.authenticated == YES) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                                   initWithBarButtonSystemItem: UIBarButtonSystemItemCompose
                                                   target:@"tt://main/newpost"
                                                   action: @selector(openURLFromButton:)] autorelease];
        
        UIImage *gearImage = [UIImage imageNamed:@"MyGear.png"];
        
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:gearImage 
                                                                                 style:UIBarButtonItemStylePlain 
                                                                                target:@"tt://main" 
                                                                                action:@selector(openURLFromButton:)]; 
    } else {  //If NOT logged in
        
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                                   initWithBarButtonSystemItem: UIBarButtonSystemItemCompose
                                                   target:self
                                                   action: @selector(holdOnButtonPushed)] autorelease];

//        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
//                                                  initWithBarButtonSystemItem: UIBarButtonSystemItemAction
//                                                  target:@"tt://main"
//                                                  action: @selector(openURLFromButton:)] autorelease];   
        
        
        
        
        //I think this is the good one
        UIImage *gearImage = [UIImage imageNamed:@"MyGear.png"];
        
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:gearImage 
                                                                                 style:UIBarButtonItemStylePlain 
                                                                                target:@"tt://main" 
                                                                                action:@selector(openURLFromButton:)];
        
        
        
        
        
        
//        self.navigationItem.leftBarButtonItem = [UIBarButtonItem 
//                                                 barItemWithImage:gearImage 
//                                                 target:@"tt://main" action:@selector(openURLFromButton:)];       
        
//        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
//                                                  initWithTitle: @"Main"
//                                                  style:UIBarButtonItemStylePlain
//                                                  target:@"tt://main"
//                                                  action: @selector(openURLFromButton:)] autorelease];   

        
        //Later fix this icon for the toolbar button.
//        UIImage *gearImage = [UIImage imageNamed:@"Gear20.png"];
//        
//        [self.navigationItem.leftBarButtonItem setImage:gearImage];
    }
    
    
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reload];
    [TestFlight passCheckpoint:@"SHOW THE FEED"];
    

    [self setBarButtons];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//        
//    
//    NSURL *authTestURL = [NSURL URLWithString:@"http://pandora.starworlddata.com/users/authenticated"];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:authTestURL];
//    
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
//                                                 returningResponse:&response
//                                                             error:&error];
//    
//    NSRange range = [(NSString*)[[response URL] absoluteString] rangeOfString:@"success" options:NSCaseInsensitiveSearch];
//    
//    if (range.location == NSNotFound && currentUser.authenticated) {
//    
//        [currentUser logout];
//        [self setBarButtons];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"For some reason, you have been logged out!" 
//                                                       delegate:self cancelButtonTitle:@"Umm. Ok." otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//        
//        
//        
//    }
    
    
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)holdOnButtonPushed {
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hold On!" 
                                                      message:@"You need to log in before you can post." 
                                                     delegate:self 
                                            cancelButtonTitle:@"Oh, Nevermind." 
                                            otherButtonTitles:@"New Account", @"Login", nil];
    
    [message show];
    [message release];
    
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

-(void)logoutButtonPushed {
    
    [currentUser logout];
    [self setBarButtons];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}



@end
