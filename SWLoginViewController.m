//
//  SWLoginViewController.m
//  StarWorld
//
//  Created by Aaron Baker on 9/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWLoginViewController.h"
#import "PRPFormEncodedPOSTRequest.h"

static NSString* kSWLoginURL = @"http://pandora.starworlddata.com/users/login";


@interface SWLoginViewController (hidden)
    - (void) processLoginResponse: (NSURLResponse*) response;
    - (void) getLoginCookie;
    - (void) dismiss;
@end

@implementation SWLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                                  initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                                  target:self action:@selector(dismiss)] autorelease];
    }
    return self;
}

-(IBAction) startLogin: (id)sender {
    
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:username.text forKey:@"data[User][username]"];
    [params setObject:password.text forKey:@"data[User][password]"];
    
    
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
        
        [currentUser login];
        
        
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

- (void) processLoginResponse: (NSURLResponse*) response {
    
    
}



- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    currentUser = [SWCurrentUser currentUserInstance];
        
    //If form security increases later, we might need this.
    //[self getLoginCookie];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dismiss {
    [self dismissModalViewControllerAnimated:YES];
}

@end
