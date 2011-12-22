//
//  SWLoginAlert.m
//  StarWorld
//
//  Created by Aaron Baker on 12/11/11.
//  Copyright (c) 2011 Inter Media Outdoors. All rights reserved.
//

#import "SWLoginAlert.h"

@implementation SWLoginAlert

- (void)show {
    
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hold On!" 
                                                      message:@"You need to log in before you can post." 
                                                     delegate:self 
                                            cancelButtonTitle:@"Fuck, Nevermind." 
                                            otherButtonTitles:@"New Account", @"Login", nil];
    
    [message show];
    [message release];  
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
	
	if([title isEqualToString:@"Fuck, Nevermind."])
	{
		NSLog(@"Nevermind was selected.");
	}
	else if([title isEqualToString:@"New Account"])
	{
		NSLog(@"New Account was selected.");
        [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"tt://main/register"]];
	}
	else if([title isEqualToString:@"Login"])
	{
		NSLog(@"Login was selected.");
        [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"tt://main/login"]];
        
	}	
}

- (void)dealloc {
    
    [super dealloc];
}


@end
