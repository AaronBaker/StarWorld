//
//  SWLoginViewController.m
//  StarWorld
//
//  Created by Aaron Baker on 9/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWLoginViewController.h"
#import "PRPFormEncodedPOSTRequest.h"

static NSString* kSWLoginURL = @"http://173.230.142.162/users/login";


@interface SWLoginViewController (hidden)
    - (void) processLoginResponse: (NSURLResponse*) response;
    - (void) getLoginCookie;
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

    currentUser.request = [PRPFormEncodedPOSTRequest requestWithURL:postURL
                                             formParameters:params];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:currentUser.request
                                                 returningResponse:&response
                                                             error:&error];
    if (responseData) {
        NSLog(@"RESPONSE DATA: %@",[NSString stringWithCString:[responseData bytes] encoding:NSUTF8StringEncoding]);
        [self processLoginResponse: response];
        
        if ([[NSString stringWithCString:[responseData bytes] encoding:NSUTF8StringEncoding] isEqualToString:@"YES"]) {
            NSLog(@"AUTH SUCCESS!");
            currentUser.authenticated = YES;
            NSLog(@"Authenticated: %d",currentUser.authenticated);

            [self dismissModalViewControllerAnimated:YES];
        }
        
        
        for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
        {
            NSLog(@"name: '%@'\n",   [cookie name]);
            NSLog(@"value: '%@'\n",  [cookie value]);
            NSLog(@"domain: '%@'\n", [cookie domain]);
            NSLog(@"path: '%@'\n",   [cookie path]);
        }
        
    } else {
        NSLog(@"Error posting to %@ (%@)", kSWLoginURL, error);
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
        NSLog(@"name: '%@'\n",   [cookie name]);
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
    
    [self getLoginCookie];
    
    
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
