//
//  SWDetailController.m
//  StarWorld
//
//  Created by Aaron Baker on 1/1/12.
//  Copyright (c) 2012 Inter Media Outdoors. All rights reserved.
//

#import "SWDetailController.h"




@implementation SWDetailController
@synthesize item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id) initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
    self = [super init];
    if (self != nil) {
        item = [query objectForKey:@"kSWitem"];
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]; 
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 600.0)];
    
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    
    CLLocationCoordinate2D pointCoords;
    pointCoords.latitude = item.y;
    pointCoords.longitude = item.x;
    
    
    
    point.coordinate = pointCoords;
    
    NSLog(@"THIS IS MY POINT:%f,%f, %@",point.coordinate.latitude,point.coordinate.longitude,point);
    
    
    [mapView addAnnotation:point];
    
    
    [contentView addSubview:mapView];
    
    UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 210.0, 200, 20)];
    testLabel.text = item.text;
    
    UILabel *testLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 250.0, 200, 20)];
    testLabel2.text = [NSString stringWithFormat:@"X: %f",item.x];
    
    
    [scrollview setContentSize:CGSizeMake(self.view.frame.size.width, 650)];
    [scrollview setBackgroundColor:[UIColor greenColor]];
    
    [contentView addSubview:testLabel];
    [contentView addSubview:testLabel2];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    [scrollview addSubview:contentView];
    
    
    
    [self.view addSubview:scrollview];
    
    [contentView release];
    [scrollview release];
    [testLabel release];
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
	MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
	annView.animatesDrop=TRUE;
	return annView;
}


@end
