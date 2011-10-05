/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
***/
//
//  PRPToggleButton.m
//  ToggleButton
//
//  Created by Matt Drance on 11/18/09.
//  Copyright 2009 Bookhouse Software, LLC. All rights reserved.
//

#import "PRPToggleButton.h"

@interface PRPToggleButton ()

@property (nonatomic, retain) UIImage *onImage;
@property (nonatomic, retain) UIImage *offImage;

@end


@implementation PRPToggleButton

@synthesize on;
@synthesize autotoggleEnabled;

@synthesize onImage;
@synthesize offImage;

- (void)dealloc {
    [onImage release], onImage = nil;
    [offImage release], offImage = nil;
    [super dealloc];
}

+ (id)buttonWithOnImage:(UIImage *)onImage 
               offImage:(UIImage *)offImage 
       highlightedImage:(UIImage *)highlightedImage {
    PRPToggleButton *button;
    button = [self buttonWithType:UIButtonTypeCustom];
    button.onImage = onImage;
    button.offImage = offImage;
    [button setBackgroundImage:offImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage 
                      forState:UIControlStateHighlighted];
    button.autotoggleEnabled = YES; 
    return button;
}

// Set up default auto toggle if loaded from IB
- (void)awakeFromNib {    
    self.autotoggleEnabled = YES;
    self.onImage = [self backgroundImageForState:UIControlStateSelected];
    self.offImage = [self backgroundImageForState:UIControlStateNormal];
    [self setBackgroundImage:nil forState:UIControlStateSelected];
}

#pragma mark Toggle support
// Change the selected state, UIButton will update appearance automatically
- (BOOL)toggle {
    self.on = !self.on;
    return self.on;
}

- (void)setOn:(BOOL)onBool {
    if (on != onBool) {
        on = onBool;
        [self setBackgroundImage:(on ? self.onImage : self.offImage) 
                        forState:UIControlStateNormal];
    }
}

// Detect a "touchUpInside" and auto-toggle if so configured
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    if (self.touchInside && self.autotoggleEnabled) {
        [self toggle];
    }
}

@end