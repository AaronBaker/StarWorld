/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
***/
//
//  PRPToggleButton.h
//  ToggleButton
//
//  Created by Matt Drance on 11/18/09.
//  Copyright 2009 Bookhouse Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRPToggleButton : UIButton {}

// Defaults to YES
@property (nonatomic, getter=isOn) BOOL on;
@property (nonatomic, getter=isAutotoggleEnabled) BOOL autotoggleEnabled;

+ (id)buttonWithOnImage:(UIImage *)onImage 
               offImage:(UIImage *)offImage 
       highlightedImage:(UIImage *)highlightedImage;

- (BOOL)toggle;

@end
