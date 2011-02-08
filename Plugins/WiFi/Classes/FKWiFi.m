//
//  FKWiFi.m
//  WiFi
//
//  Created by Alistair Geesing on 9/22/10.
//  Copyright 2010 None. All rights reserved.
//

#import "FKWiFi.h"
#import "FKWiFiStrengthView.h"

@implementation FKWiFi

+ (MTSBIconPosition)position {
	return MTSBIconPositionLeft;
}

- (id)init {
	if ((self = [super init])) {
		strengthView = [[FKWiFiStrengthView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [strengthView startUpdating];
	}
	
	return self;
}

- (UIView *)view {
	return strengthView;
}

- (void)dealloc {
	[strengthView release];
	
	[super dealloc];
}

- (void)didHideView {
	[strengthView stopUpdating];
}

- (void)didShowView {
	[strengthView startUpdating];
}

@end
