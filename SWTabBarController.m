#import "SWTabBarController.h"


@implementation SWTabBarController

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)viewDidLoad {
  [self setTabURLs:[NSArray arrayWithObjects:@"tt://swfeed",
                                             @"tt://swstarred",
                                             nil]];
}

@end
