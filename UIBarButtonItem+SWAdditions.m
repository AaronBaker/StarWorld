//
//  UIBarButtonItem+SWAdditions.m
//  StarWorld
//
//  Created by Aaron Baker on 12/7/11.
//  Copyright (c) 2011 Inter Media Outdoors. All rights reserved.
//

#import "UIBarButtonItem+SWAdditions.h"

@implementation UIBarButtonItem(SWAdditions)

+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image target:(id)target action:(SEL)action {
    
    UIButton* someButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [someButton setBackgroundImage:image forState:UIControlStateNormal];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *playButton = [[[UIBarButtonItem alloc]initWithCustomView:someButton]autorelease];
    NSLog(@"CUSTOPM CUSTPM CUSTOM BUTTON!!!!!");
    return playButton;
}
@end