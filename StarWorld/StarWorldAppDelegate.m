//
//  StarWorldAppDelegate.m
//  StarWorld
//
//  Created by Aaron Baker on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StarWorldAppDelegate.h"
#import "SWFeedListController.h"
#import "SWNewPostController.h"
#import "SWLoginViewController.h"


@interface StarWorldAppDelegate (hidden)
- (void)signOut;
- (void)loginCheck;
@end


NSString *const kSWDefaultsKeyUserIsAuthenticated = @"sw_user_is_authenticated";

@implementation StarWorldAppDelegate


@synthesize window=_window;
@synthesize splashController;

- (void)addSplashScreen {
	
    splashController = [[PRPSplashScreenViewController alloc] init];
	self.splashController.delegate = self;
	self.splashController.transition = CircleFromCenter;
	self.splashController.delay = 1.0;
    [self.splashController showInWindow:_window];	
    

}


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    
    //This deletes cookies!
    //[self signOut];
    
    
    
    currentUser = [SWCurrentUser currentUserInstance];
    
    [self loginCheck];
    
    locationController = [[SWLocationController alloc] init];
    [locationController.locationManager startUpdatingLocation];
    
    TTNavigator *navigator = [TTNavigator navigator];
    navigator.window = _window;
    
    TTURLMap *map = navigator.URLMap;
    [map from:@"tt://swfeed" toSharedViewController:[SWFeedListController class]];
    [map from:@"tt://newpost" toSharedViewController:[SWNewPostController class]];
    [map from:@"tt://login" toModalViewController:[SWLoginViewController class]];
    
    [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://swfeed"]];
    
    [self addSplashScreen];
    
    
    // Override point for customization after application launch
    [_window makeKeyAndVisible];
    
}




- (void)signOut {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in [[[cookieStorage cookiesForURL:[NSURL URLWithString:@"http://pandora.starworlddata.com"]] copy] autorelease]) {
        [cookieStorage deleteCookie:each];
    }
}

- (void)loginCheck {
    
    currentUser = [SWCurrentUser currentUserInstance];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults boolForKey:kSWDefaultsKeyUserIsAuthenticated]) {
        [currentUser login];
    }
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [splashController.view removeFromSuperview];
    [splashController release];
}


- (void)splashScreenDidDisappear:(PRPSplashScreenViewController *)splashScreen {


}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	[self addSplashScreen];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [locationController release];
    [super dealloc];
}

@end
