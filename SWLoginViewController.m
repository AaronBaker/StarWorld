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
@end

@implementation SWLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction) startLogin: (id)sender {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:username.text forKey:@"data[User][username]"];
    [params setObject:password.text forKey:@"data[User][password]"];
    
    
    NSURL *postURL = [NSURL URLWithString:kSWLoginURL];
    NSURLRequest *postRequest;
    postRequest = [PRPFormEncodedPOSTRequest requestWithURL:postURL
                                             formParameters:params];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:postRequest
                                                 returningResponse:&response
                                                             error:&error];
    if (responseData) {
        NSLog(@"RESPONSE DATA: %@",[NSString stringWithCString:[responseData bytes] encoding:NSUTF8StringEncoding]);
        [self processLoginResponse: response];
    } else {
        NSLog(@"Error posting to %@ (%@)", kSWLoginURL, error);
    }

    
}

- (void) getLoginCookie {
    
    
}

- (void) processLoginResponse: (NSURLResponse*) response {
    
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSDictionary *fields = [HTTPResponse allHeaderFields];
    NSLog([fields description]);
    
    NSString *cookie = [fields valueForKey:@"Set-Cookie"];
    NSLog(@"C IS FOR COOKIE: %@",cookie);
    
    
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

@end
