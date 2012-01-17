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
- (void) switchToLocalDataSource;
-(void)removeAllAnnotations;
- (void)fullScreenWasTapped: (id)sender;
- (void)locationLockWasTapped: (id)sender;
- (void) annotationCalloutPressed: (id) sender;
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
        
        searchRemote = NO;
        
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
    locationLockButton.selected = TRUE;
    [mapView addSubview:locationLockButton];
    
}

#pragma mark SWFeedDataSourceDelegate #pragma mark -
//SWFeedDataSourceDelegate//
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)populateMapWithItems: (NSArray*) items {
    NSLog(@"POPULATE MAPS with items: %@",items);
    [self getAnnotationsFromItemList:items];  
    NSLog(@"WAIT WHAT?");
    
    
    [mapView addAnnotations:annotations];
    NSLog(@"asfasaw#WQAWQ");
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
    
    if (!senderButton.selected) {//If button has not been pressed, Switch to Local

        locationLockButton.selected = YES;
        NSLog(@"e1");
        
        [self removeAllAnnotations];
        NSLog(@"e2");
        [self switchToLocalDataSource];
        NSLog(@"e3");
        [annotations removeAllObjects];
        [annotationsDictionary removeAllObjects];
        [self reload];
        NSLog(@"e4");
        NSLog(@"ANNOTS: %@",annotations);
        NSLog(@"e5");

    } else { //Switch to Remote

        locationLockButton.selected = NO;
        [self switchToRemoteDataSource];
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
                    
                    
                    SWAnnotation *annotation = [[SWAnnotation alloc] init];
                    
                    CLLocationCoordinate2D pointCoords;
                    pointCoords.latitude = placemarkItem.y;
                    pointCoords.longitude = placemarkItem.x;
                    
                    annotation.coordinate = pointCoords;
                    annotation.title = placemarkItem.text;
                    annotation.animatesDrop = YES;
                    annotation.tableItem = placemarkItem;
                    
                    
                    //point.subtitle = placemarkItem.text;
                    
                    
                    //SWAnnotation *annotation = [SWAnnotation MKPointAnnotationWithCoordinate:[placemarkItem getCoordinate]];
                    
                    NSString *hashString = [NSString stringWithFormat:@"%@%f%f",placemarkItem.text,placemarkItem.x,placemarkItem.y];
                   
                    
                    
                    if ([annotationsDictionary objectForKey:hashString] == nil) {
                        [annotations addObject:annotation];
                        [annotationsDictionary setObject:annotation forKey:hashString];
                        
                    }
                    
                    
                    
                    
                    [annotation release];
                    
                    
                }
                
                
            }
        }
    }
    
    
    if (!searchRemote)
        [self fitMapUsingAnnotations:annotations];
    
    return annotations;
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)fitMapUsingAnnotations: (NSArray*) someAnnotations {
    MKCoordinateRegion region = MKCoordinateRegionForMapRect([self getMapRectUsingAnnotations:someAnnotations]);
    
    //float zoomFactor = 0.097; //Originally was 0.027
    
//    if (region.span.latitudeDelta < zoomFactor) {
//        region.span.latitudeDelta = zoomFactor;
//    }
//    
//    if (region.span.longitudeDelta < zoomFactor) {
//        region.span.longitudeDelta = zoomFactor;
//    }
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
    
    searchRemote = YES;
    
    [self reload];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) switchToLocalDataSource {
    [feedDataSource.searchFeedModel setSearchRemote:NO];
    feedDataSource.searchRemote = NO;
    searchRemote = NO;
    
}




#pragma mark Table View Delegate #pragma mark -
///////////////////////////////////////////////////////////////////////////////////////////////////
///MAP VIEW DELEGATE//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)mapView:(MKMapView *)thisMapView regionDidChangeAnimated:(BOOL)animated {
    
    NSLog(@"THIS MAP IS MOVIN");
    //searchModeLocal = YES;
        
//    if (lastLatitude != thisMapView.region.center.latitude)
//       [self reload]; 
    
    currentLatitude = thisMapView.region.center.latitude;
    currentLongitude = thisMapView.region.center.longitude;
    currentLatitudeDelta = thisMapView.region.span.latitudeDelta;
    currentLongitudeDelta = thisMapView.region.span.longitudeDelta;
    
    NSLog(@"SO MUCH STUFFS: %f %f %f OLD: %f %f %f",currentLatitude,currentLongitude,currentLatitudeDelta,lastLatitude,lastLongitude,lastLatitudeDelta);
    
    //TEST FOR SearchMode Triggers
    if (lastLatitude != 0 && lastLongitude != 0 && lastLatitudeDelta < 45.0) {
        
        if (currentLatitude > (lastLatitude + (lastLatitudeDelta/4))) {
            searchRemote = YES;
            NSLog(@"1");
        }
        if (currentLatitude < (lastLatitude - (lastLatitudeDelta/4))) {
            searchRemote = YES;
            NSLog(@"2");
        }
        if (currentLongitude > (lastLongitude + (lastLongitudeDelta/4))) {
            searchRemote = YES;
            NSLog(@"3");
        }
        if (currentLongitude < (lastLongitude - (lastLongitudeDelta/4))) {
            searchRemote = YES;
            NSLog(@"4");
        }
        //For now, zooming does not cause search mode change
//        if (currentLatitudeDelta > lastLatitudeDelta) {
//            searchRemote = YES;
//            NSLog(@"5");            
//        }
//        if (currentLatitudeDelta < lastLatitudeDelta) {
//            searchRemote = YES;
//            NSLog(@"6");            
//        }        
    }
    
    if (searchRemote) {
        
        
        [self switchToRemoteDataSource];
        
        NSLog(@"SEARCH MODE CHANGE");
        locationLockButton.selected = NO;
        //[self removeAllAnnotations];
            
    }
    
    lastLatitude = thisMapView.region.center.latitude;
    lastLongitude = thisMapView.region.center.longitude;
    lastLatitudeDelta = thisMapView.region.span.latitudeDelta;
    lastLongitudeDelta = thisMapView.region.span.longitudeDelta;
    

    
    //[self reload];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (MKAnnotationView *)mapView:(MKMapView *)thisMapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    
    
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[SWAnnotation class]]) {
        
        SWAnnotation *myAnnotation = annotation;
        SWPostTableItem *tableItem = myAnnotation.tableItem;
        
        // try to dequeue an existing pin view first
        static NSString* SWAnnotationIdentifier = @"SWAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [thisMapView dequeueReusableAnnotationViewWithIdentifier:SWAnnotationIdentifier];
        
        
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
                                                   initWithAnnotation:annotation reuseIdentifier:SWAnnotationIdentifier] autorelease];
            customPinView.pinColor = MKPinAnnotationColorRed;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
            //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            //
            
            
            
            SWAnnotationCallout *rightButton = [[SWAnnotationCallout alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            
            [rightButton addTarget:self
                            action:@selector(annotationCalloutPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            rightButton.tableItem = tableItem;
            rightButton.backgroundColor = [UIColor redColor];
            [rightButton setImage:[UIImage imageNamed:@"arrow-right.png"] forState:UIControlStateNormal];
            rightButton.imageView.frame = CGRectMake(1, 1, 18, 18);
                        
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) annotationCalloutPressed: (id) sender {
    
    SWAnnotationCallout *button = sender;
    
    TTURLAction *action =  [[[TTURLAction actionWithURLPath:@"tt://main/detail"] 
                             applyQuery:[NSDictionary dictionaryWithObject:button.tableItem forKey:@"kSWitem"]]
                            applyAnimated:YES];
    
    
    [[TTNavigator navigator] openURLAction:action];

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
