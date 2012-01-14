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
#import "SWFeedModel.h"



@interface SWFeedListController (hidden)

-(void)setBarButtons;
-(void)logoutButtonPushed;
-(void)holdOnButtonPushed;
- (NSArray*) getAnnotationsFromItemList: (NSArray*) items;
-(void)fitMapUsingAnnotations: (NSArray*) annotations;
- (MKMapRect) getMapRectUsingAnnotations:(NSArray*)theAnnotations;
- (void) switchToRemoteDataSource;
-(void)removeAllAnnotations;
- (void)fullScreenWasTapped: (id)sender;
- (void)locationLockWasTapped: (id)sender;
- (void)initMap;
@end

#pragma mark INIT #pragma mark -
@implementation SWFeedListController

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
    
    if ((self = [super init])) {
        
        currentUser = [SWCurrentUser currentUserInstance];
        annotations = [[NSMutableArray alloc] init];
        annotationsDictionary = [[NSMutableDictionary alloc]init];
        [self removeAllAnnotations];
        
        searchModeLocal = YES;
        
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
        
        //Setup the Map View with extra buttons
        [self initMap];
        
        
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
///////////////////////////////////////////////////////////////////////////////////////////////////       
- (void)initMap {
    ///////////////////SET THE MAP VIEW/////////////////////////
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];        
    self.tableView.tableHeaderView = mapView;
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    
    //Add Full Screen Button
    fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *expand = [UIImage imageNamed:@"expand.png"];
    UIImage *expandBlue = [UIImage imageNamed:@"expand_blue.png"];
    [fullScreenButton setImage:expand forState:UIControlStateNormal];
    [fullScreenButton setImage:expandBlue forState:UIControlStateSelected];
    [fullScreenButton setFrame:CGRectMake(mapView.frame.size.width - 32, mapView.frame.size.height - 32, 24, 24)];
    [fullScreenButton addTarget:self action:@selector(fullScreenWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    [mapView addSubview:fullScreenButton];   
    
    //Add Location Lock
    locationLockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *maparrow = [UIImage imageNamed:@"maparrow.png"];
    UIImage *maparrowBlue = [UIImage imageNamed:@"maparrow_blue.png"];
    [locationLockButton setImage:maparrow forState:UIControlStateNormal];
    [locationLockButton setImage:maparrowBlue forState:UIControlStateSelected];
    [locationLockButton setFrame:CGRectMake(mapView.frame.size.width - 64, mapView.frame.size.height - 32, 24, 24)];
    [locationLockButton addTarget:self action:@selector(locationLockWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    [mapView addSubview:locationLockButton];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)populateMapWithItems: (NSArray*) items {
    
    [self getAnnotationsFromItemList:items];    
    [mapView addAnnotations:annotations];
    
}

#pragma mark Map Buttons Pressed #pragma mark -

///////////////////////////////////////////////////////////////////////////////////////////////////       
- (void)fullScreenWasTapped: (id)sender {
    
    UIButton *senderButton = sender;  
    
    if (!senderButton.selected) {//If button has not been pressed
        [UIView beginAnimations:@"resize_animation" context:NULL];
        [UIView setAnimationDuration:0.5]; 
        [self.tableView.tableHeaderView setFrame:CGRectMake(0, 0, 320, 367)];
        fullScreenButton.selected = YES;
        [fullScreenButton setFrame:CGRectMake(mapView.frame.size.width - 32, mapView.frame.size.height - 32, 24, 24)];
        [locationLockButton setFrame:CGRectMake(mapView.frame.size.width - 64, mapView.frame.size.height - 32, 24, 24)];
        [UIView commitAnimations];
    } else {
        [UIView beginAnimations:@"resize_animation" context:NULL];
        [UIView setAnimationDuration:0.5]; 
        [self.tableView.tableHeaderView setFrame:CGRectMake(0, 0, 320, 180)];
        fullScreenButton.selected = NO;
        [fullScreenButton setFrame:CGRectMake(mapView.frame.size.width - 32, mapView.frame.size.height - 32, 24, 24)];
        [locationLockButton setFrame:CGRectMake(mapView.frame.size.width - 64, mapView.frame.size.height - 32, 24, 24)];
        [UIView commitAnimations];
    }
    
    


 }
///////////////////////////////////////////////////////////////////////////////////////////////////       
- (void)locationLockWasTapped:(id)sender {
    UIButton *senderButton = sender;  
    
    if (!senderButton.selected) {//If button has not been pressed

        locationLockButton.selected = YES;

    } else {

        locationLockButton.selected = NO;

    }
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
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
- (NSArray*) getAnnotationsFromItemList: (NSArray*) items {
    
    
    NSArray *placemarkSections = items;
    
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
                    
                    NSString *hashString = [NSString stringWithFormat:@"%@%f%f",placemarkItem.text,placemarkItem.x,placemarkItem.y];
                   
                    
                    
                    if ([annotationsDictionary objectForKey:hashString] == nil) {
                        [annotations addObject:point];
                        [annotationsDictionary setObject:point forKey:hashString];
                        
                    }
                    
                    
                    
                    
                    [point release];
                    
                    
                }
                
                
            }
        }
    }
    NSLog(@"item count: %d",itemCount);
    
    if (searchModeLocal)
        [self fitMapUsingAnnotations:annotations];
    
    return annotations;
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)fitMapUsingAnnotations: (NSArray*) someAnnotations {
    MKCoordinateRegion region = MKCoordinateRegionForMapRect([self getMapRectUsingAnnotations:someAnnotations]);
    
    if (region.span.latitudeDelta < 0.027) {
        region.span.latitudeDelta = 0.027;
    }
    
    if (region.span.longitudeDelta < 0.027) {
        region.span.longitudeDelta = 0.027;
    }
    [mapView setRegion:region];
    
    lastLatitude = region.center.latitude;
    lastLongitude = region.center.longitude;
    
    
//    CGPoint fakecenter = CGPointMake(mapView.frame.size.width / 2, (mapView.frame.size.height / 2) - 16);
//    CLLocationCoordinate2D coordinate = [mapView convertPoint:fakecenter toCoordinateFromView:mapView];
//    [mapView setCenterCoordinate:coordinate animated:YES];
    
      
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

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) switchToRemoteDataSource {
    
    [feedDataSource.searchFeedModel setSearchRemote:YES];
    [feedDataSource.searchFeedModel setLocationTop:currentLatitude + currentLatitudeDelta];
    [feedDataSource.searchFeedModel setLocationBottom:currentLatitude - currentLatitudeDelta];
    [feedDataSource.searchFeedModel setLocationLeft:currentLongitude - currentLongitudeDelta];
    [feedDataSource.searchFeedModel setLocationRight:currentLongitude + currentLongitudeDelta];
    feedDataSource.searchRemote = YES;
}


#pragma mark Table View Delegate #pragma mark -
///////////////////////////////////////////////////////////////////////////////////////////////////
///MAP VIEW DELETGATE//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)mapView:(MKMapView *)thisMapView regionDidChangeAnimated:(BOOL)animated {
    
    NSLog(@"THIS MAP IS MOVIN");
    //searchModeLocal = YES;
        
//    if (lastLatitude != thisMapView.region.center.latitude)
//       [self reload]; 
    
    CLLocationDegrees currentLatitude = thisMapView.region.center.latitude;
    CLLocationDegrees currentLongitude = thisMapView.region.center.longitude;
    CLLocationDegrees currentLatitudeDelta = thisMapView.region.span.latitudeDelta;
    CLLocationDegrees currentLongitudeDelta = thisMapView.region.span.longitudeDelta;
    
    NSLog(@"SO MUCH STUFFS: %f %f %f OLD: %f %f %f",currentLatitude,currentLongitude,currentLatitudeDelta,lastLatitude,lastLongitude,lastLatitudeDelta);
    
    //TEST FOR SearchMode Triggers
    if (lastLatitude != 0 && lastLongitude != 0 && lastLatitudeDelta < 45.0) {
        
        if (currentLatitude > (lastLatitude + (lastLatitudeDelta/3))) {
            searchModeLocal = NO;
            NSLog(@"1");
        }
        if (currentLatitude < (lastLatitude - (lastLatitudeDelta/3))) {
            searchModeLocal = NO;
            NSLog(@"2");
        }
        if (currentLongitude > (lastLongitude + (lastLongitudeDelta/3))) {
            searchModeLocal = NO;
            NSLog(@"3");
        }
        if (currentLongitude < (lastLongitude - (lastLongitudeDelta/3))) {
            searchModeLocal = NO;
            NSLog(@"4");
        }
        if (currentLatitudeDelta > lastLatitudeDelta) {
            searchModeLocal = NO;
            NSLog(@"5");            
        }
        if (currentLatitudeDelta < lastLatitudeDelta) {
            searchModeLocal = NO;
            NSLog(@"6");            
        }        
    }
    
    if (!searchModeLocal) {
        
        
        [self switchToRemoteDataSource];
        
        NSLog(@"SEARCH MODE CHANGE");
        //[self removeAllAnnotations];
        [self reload];    
    }
    
    lastLatitude = thisMapView.region.center.latitude;
    lastLongitude = thisMapView.region.center.longitude;
    lastLatitudeDelta = thisMapView.region.span.latitudeDelta;
    lastLongitudeDelta = thisMapView.region.span.longitudeDelta;
    

    
    //[self reload];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////


-(void)removeAllAnnotations
{
    //Get the current user location annotation.
    id userAnnotation=mapView.userLocation;
    
    //Remove all added annotations
    [mapView removeAnnotations:mapView.annotations]; 
    
    // Add the current user location annotation again.
    if(userAnnotation!=nil)
        [mapView addAnnotation:userAnnotation];
}

#pragma mark Dealloc #pragma mark -

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
    TT_RELEASE_SAFELY(annotations);
    TT_RELEASE_SAFELY(annotationsDictionary);
    [super dealloc];
}


@end
