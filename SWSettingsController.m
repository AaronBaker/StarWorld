//
//  SWSettingsController.m
//  StarWorld
//
//  Created by Aaron Baker on 12/3/11.
//  Copyright (c) 2011 Inter Media Outdoors. All rights reserved.
//

#import "SWSettingsController.h"

@interface SWSettingsController (hidden)
- (void) launchFeedback;
@end



@implementation SWSettingsController
- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
    
    if ((self = [super init])) {
        
        currentUser = [SWCurrentUser currentUserInstance];
        
        //Style the table view
        self.tableViewStyle = UITableViewStyleGrouped;
        self.autoresizesForKeyboard = YES;
        self.variableHeightRows = YES;
        self.tableView.backgroundColor = RGBCOLOR(190,190,190);
        self.navigationBarTintColor = [UIColor blackColor];
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"Settings";
        
        //Add Cells to datasource
        
        if (currentUser.authenticated == YES) {
            self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                               @"Accounts",
                               [TTTableTextItem itemWithText:@"Logout" delegate:self selector:@selector(logoutButtonPushed)],
                               @"Hey Team SW!",
                               [TTTableTextItem itemWithText:@"Send Feedback to Aaron" delegate:self selector:@selector(launchFeedback)],
                               
                               nil];
        } else {
        
            self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                               @"Accounts",
                               [TTTableTextItem itemWithText:@"Register New Account" URL:@"tt://main/register"],
                               [TTTableTextItem itemWithText:@"Login" URL:@"tt://main/login"],
                               @"Hey Team SW!",
                               [TTTableTextItem itemWithText:@"Send Feedback to Aaron" delegate:self selector:@selector(launchFeedback)],
                               //                       @"More",
                               //                       [TTTableTextItem itemWithText:@"About StarWorld" URL:@""],
                               //                       [TTTableTextItem itemWithText:@"More From Aaron" URL:@""],
                               
                               
                               nil];
    
        }
    }
    
    return self;
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)logoutButtonPushed {
    
    [currentUser logout];
    
    self.dataSource = nil;
    
    self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                       @"Accounts",
                       [TTTableTextItem itemWithText:@"Register New Account" URL:@"tt://main/register"],
                       [TTTableTextItem itemWithText:@"Login" URL:@"tt://main/login"],
                       @"Hey Team SW!",
                       [TTTableTextItem itemWithText:@"Send Feedback to Aaron" delegate:self selector:@selector(launchFeedback)],
//                       @"More",
//                       [TTTableTextItem itemWithText:@"About StarWorld" URL:@""],
//                       [TTTableTextItem itemWithText:@"More From Aaron" URL:@""],
    
                       
                       nil];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)launchFeedback {
    [TestFlight openFeedbackView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dismiss {
    [self.navigationController popViewControllerAnimated:NO]; 
}

@end
