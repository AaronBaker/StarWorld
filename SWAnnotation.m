//
//  SWAnnotation.m
//  StarWorld
//
//  Created by Niki Bird on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWAnnotation.h"

@implementation SWAnnotation

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
#pragma mark -
#pragma mark Class Methods

+ (SWAnnotation *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate {
	return [self mapAnnotationWithCoordinate:aCoordinate title:nil subtitle:nil];
}


+ (SWAnnotation *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle {
	return [self mapAnnotationWithCoordinate:aCoordinate title:aTitle subtitle:nil];
}


+ (SWAnnotation *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle {
	SWAnnotation *annotation = [[[self alloc] init] autorelease];
	annotation.coordinate = aCoordinate;
	annotation.title = aTitle;
	annotation.subtitle = aSubtitle;
	return annotation;
}


#pragma mark -
#pragma mark NSObject

- (void)dealloc {
	[_title release];
	[_subtitle release];
	[super dealloc];
}


#pragma mark -
#pragma mark Initializers

- (SWAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate {
	return [self initWithCoordinate:aCoordinate title:nil subtitle:nil];
}


- (SWAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle {
	return [self initWithCoordinate:aCoordinate title:aTitle subtitle:nil];
}


- (SWAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle {
	if ((self = [super init])) {
		self.coordinate = aCoordinate;
		self.title = aTitle;
		self.subtitle = aSubtitle;
	}
	return self;
}



@end
