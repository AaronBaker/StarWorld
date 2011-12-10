//
//  SWRegisterController.m
//  StarWorld
//
//  Created by Aaron Baker on 12/4/11.
//  Copyright (c) 2011 Inter Media Outdoors. All rights reserved.
//

#import "SWRegisterController.h"
#import "PRPFormEncodedPOSTRequest.h"


static NSString* kSWRegisterURL = @"http://pandora.starworlddata.com/users/add";

@interface SWRegisterController (hidden)
- (void) processRegisterResponse: (NSURLResponse*) response;
- (void) dismiss;
- (void)setBarButtons;
- (id) startRegister: (id)sender;
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
            
            
            [currentUser login];
            [[TTNavigator navigator] openURLs:@"tt://main/tabBar/"];
            NSLog(@"Authenticated: %d",currentUser.authenticated);
            
            [self dismiss];
            
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
        [self startRegister:self];
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
                                               target:self action:@selector(startRegister: )] autorelease];
    
    
    
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dismiss {
    [self dismissModalViewControllerAnimated:YES];
}






@end
