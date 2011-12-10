//
//  SWStarListController.m
//  StarWorld
//
//  Created by Aaron Baker on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "SWStarListController.h"
#import "SWFeedDataSource.h"
#import "SWLoginViewController.h"

@interface SWStarListController (hidden)

-(void)setBarButtons;
-(void)logoutButtonPushed;
-(void)holdOnButtonPushed;
@end


@implementation SWStarListController

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
    
    if ((self = [super init])) {
        
        currentUser = [SWCurrentUser currentUserInstance];
        
        while (currentUser.x == 0.0f) {
            
            //AARON!  You really should make something happen if location can't be set.
            NSLog(@"STUCK");
            // If A job is finished, a flag should be set. and the flag can be a exit condition of this while loop
            
            // This executes another run loop.
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            
        }
        
        self.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:2]autorelease];
        self.tableViewStyle = UITableViewStylePlain;
        
        //UIImage *logo = [UIImage imageNamed:@"sw-tiny.png"];
        
        
        //self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:logo] autorelease];
        self.navigationItem.title = @"Most Starred";
        
        
        
        self.navigationBarTintColor = [UIColor blackColor];
        
        
        currentUser = [SWCurrentUser currentUserInstance];
        
        
        SWFeedDataSource *dataSource = [[[SWFeedDataSource alloc]
                                         initWithStarred:YES] autorelease]; 
        
        
        //This dummy view prevents empty cells from displaying
        self.tableView.tableFooterView = [[UIView new] autorelease];
        
        self.dataSource = dataSource;
        
        
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    }
    
    return self;
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setBarButtons {
    
    if (currentUser.authenticated == YES) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                                   initWithBarButtonSystemItem: UIBarButtonSystemItemCompose
                                                   target:@"tt://main/newpost"
                                                   action: @selector(openURLFromButton:)] autorelease];
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
                                                  initWithTitle: @"Logout"
                                                  style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action: @selector(logoutButtonPushed)] autorelease];    
    } else {  //If NOT logged in
        
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                                   initWithBarButtonSystemItem: UIBarButtonSystemItemCompose
                                                   target:self
                                                   action: @selector(holdOnButtonPushed)] autorelease];
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
                                                  initWithTitle: @"Login"
                                                  style:UIBarButtonItemStylePlain
                                                  target:@"tt://main/login"
                                                  action: @selector(openURLFromButton:)] autorelease];   
        
        
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"You need to log in before you can post." 
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
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



@end