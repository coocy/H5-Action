//
//  NSString+NSStringPlus.m
//  H5
//
//  Created by Alex on 13-7-7.
//  Copyright (c) 2013年 Alex. All rights reserved.
//

#import "NSStringPlus.h"

@implementation NSString (NSStringPlus)

- (NSDictionary *)parseQueryString
{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	NSArray *_parameters = [self componentsSeparatedByString:@"&"];
	for (NSInteger i = 0; i < [_parameters count]; i++) {
		NSArray *keyValues = [[_parameters objectAtIndex:i] componentsSeparatedByString:@"="];
		if ([keyValues count] >= 2) {
			NSString *key = [[keyValues objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
			if (key.length > 0) {
				NSString *value  = [[[keyValues objectAtIndex:1] stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
				[parameters setObject:value forKey:key];
			}
		}
	}

	return parameters;
}

@end
