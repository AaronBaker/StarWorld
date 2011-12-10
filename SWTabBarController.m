#import "SWTabBarController.h"


@implementation SWTabBarController

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)viewDidLoad {
  [self setTabURLs:[NSArray arrayWithObjects:@"tt://main/tabBar/swfeed",
                                             @"tt://main/tabBar/swstarred",
                                             nil]];
}

@end
