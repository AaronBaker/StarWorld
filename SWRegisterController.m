//
//  SWRegisterController.m
//  StarWorld
//
//  Created by Aaron Baker on 12/4/11.
//  Copyright (c) 2011 Inter Media Outdoors. All rights reserved.
//

#import "SWRegisterController.h"
#import "PRPFormEncodedPOSTRequest.h"
#import "PRPAlertView.h"


static NSString* kSWRegisterURL = @"http://pandora.starworlddata.com/users/add";
static NSString* kSWCheckUsernameURL = @"http://pandora.starworlddata.com/users/good_username";
static NSString* kSWCheckEmailURL = @"http://pandora.starworlddata.com/users/good_email";


@interface SWRegisterController (hidden)
- (void) processRegisterResponse: (NSURLResponse*) response;
- (void) dismiss;
- (void) dismissToFeed;
- (void)setBarButtons;
- (id) startRegister: (id)sender;
- (BOOL) goodUsername: (NSString*) username;
- (BOOL) goodEmail: (NSString*) email;
- (void) doneButtonPressed: (id)sender;
@end


@implementation SWRegisterController

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
    
    if ((self = [super init])) {
        
        currentUser = [SWCurrentUser currentUserInstance];
        
    }
    
    NSLog(@"INIT REGISTER!");
    
    //Style the table view
    self.tableViewStyle = UITableViewStyleGrouped;
    self.autoresizesForKeyboard = YES;
    self.variableHeightRows = YES;
    self.tableView.backgroundColor = RGBCOLOR(190,190,190);
    self.navigationBarTintColor = [UIColor blackColor];
    self.title = @"New Account";
    [self setBarButtons];
    
    
    //Create the Username Field
    usernameField = [[UITextField alloc] initWithFrame:CGRectMake(105.0, 12.0, 100.0, 25.0)];
    usernameField.textColor = [UIColor grayColor];
    usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameField.placeholder = @"Username";
    usernameField.returnKeyType = UIReturnKeyNext;
    usernameField.delegate = self;
    usernameField.tag = 1;
    [usernameField setEnablesReturnKeyAutomatically:YES];
    
    
    //Create Password Field
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(105.0, 12.0, 100.0, 20.0)];
    passwordField.textColor = [UIColor grayColor];
    passwordField.secureTextEntry = YES;
    passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordField.placeholder = @"Password";
    passwordField.returnKeyType = UIReturnKeyNext;
    passwordField.tag = 2;
    passwordField.delegate = self;
    
    
    //Create Email Field
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(105.0, 12.0, 100.0, 20.0)];
    emailField.textColor = [UIColor grayColor];
    emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    emailField.placeholder = @"Email";
    emailField.returnKeyType = UIReturnKeyDone;
    emailField.tag = 3;
    emailField.delegate = self;
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    
    //Add Cells to datasource
    self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                       @"",
                       usernameField,
                       passwordField,
                       emailField,
                       nil];
    
    [usernameField release];
    [passwordField release];
    [emailField release];
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) startRegister: (id)sender {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:usernameField.text forKey:@"data[User][username]"];
    [params setObject:passwordField.text forKey:@"data[User][password]"];
    [params setObject:emailField.text forKey:@"data[User][email]"];
    
    
    NSURL *registerURL = [NSURL URLWithString:kSWRegisterURL];
    
    NSLog(@"LOGIN POST URL: %@",registerURL);
    
    NSURLRequest *request = [PRPFormEncodedPOSTRequest requestWithURL:registerURL
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
        [self processRegisterResponse: response];
        
        
        NSRange range = [(NSString*)[[response URL] absoluteString] rangeOfString:@"success" options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound) {
            NSLog(@"REGISTER SUCCESS!");
            
            [TestFlight passCheckpoint:@"USER SUCCESSFULLY REGISTERED"];
            
            [currentUser login];

            NSLog(@"Authenticated: %d",currentUser.authenticated);
            
            [self dismissToFeed];
            
            [PRPAlertView showWithTitle:@"Hello There." message:@"Thanks for signing up.  You are now logged in." buttonTitle:@"Cool."];
            
            
            
        } else {
            NSLog(@"Register FAILED!");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Incorrect Username or Password!" 
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            //[currentUser logout];
        }
        
        
        
    } else {
        NSLog(@"Error Logginin to %@ (%@)", kSWRegisterURL, error);
    }
    
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) goodUsername: (NSString*) username {
    
    
    
    NSLog(@"GOOD USERNAME CHECK NOW");
    NSString *goodUsernameURLString = [NSString stringWithFormat:@"%@/%@",kSWCheckUsernameURL,username];
    
    
    NSURL *goodUsernameURL = [NSURL URLWithString:goodUsernameURLString];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:goodUsernameURL
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:10.0];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
    
    
    NSLog(@"good usename url string: %@",goodUsernameURL);
    
    if (responseData) {
        NSLog(@"RESPONSE DATA: ***%@***",[NSString stringWithCString:[responseData bytes] encoding:NSUTF8StringEncoding]);
        [self processRegisterResponse: response];
        
        
        NSRange range = [(NSString*)[[response URL] absoluteString] rangeOfString:@"success" options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound) {
            NSLog(@"USERNAME IS GOOD!");
            
            return YES;
            
            
        } else {
            NSLog(@"USERNAME IS BAD!");
            
            return NO;
        }
        
        
        
    } else {
        NSLog(@"Error checking username");
        return NO;
    }
    
    
    
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) goodEmail:(NSString *)email {
    
    
    
    NSLog(@"GOOD USERNAME CHECK NOW");
    NSString *goodEmailURLString = [NSString stringWithFormat:@"%@/%@",kSWCheckEmailURL,email];
    
    
    NSURL *goodEmailURL = [NSURL URLWithString:goodEmailURLString];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:goodEmailURL
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:10.0];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
    
    
    NSLog(@"good usename url string: %@",goodEmailURL);
    
    if (responseData) {
        NSLog(@"RESPONSE DATA: ***%@***",[NSString stringWithCString:[responseData bytes] encoding:NSUTF8StringEncoding]);
        [self processRegisterResponse: response];
        
        
        NSRange range = [(NSString*)[[response URL] absoluteString] rangeOfString:@"success" options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound) {
            NSLog(@"EMAIL IS GOOD!");
            
            return YES;
            
            
        } else {
            NSLog(@"EMAIL IS BAD!");
            
            return NO;
        }
        
        
        
    } else {
        NSLog(@"Error checking email");
        return NO;
    }
    
    
    
    
}





///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) processRegisterResponse: (NSURLResponse*) response {
    
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 1) {
        [passwordField becomeFirstResponder];
    }
    if (textField.tag == 2) {
        [emailField becomeFirstResponder];
    }   
    if (textField.tag == 3) {
        [self doneButtonPressed:self];
    }     
    return YES;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setBarButtons {
    
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                              initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered
                                              target:self action:@selector(dismiss)] autorelease];
    
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithTitle:@"Done" style:UIBarButtonItemStyleBordered
                                               target:self action:@selector(doneButtonPressed: )] autorelease];
    
    
    
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) doneButtonPressed: (id)sender {
    
        if (![self goodUsername:usernameField.text]) {
            [PRPAlertView showWithTitle:@"Oh No!" message:@"That username is already taken." buttonTitle:@"That's Terrible."];
        } else if (![self goodEmail:emailField.text]) {    
            //[PRPAlertView showWithTitle:@"Hmmmm." message:@"That email has already been used." buttonTitle:@"That's Terrible."];
            [PRPAlertView showWithTitle:@"Hmmmm." 
                                message:@"There is already an account with that email." 
                            cancelTitle:@"Reset Password" 
                            cancelBlock:^(void){
                                [[TTNavigator navigator] openURLs:@"tt://main/login/forgot"];
                            } 
                             otherTitle:@"I got this" 
                             otherBlock:^(void){
                    
                                    
                            }
             ];
        } else {
            [self startRegister:sender];
        }
        
    
    
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dismiss {      
    
    [self dismissModalViewControllerAnimated:YES];
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dismissToFeed {      
    
    
    
    NSLog(@"HOLY CRAP WHY DOES THIS NOT WORK.");
    TTNavigator *navigator = [TTNavigator navigator];
    [navigator removeAllViewControllers];
    
    [self dismissModalViewControllerAnimated:YES];
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    TTURLAction *urlAction  =   [[TTURLAction actionWithURLPath:@"tt://main/tabBar/"] applyAnimated:NO];
    [[TTNavigator navigator]    openURLAction:urlAction];    
}



@end
