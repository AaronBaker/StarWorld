//
//  UIBarButtonItem+SWAdditions.h
//  StarWorld
//
//  Created by Aaron Baker on 12/7/11.
//  Copyright (c) 2011 Inter Media Outdoors. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIBarButtonItem(SWAdditions)

+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image target:(id)target action:(SEL)action;

@end