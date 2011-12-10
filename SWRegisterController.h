//
//  SWRegisterController.h
//  StarWorld
//
//  Created by Aaron Baker on 12/4/11.
//  Copyright (c) 2011 Inter Media Outdoors. All rights reserved.
//


#import <Three20/Three20.h>
#import "SWCurrentUser.h"


@interface SWRegisterController : TTTableViewController <UITextFieldDelegate> {
    SWCurrentUser *currentUser;
    UITextField *usernameField;
    UITextField *emailField;
    UITextField *passwordField;
}

@end
