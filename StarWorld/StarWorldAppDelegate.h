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

@interface StarWorldAppDelegate : NSObject <UIApplicationDelegate> {
    SWLocationController *locationController;
    SWCurrentUser *currentUser;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
