//
//  FKBattery.m
//  MultitaskingTime
//
//  Created by Alistair Geesing on 9/22/10.
//  Copyright 2010 None. All rights reserved.
//

#import "FKBattery.h"
#import <objc/runtime.h>


@implementation FKBattery

@synthesize progress;
@synthesize isCharged;
@synthesize isCharging;
@synthesize isVisible;

+ (MTSBIconPosition)position {
	return MTSBIconPositionRight;
}

- (id)init {
    if ((self = [super init])) {
        batteryView = [[FKBatteryView alloc] initWithFrame:CGRectMake(0, 0, 21, 20)];
        
        //NSDictionary *preferences = [[objc_getClass("MTSBIconServer") sharedInstance] preferencesForBundleID:[[NSBundle bundleForClass:[self class]] bundleIdentifier]];
        NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:MTPreferencesFile];
		
        showPercentage = [[preferences objectForKey:@"showpercentage"] boolValue];
        
        NSString *positionString = [preferences objectForKey:@"percentageposition"];
        
        //[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryChanged:) name:UIDeviceBatteryLevelDidChangeNotification object:[UIDevice currentDevice]];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryChanged:) name:UIDeviceBatteryStateDidChangeNotification object:[UIDevice currentDevice]];
        [self batteryChanged:nil];
        
        
        
        if (showPercentage) {
            if ([positionString isEqualToString:@"right"]) {
                position = PositionRight;
            }
            else {
                position = PositionLeft;
            }
            
            CGSize stringSize = [[self currentBatteryPercentageString] sizeWithFont:[UIFont boldSystemFontOfSize:15.0]];
            percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, stringSize.width, stringSize.height)];
            [percentageLabel setBackgroundColor:[UIColor clearColor]];
            [percentageLabel setTextColor:[UIColor whiteColor]];
            [percentageLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
            [percentageLabel setText:[self currentBatteryPercentageString]];
            
            switch (position) {
                case PositionLeft:
                    [percentageLabel setTextAlignment:UITextAlignmentRight];
                    break;
                case PositionRight:
                    [percentageLabel setTextAlignment:UITextAlignmentLeft];
                    break;
            }
        }        
        
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [batteryView frame].size.width + 3 + [percentageLabel frame].size.width, [batteryView frame].size.height)];
        [percentageLabel setCenter:CGPointMake([percentageLabel center].x, [batteryView frame].size.height / 2)];
        [containerView addSubview:batteryView];
        if (showPercentage) {
            [containerView addSubview:percentageLabel];
        }
    }
    
    return self;
}

- (NSString *)currentBatteryPercentageString {
    return [[NSString stringWithFormat:@"%i", progress] stringByAppendingString:@"%"];
}

- (UIView *)view {
	return containerView;
}

- (void)didHideView {
	[batteryView setIsVisible:NO];
    [self layoutContainerView];
}

- (void)didShowView {
	[batteryView setIsVisible:YES];
    [self batteryChanged:nil];
    [self layoutContainerView];
}


- (void)setIsCharged:(BOOL)charged {
	isCharged = charged;
	isCharging = NO;
	[batteryView setNeedsDisplay];
}

- (void)setIsCharging:(BOOL)charging {
	isCharging = charging;
	isCharged = NO;
	[batteryView setNeedsDisplay];
}

- (void)setProgress:(NSInteger)prog {
	progress = prog;
	isCharged = NO;
	isCharging = NO;
	[batteryView setNeedsDisplay];
}

- (void)batteryChanged:(NSNotification *)notif {
	if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateFull) {
		[self setIsCharged:YES];
	}
	else if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging) {
		[self setIsCharging:YES];
	}
    
    [self setProgress:[[objc_getClass("SBUIController") sharedInstance] batteryCapacityAsPercentage]];
	
	[batteryView setNeedsDisplay];
}

- (void)layoutContainerView {
    if (showPercentage) {
        CGFloat x = 0;
        CGFloat x2 = 0;
        
        CGSize stringSize = [[self currentBatteryPercentageString] sizeWithFont:[UIFont boldSystemFontOfSize:15.0]];
        [percentageLabel setText:[self currentBatteryPercentageString]];
        
        switch (position) {
            case PositionLeft: {
                x = 0;
                x2 = stringSize.width + 3;
                break;
            }
            case PositionRight: {
                x = [batteryView frame].size.width + 3;
                x2 = 0;
                break;
            }
        }
        
        CGRect percentageRect = [percentageLabel frame];
        percentageRect.origin.x = x;
        percentageRect.size.width = stringSize.width;
        [percentageLabel setFrame:percentageRect];
        
        CGRect batteryRect = [batteryView frame];
        batteryRect.origin.x = x2;
        [batteryView setFrame:batteryRect];
        
        [containerView setFrame:CGRectMake(0, 0, stringSize.width + batteryRect.size.width + 3, [containerView frame].size.height)];
        [[objc_getClass("MTSBIconServer") sharedInstance] reorderAllIcons];
    }
}

@end