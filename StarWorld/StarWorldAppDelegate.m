//
//  StarWorldAppDelegate.m
//  StarWorld
//
//  Created by Aaron Baker on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StarWorldAppDelegate.h"
#import "SWFeedListController.h"
#import "SWStarListController.h"
#import "SWNewPostController.h"
#import "SWLoginViewController.h"
#import "SWTabBarController.h"
#import "SWLoginController.h"
#import "SWSettingsController.h"
#import "PRPWebViewController.h"
#import "WebViewController.h"
#import "SWRegisterController.h"
#import "SWDetailController.h"

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
    
    [TestFlight takeOff:@"097eb628898682791da62ce9e0949046_MzM1MTQyMDExLTExLTA2IDIyOjE0OjAzLjgyMTYxNA"];
    
    //This deletes cookies!
    //[self signOut];
    
    currentUser = [SWCurrentUser currentUserInstance];
    
    [self loginCheck];
    
    locationController = [[SWLocationController alloc] init];
    [locationController.locationManager startUpdatingLocation];
    locationController.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    TTNavigator *navigator = [TTNavigator navigator];
    navigator.window = _window;
    
    TTURLMap *map = navigator.URLMap;
    [map from:@"tt://main/tabBar/swfeed" toSharedViewController:[SWFeedListController class]];
    [map from:@"tt://main/tabBar/swstarred" toSharedViewController:[SWStarListController class]];
    [map from:@"tt://main/newpost" toSharedViewController:[SWNewPostController class]];
    [map from:@"tt://main/login" toModalViewController:[SWLoginController class]];
    [map from:@"tt://main/register" toModalViewController:[SWRegisterController class]];
    [map from:@"tt://main/tabBar" toSharedViewController:[SWTabBarController class]];
    [map from:@"tt://main" toSharedViewController:[SWSettingsController class]];
    [map from:@"tt://main/login/forgot" toModalViewController:[WebViewController class]];
    [map from:@"tt://main/detail" toViewController:[SWDetailController class]];
    
    [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://main/tabBar/"]];
    
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
	//[self addSplashScreen];
    
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
