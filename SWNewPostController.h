//
//  SWNewPostController.h
//  StarWorld
//
//  Created by Aaron Baker on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Three20/Three20.h>
#import "SWCurrentUser.h"

@interface SWNewPostController : TTPostController <TTPostControllerDelegate> {
    SWCurrentUser *currentUser;
}

@end
