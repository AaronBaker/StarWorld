//
//  StarWorldAppDelegate.h
//  StarWorld
//
//  Created by Aaron Baker on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "SWLocationController.h"
#import "SWCurrentUser.h"
#import "PRPSplashScreenViewController.h"

@interface StarWorldAppDelegate : NSObject <UIApplicationDelegate,PRPSplashScreenViewControllerDelegate> {
    SWLocationController *locationController;
    SWCurrentUser *currentUser;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) PRPSplashScreenViewController *splashController;

@end
