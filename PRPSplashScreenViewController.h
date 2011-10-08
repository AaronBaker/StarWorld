/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
***/
//
//  PRPSplashScreenViewController.h
//  BasicSplashScreen
//
//  Created by Matt Drance on 10/1/10.
//  Copyright 2010 Bookhouse Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {	
    CircleFromCenter,
	ClearFromCenter,
	ClearFromLeft, 
	ClearFromRight, 
	ClearFromTop, 
	ClearFromBottom, 
} TransitionDirection;

@protocol PRPSplashScreenViewControllerDelegate;

@interface PRPSplashScreenViewController : UIViewController {}

@property (nonatomic, retain) UIImage *splashImage;
@property (nonatomic, retain) UIImage *maskImage;
@property (nonatomic, assign) id <PRPSplashScreenViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString *maskImageName;
@property (nonatomic) TransitionDirection transition;
@property (nonatomic) CGFloat delay;
@property (nonatomic) CGPoint anchor;

- (void)showInWindow:(UIWindow *)window;

@end

@protocol PRPSplashScreenViewControllerDelegate <NSObject>

@optional
- (void)splashScreenDidAppear:(PRPSplashScreenViewController *)splashScreen;
- (void)splashScreenWillDisappear:(PRPSplashScreenViewController *)splashScreen;
- (void)splashScreenDidDisappear:(PRPSplashScreenViewController *)splashScreen;

@end
