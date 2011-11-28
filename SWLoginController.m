//
//  SWLoginController.m
//  StarWorld
//
//  Created by Aaron Baker on 11/17/11.
//  Copyright (c) 2011 Inter Media Outdoors. All rights reserved.
//

#import "SWLoginController.h"
#import "PRPFormEncodedPOSTRequest.h"

static NSString* kSWLoginURL = @"http://pandora.starworlddata.com/users/login";


@interface SWLoginController (hidden)
- (void) processLoginResponse: (NSURLResponse*) response;
- (void) getLoginCookie;
- (void) dismiss;
- (void) forgot;
- (id) startLogin: (id)sender;
@end

@implementation SWLoginController

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
    
    if ((self = [super init])) {
        
        currentUser = [SWCurrentUser currentUserInstance];
        
    }
    
    NSLog(@"INIT LOGIN!");
    
    //Style the table view
    self.tableViewStyle = UITableViewStyleGrouped;
    self.autoresizesForKeyboard = YES;
    self.variableHeightRows = YES;
    self.tableView.backgroundColor = RGBCOLOR(190,190,190);
    self.navigationBarTintColor = [UIColor blackColor];
    self.title = @"Login";
    
    //Create Username Cell
    UIView *usernameContainer = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 280.0, 20.0)];
    
    UILabel *usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 13.0, 100.0, 20.0)];
    usernameField = [[UITextField alloc] initWithFrame:CGRectMake(105.0, 12.0, 100.0, 25.0)];
    
    
    usernameLabel.text = @"Username";
    usernameLabel.font = [UIFont boldSystemFontOfSize:16];
    usernameField.textColor = [UIColor grayColor];
    usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameField.placeholder = @"Username";
    usernameField.returnKeyType = UIReturnKeyNext;
    usernameField.delegate = self;
    usernameField.tag = 1;
    [usernameField setEnablesReturnKeyAutomatically:YES];
    
    
    [usernameContainer addSubview:usernameLabel];
    [usernameContainer addSubview:usernameField];
    

    
    //Create Password cell
    UIView *passwordContainer = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 280.0, 20.0)];
    
    UILabel *passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 13.0, 100.0, 20.0)];
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(105.0, 12.0, 100.0, 20.0)];
    
    
    passwordLabel.text = @"Password";
    passwordLabel.font = [UIFont boldSystemFontOfSize:16];
    
    [passwordContainer addSubview:passwordLabel];
    [passwordContainer addSubview:passwordField];
    passwordField.textColor = [UIColor grayColor];
    passwordField.secureTextEntry = YES;
    passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordField.placeholder = @"Password";
    passwordField.returnKeyType = UIReturnKeyDone;
    passwordField.tag = 2;
    passwordField.delegate = self;
 
    
    //Add Cells to datasource
    self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                       @"",
                       usernameField,
                       passwordField,
                       @"",
                       [TTTableTextItem itemWithText:@"Forgot Password?" URL:@"http://pandora.starworlddata.com/users/forgot"],
                       nil];
    

    
    [usernameLabel release];
    [passwordLabel release];
    [usernameField release];
    [passwordField release];
    
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)forgot {
    TTOpenURL(@"http://www.three20.info/");
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 1) {
        [passwordField becomeFirstResponder];
    }
    if (textField.tag == 2) {
        [self startLogin:self];
    }   
        
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setBarButtons {
    
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                              initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                              target:self action:@selector(dismiss)] autorelease];
    

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithTitle:@"Done" style:UIBarButtonItemStyleBordered
                                               target:self action:@selector(startLogin: )] autorelease];
        
 

    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setBarButtons];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dismiss {
    [self dismissModalViewControllerAnimated:YES];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) startLogin: (id)sender {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:usernameField.text forKey:@"data[User][username]"];
    [params setObject:passwordField.text forKey:@"data[User][password]"];
    
    
    NSURL *postURL = [NSURL URLWithString:kSWLoginURL];
    
    NSLog(@"LOGIN POST URL: %@",postURL);
    
    NSURLRequest *request = [PRPFormEncodedPOSTRequest requestWithURL:postURL
                                                       formParameters:params];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
    
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSDictionary *fields = [HTTPResponse allHeaderFields];
    
    NSLog(@"RESPONSE SUCCESS");
    NSLog(@"RESPONSE URL: %@",[response URL]);
    
    
    NSLog(@"%@",[fields description]);
    
    
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
        NSLog(@"name: '%@'\n",   [cookie name]);
        NSLog(@"value: '%@'\n",  [cookie value]);
        NSLog(@"domain: '%@'\n", [cookie domain]);
        NSLog(@"path: '%@'\n",   [cookie path]);
    }
    
    
    if (responseData) {
        NSLog(@"RESPONSE DATA: ***%@***",[NSString stringWithCString:[responseData bytes] encoding:NSUTF8StringEncoding]);
        [self processLoginResponse: response];
        
        
        NSRange range = [(NSString*)[[response URL] absoluteString] rangeOfString:@"success" options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound) {
            NSLog(@"AUTH SUCCESS!");
            
            
            [currentUser login];
            
            NSLog(@"Authenticated: %d",currentUser.authenticated);
            
            [self dismiss];
        } else {
            NSLog(@"AUTH FAILED!");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Incorrect Username or Password!" 
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            //[currentUser logout];
        }
        
        
        
    } else {
        NSLog(@"Error Logginin to %@ (%@)", kSWLoginURL, error);
    }
    
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) getLoginCookie {
    NSLog(@"GETTING LOGIN COOKIE.");
    NSURL *loginURL = [NSURL URLWithString:kSWLoginURL];
    
    
    currentUser.request = [NSMutableURLRequest requestWithURL:loginURL];
    
    [currentUser.request setHTTPMethod:@"GET"];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    
    
    [NSURLConnection sendSynchronousRequest:currentUser.request
                          returningResponse:&response
                                      error:&error];
    
    
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSDictionary *fields = [HTTPResponse allHeaderFields];
    NSLog(@"%@",[fields description]);
    
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
        NSLog(@"LCname: '%@'\n",   [cookie name]);
        NSLog(@"value: '%@'\n",  [cookie value]);
        NSLog(@"domain: '%@'\n", [cookie domain]);
        NSLog(@"path: '%@'\n",   [cookie path]);
    }
    
    
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) processLoginResponse: (NSURLResponse*) response {
    
    
}



- (void)dealloc
{
    [super dealloc];

    
    NSLog(@"DEALLOC LOGIN"); 
}


@end
