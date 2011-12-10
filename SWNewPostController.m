//
//  SWNewPostController.m
//  StarWorld
//
//  Created by Aaron Baker on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWNewPostController.h"
#import "PRPFormEncodedPOSTRequest.h"

static NSString* kSWNewPostURL = @"http://pandora.starworlddata.com/posts/add";

@interface SWNewPostController (hidden)

-(void)checkCount;

@end


@implementation SWNewPostController
@synthesize countLabel;

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {

    if ((self = [super init])) {
        self.delegate = self;
        
        currentUser = [SWCurrentUser currentUserInstance];
        

        
        if (!currentUser.authenticated) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"You need to log in before you can post." 
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
       
        
        CGFloat left = 40.0;
        CGFloat top = 40.0;
        
        CGRect countFrame = CGRectMake(left, top, 30.0, 20.0);
        countLabel = [[UILabel alloc] initWithFrame:countFrame];
        countLabel.text = @"140";
        countLabel.textColor = RGBCOLOR(79, 89, 105);
        countLabel.alpha = 0;
        countLabel.backgroundColor = [UIColor clearColor];
        countLabel.tag = 52;
        [self.textView addSubview:countLabel];
        
        //FIX THIS THING.
        //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkCount) userInfo:nil repeats:YES];
        
        
        NSLog(@"COUNT TIMER ALLOCATED");
        countTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:0.1 target:self selector:@selector(checkCount) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:countTimer forMode:NSDefaultRunLoopMode];
        
        
    }
    
        
    
    return self;
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showInView:(UIView*)view animated:(BOOL)animated {
    [super showInView:view animated:animated];
    
    CGFloat left = self.textView.frame.size.width - 40.0;
    CGFloat top = self.textView.frame.size.height - 30.0;
    
    [countLabel setFrame:CGRectMake(left, top, 30.0, 20.0)];
    
    
    
}


/////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showAnimationDidStop {
    [super showAnimationDidStop];
    
    countLabel.alpha = 1;

}
/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewDidDisappear:(BOOL)animated {    
    [countTimer invalidate];
    [countTimer release];
    
    [super viewDidDisappear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)viewDidAppear:(BOOL)animated {
    
    
    
    [super viewDidAppear:animated];
    
    
   
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
    
    [super willAnimateRotationToInterfaceOrientation:fromInterfaceOrientation duration:duration];
    
    CGFloat left = self.textView.frame.size.width - 20.0;
    CGFloat top = self.textView.frame.size.width - 20.0;
    
    
    CGRect countFrame = CGRectMake(left, top, 20.0, 20.0);
    
    
    
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)checkCount {
    NSUInteger charCount = 140 - self.textView.text.length;
    NSString *charString = [[NSString alloc] initWithFormat:@"%d",charCount];
    
    countLabel.text = charString;
    
    [charString release];
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForActivity {
    return @"SOMETHING's HAPPENING!";
}


///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)postController:(TTPostController *)postController 
           didPostText:(NSString *)text 
            withResult:(id)result { 
    

    
    NSString *xString = [NSString stringWithFormat:@"%f",currentUser.x];
    NSString *yString = [NSString stringWithFormat:@"%f",currentUser.y];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:text forKey:@"data[Post][body]"];
    [params setObject:xString forKey:@"data[Post][x]"];
    [params setObject:yString forKey:@"data[Post][y]"];
    
    NSURL *postURL = [NSURL URLWithString:kSWNewPostURL];
    
    currentUser.request = [PRPFormEncodedPOSTRequest requestWithURL:postURL
                                                     formParameters:params];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:currentUser.request
                                                 returningResponse:&response
                                                             error:&error];
    
    if (responseData) {
        
        NSRange range = [(NSString*)[[response URL] absoluteString] rangeOfString:@"success" options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
                 
            
        } else {
            NSLog(@"Error posting to %@ (%@)", kSWNewPostURL, error);
         
            
        }
    }
    
} 

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(countLabel);

    [super dealloc];
}



@end
