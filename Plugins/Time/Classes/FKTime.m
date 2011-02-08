//
//  FKTime.m
//  MultitaskingTime
//
//  Created by Alistair Geesing on 9/22/10.
//  Copyright 2010 None. All rights reserved.
//

#import "FKTime.h"

@implementation FKTime

+ (MTSBIconPosition)position {
	return MTSBIconPositionCenter;
}

- (id)init {
    if ((self = [super init])) {
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
        [timeLabel setText:@""];
        [timeLabel setTextAlignment:UITextAlignmentCenter];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setTextColor:[UIColor whiteColor]];
        [timeLabel setFont:LabelFont];
        
        updater = [[FKLabelUpdater alloc] init];
        [updater updateTimeForLabel:timeLabel];
        [updater startUpdating];
    }
    
    return self;
}

- (UIView *)view {
	return timeLabel;
}

- (void)dealloc {
    [timeLabel release];
	[updater release];
	
	[super dealloc];
}

- (void)didHideView {
	[updater stopUpdating];
}

- (void)didShowView {
	[updater startUpdating];
}

@end
