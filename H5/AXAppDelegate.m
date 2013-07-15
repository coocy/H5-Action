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
	[self actionSendAppEvent:@"deviceResignActive"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[self actionSendAppEvent:@"deviceEnterBackground"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	[self actionSendAppEvent:@"deviceEnterForeground"];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[self actionSendAppEvent:@"deviceActive"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[self actionSendAppEvent:@"deviceEnd"];
}

- (void)actionSendAppEvent:(NSString*)eventName{
	NSDictionary *data = @{@"event": eventName};
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ActionAppEvent"
														object:nil
													  userInfo:data];
}

@end
