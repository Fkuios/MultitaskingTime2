//
//  FKLabelUpdater.m
//  MultitaskingTime
//
//  Created by Alistair Geesing on 9/19/10.
//  Copyright 2010 None. All rights reserved.
//

#import "FKLabelUpdater.h"
#import "FKTime.h"

static FKLabelUpdater *sharedInstance = nil;

@implementation FKLabelUpdater

+ (id)sharedInstance {
	@synchronized(self) {
		if (!sharedInstance) {
			sharedInstance = [[FKLabelUpdater alloc] init];
		}
	}
	
	return sharedInstance;
}

- (id)init {
	if ((self = [super init])) {
		dateFormatter = [[NSDateFormatter alloc] init];
		
		NSString *format = [NSDateFormatter dateFormatFromTemplate:@"Mdhhmmss" options:0 locale:[NSLocale currentLocale]];
		[dateFormatter setDateFormat:format];
		
		//NSDictionary *preferences = [(MTSBIconServer *)[objc_getClass("MTSBIconServer") sharedInstance] preferencesForBundleID:[[NSBundle bundleForClass:[self class]] bundleIdentifier]];
        NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:MTPreferencesFile];
		
		NSLog(@"preferences: %@", preferences);
		
		BOOL showSeconds = [[preferences objectForKey:@"showseconds"] boolValue];
		BOOL showDate = [[preferences objectForKey:@"showdate"] boolValue];
		
		if (showDate) {
			[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		}
		
		NSDateFormatterStyle style = NSDateFormatterShortStyle;
		
		if (showSeconds) {
			style = NSDateFormatterMediumStyle;
		}
		
		if (style != -1) {
			[dateFormatter setTimeStyle:style];
		}
	}
	
	return self;
}

- (void)updateTimeForLabel:(UILabel *)l {
	if (label) {
		[label release];
	}
	label = [l retain];
}

- (void)_update {
	if (!label) {
		return;
	}
	
	NSString *string = [dateFormatter stringFromDate:[NSDate date]];
	if (![[label text] isEqualToString:string]) {
		[label setText:string];
		CGSize stringSize = [string sizeWithFont:LabelFont];
		[label setFrame:CGRectMake(0, 0, stringSize.width, [label frame].size.height)];
        [[objc_getClass("MTSBIconServer") sharedInstance] reorderAllIcons];
	}
}

- (void)startUpdating {
	if (!isUpdating) {
		[self _update];
		timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(_update) userInfo:nil repeats:YES];
		[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
		isUpdating = YES;
	}
}

- (void)stopUpdating {
	if (isUpdating) {
		[timer invalidate];
		isUpdating = NO;
	}
}

- (void)dealloc {
	[label release];
	[dateFormatter release];
	
	[super dealloc];
}

@end