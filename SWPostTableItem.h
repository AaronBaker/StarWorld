//
//  SWPostTableItem.h
//  StarWorld
//
//  Created by Aaron Baker on 10/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Three20/Three20.h>

@interface SWPostTableItem : TTTableMessageItem {
    
    NSInteger ID;
    NSInteger starCount;
    
}

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger starCount;

+ (id)itemWithTitle:(NSString*)title 
            caption:(NSString*)caption 
               text:(NSString*)text
          timestamp:(NSDate*)timestamp 
                 ID:(NSInteger)itemID
          starcount:(NSInteger)itemStarCount
                URL:(NSString*)URL;

@end


