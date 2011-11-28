//
//  SWStarPostTableCell.h
//  StarWorld
//
//  Created by Aaron Baker on 10/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Three20/Three20.h>
#import "SWCurrentUser.h"

@interface SWStarPostTableCell : TTTableMessageItemCell {
    
    UIButton *starButton;
    UILabel *byLabel;
    UILabel *starLabel;
    SWCurrentUser *currentUser;
}



@end
