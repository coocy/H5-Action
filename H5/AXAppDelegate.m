//
//  AXAppDelegate.m
//  H5
//
//  Created by Alex on 13-7-6.
//  Copyright (c) 2013年 Alex. All rights reserved.
//

#import "AXAppDelegate.h"

#import "AXRootViewController.h"

@implementation AXAppDelegate
{
	UIWindow *_window;
	AXRootViewController *_rootViewController;
}

- (void)dealloc
{
	[_window release];
	[_rootViewController release];

	[super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	_rootViewController = [[AXRootViewController alloc] init];
	_window.rootViewController = _rootViewController;
    [_window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

@end
