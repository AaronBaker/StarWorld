//
//  SWLoginViewController.h
//  StarWorld
//
//  Created by Aaron Baker on 9/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWCurrentUser.h"


@interface SWLoginViewController : UIViewController {
    
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    
    SWCurrentUser *currentUser;
}

-(IBAction) startLogin: (id)sender;



@end
