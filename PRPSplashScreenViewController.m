/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
***/
    //
//  PRPSplashScreenViewController.m
//  BasicSplashScreen
//
//  Created by Matt Drance on 10/1/10.
//  Updated by Paul Warren on 1/21/11
//  Copyright 2010 Bookhouse Software, LLC. All rights reserved.
//  Copyright 2010 PrimitiveDog Software, LLC. All rights reserved.
//

#import "PRPSplashScreenViewController.h"
#import <QuartzCore/QuartzCore.h>
#define DURATION 0.75

NSString *const PRPSplashScreenFadeAnimation = @"PRPSplashScreenFadeAnimation";

@interface PRPSplashScreenViewController ()

- (void)animate;

@end

@implementation PRPSplashScreenViewController

@synthesize splashImage;
@synthesize maskImage;
@synthesize delegate;
@synthesize transition;
@synthesize maskImageName;
@synthesize delay;
@synthesize anchor;

- (void)showInWindow:(UIWindow *)window {
    [window addSubview:self.view];        
}

- (void)viewDidLoad {
    self.view.layer.contentsScale = [[UIScreen mainScreen] scale];
    self.view.layer.contents = (id)self.splashImage.CGImage;
    self.view.contentMode = UIViewContentModeBottom;
    if (self.transition == 0) self.transition = ClearFromRight;
}

- (UIImage *)splashImage {
    if (splashImage == nil) {
        splashImage = [UIImage imageNamed:@"Default.png"];
    }
    return splashImage;
}

- (UIImage *)maskImage {
    if (maskImage != nil) [maskImage release];
    NSString *defaultPath = [[NSBundle mainBundle] 
                                pathForResource:self.maskImageName 
                                ofType:@"png"];
    maskImage = [[UIImage alloc] 
                    initWithContentsOfFile:defaultPath];
    return maskImage;
}

- (void)setMaskLayerwithanchor {

    CALayer *maskLayer = [CALayer layer];
    maskLayer.anchorPoint = self.anchor;
    maskLayer.frame = self.view.superview.frame;
    maskLayer.contents = (id)self.maskImage.CGImage;
    self.view.layer.mask = maskLayer;
}

- (void)viewDidAppear:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(splashScreenDidAppear:)]) {
        [self.delegate splashScreenDidAppear:self];
    }
//    switch (self.transition) {              
//        case CircleFromCenter:
//            self.maskImageName = @"mask";
//            self.anchor = CGPointMake(0.5, 0.5);
//            break;
//        case ClearFromCenter:
//            self.maskImageName = @"wideMask";
//            self.anchor = CGPointMake(0.5, 0.5);
//            break;
//        case ClearFromLeft:
//            self.maskImageName = @"leftStripMask";
//            self.anchor = CGPointMake(0.0, 0.5);
//            break;
//        case ClearFromRight:
//            self.maskImageName = @"RightStripMask";
//            self.anchor = CGPointMake(1.0, 0.5);
//            break;
//        case ClearFromTop:
//            self.maskImageName = @"TopStripMask";
//            self.anchor = CGPointMake(0.5, 0.0);
//            break;
//        case ClearFromBottom:
//            self.maskImageName = @"BottomStripMask";
//            self.anchor = CGPointMake(0.5, 1.0);
//            break;
//        default:
//            return;
//    }
    
    self.maskImageName = @"star-mask";
    self.anchor = CGPointMake(0.5, 0.5);
    
    
    [self performSelector:@selector(animate) 
                                withObject:nil 
                                afterDelay:self.delay];
}

- (void)animate {
    if ([self.delegate respondsToSelector:@selector(splashScreenWillDisappear:)]) {
        [self.delegate splashScreenWillDisappear:self];
    }

    [self setMaskLayerwithanchor];

    CABasicAnimation *anim = [CABasicAnimation 
                                animationWithKeyPath:@"transform.scale"];
    anim.duration = DURATION;
    anim.toValue = [NSNumber numberWithInt:self.view.bounds.size.height/8];
    anim.fillMode = kCAFillModeBoth;
    anim.removedOnCompletion = NO;
    anim.delegate = self;
    [self.view.layer.mask addAnimation:anim forKey:@"scale" ];

}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	
    self.view.layer.mask = nil;
    [self.view removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(splashScreenDidDisappear:)]) {
        [self.delegate splashScreenDidDisappear:self];
    }
}


- (void)dealloc {
    [splashImage release], splashImage = nil;
    [maskImage release], maskImage = nil;
    [maskImageName release], maskImageName = nil;
    [super dealloc];
}


@end
