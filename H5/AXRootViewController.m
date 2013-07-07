//
//  AXRootViewController.m
//  H5
//
//  Created by Alex on 13-7-6.
//  Copyright (c) 2013年 Alex. All rights reserved.
//

#import "AXRootViewController.h"
#import "AXViewController.h"


@implementation AXRootViewController

- (id)init
{
    self = [super init];
    if (self) {
		/*AXNavigationBar *navigationBar = [[AXNavigationBar alloc] initWithFrame:CGRectZero];
		 [self setValue:navigationBar forKey:@"navigationBar"];
		 [navigationBar release];*/
		/*UIImage *image = [[UIImage alloc] init];
		UIImage *blankImage = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
		[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"blank.png"] forBarMetrics:UIBarMetricsDefault];
		[[UINavigationBar appearance] setShadowImage:blankImage];
		[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
		
		[[UINavigationBar appearance] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[image release];*/
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	AXViewController *viewController = [[AXViewController alloc] init];
	[self pushViewController:viewController animated:NO];
	[viewController release];

}



@end
