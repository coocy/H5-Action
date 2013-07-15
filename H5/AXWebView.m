//
//  AXWebView.m
//  H5
//
//  Created by Alex on 13-7-6.
//  Copyright (c) 2013年 Alex. All rights reserved.
//

#import "AXWebView.h"
#import "NSStringPlus.h"
#import "JSONKit.h"

@implementation AXWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.delegate = self;
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		self.scrollView.bounces = NO;


		/* Action消息的回调 */
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(onActionMessageCallback:)
													 name:@"ActionMessageCallback" object:nil];
		/* 设备事件 */
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(onActionAppEvent:)
													 name:@"ActionAppEvent" object:nil];
    }
    return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSURL *URL = request.URL;
	if ([URL.scheme isEqualToString:@"ax"]) {
		
		NSDictionary *queryData = nil;
		if (URL.query != nil) {
			queryData = [URL.query parseQueryString];
		}

		NSDictionary *params = @{
			@"type": URL.host,
			@"data": queryData
		};

		[[NSNotificationCenter defaultCenter] postNotificationName:@"ActionMessage" object:nil userInfo:params];
		return NO;
	}
	return YES;
}

/* 调用webView中的回调方法 */
- (void)onActionMessageCallback:(NSNotification*)notification
{
	NSDictionary *data = notification.userInfo;

	if (data != nil) {
		NSString *jsonString = [data JSONString];
		NSString *script = [NSString stringWithFormat:@"Action.callback(%@)", jsonString];
		[self stringByEvaluatingJavaScriptFromString:script];
		NSLog(@"JSON: %@", jsonString);
	}
}

/* 向webView发送设备事件 */
- (void)onActionAppEvent:(NSNotification*)notification
{
	NSDictionary *data = notification.userInfo;
	NSString *jsonString;
	NSString *eventName = [NSString stringWithFormat:@"\"%@\"", [data objectForKey:@"event"]];

	data = [data objectForKey:@"data"];

	if (data != nil) {
		jsonString = [data JSONString];
	} else {
		jsonString = @"null";
	}
	
	NSString *script = [NSString stringWithFormat:@"Action.deviceEvent(%@, %@)", eventName, jsonString];
	[self stringByEvaluatingJavaScriptFromString:script];
	
}

@end
