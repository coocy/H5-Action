//
//  AXViewController.m
//  H5
//
//  Created by Alex on 13-7-6.
//  Copyright (c) 2013年 Alex. All rights reserved.
//

#import "AXViewController.h"
#import "AXWebView.h"

@implementation AXViewController
{
	AXWebView *_webView;
	UITextView *_textView;
	NSString *_callbackId;
}

- (id)init
{
    self = [super init];
    if (self) {
		self.title = @"H5";
		_callbackId = [@"" retain];
    }
    return self;
}

- (void)dealloc
{
	[_webView release];
	[_textView release];
	[_callbackId release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onActionMessage:) name:@"ActionMessage" object:nil];

	self.view.backgroundColor = [UIColor whiteColor];

	CGRect frame = self.view.bounds;

	_webView = [[AXWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height / 2)];
	
	NSString *htmlPathString = [[NSBundle mainBundle] pathForResource:@"page" ofType:@"html"];
	NSData *htmlData = [NSData dataWithContentsOfFile:htmlPathString];

	NSString *pathString = [htmlPathString stringByDeletingLastPathComponent];
	[_webView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:[NSURL URLWithString:pathString]];
	
	
	[self.view addSubview:_webView];

	frame.origin.y = frame.size.height / 2;
	frame.size.height = frame.size.height / 2;
	_textView = [[UITextView alloc] initWithFrame:frame];
	_textView.font = [UIFont systemFontOfSize:12.0];
	_textView.textColor = [UIColor colorWithWhite:.4 alpha:1];
	_textView.editable = NO;

	[self.view addSubview:_textView];
	
}

- (void)onActionMessage:(NSNotification*)notification
{
	NSDictionary *data = notification.userInfo;

	NSString *message = [NSString stringWithFormat:@"Type: %@\r\nData: %@\r\n",
						 [data valueForKey:@"type"],
						 [data valueForKey:@"data"]];

	_textView.text = message;

	NSString *type = [data valueForKey:@"type"];
	data = [data valueForKey:@"data"];

	if ([type isEqualToString:@"send_message"]) {
		[self actionSendMessage:data];
	} else if ([type isEqualToString:@"take_photo"]) {
		[self actionTakePhoto:data];
	}
}

- (void)actionSendMessage:(NSDictionary*)data
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ActionMessageCallback" object:nil userInfo:data];
}

- (void)actionTakePhoto:(NSDictionary*)data
{
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
	imagePicker.allowsEditing = NO;
	imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;

	_callbackId = [data objectForKey:@"callbackId"];
	if (_callbackId) {
		[_callbackId retain];
	}

	[self presentModalViewController:imagePicker animated:YES];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self dismissModalViewControllerAnimated:YES];
	[picker release];
	
	[info retain];

	__block id callbackId = _callbackId;

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
	
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
		NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
		NSString *encodedString = [self base64Encoding:imageData];

		dispatch_async(dispatch_get_main_queue(), ^{

			NSDictionary *data = @{@"image": encodedString,@"callbackId":callbackId};

			[[NSNotificationCenter defaultCenter] postNotificationName:@"ActionMessageCallback"
																object:nil
															  userInfo:data];
		});
	});

	[info release];
	
}

- (NSString*)base64Encoding:(NSData*)theData
{

    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];

    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;

    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;

            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }

        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }

    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}

@end
