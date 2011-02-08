//
//  FKBatteryView.m
//  BatteryIcon
//
//  Created by Alistair Geesing on 9/18/10.
//  Copyright 2010 None. All rights reserved.
//

#import "FKBatteryView.h"

@interface UIImage (KitImage)

+ (UIImage *)kitImageNamed:(NSString *)name;

@end

@implementation FKBatteryView

@synthesize progress, isCharged, isCharging, isVisible;

const CGFloat batteryWidth = 21.0f;

- (id)initWithFrame:(CGRect)frame {
	frame.size.width = 21.0f;
	frame.size.height = 20.0f;
    if ((self = [super initWithFrame:frame])) {
		[self setBackgroundColor:[UIColor clearColor]];
        chargedImage = [UIImage kitImageNamed:@"Black_BatteryCharged.png"];
		chargingImage = [UIImage kitImageNamed:@"Black_BatteryCharging.png"];
		drainingBackground = [UIImage kitImageNamed:@"Black_BatteryDrainingBG.png"];
		drainingInsidesImage = [UIImage kitImageNamed:@"Black_BatteryDrainingInsides.png"];
		drainingInsidesLowImage = [UIImage kitImageNamed:@"Black_BatteryDrainingInsidesLow.png"];
		[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryChanged:) name:UIDeviceBatteryLevelDidChangeNotification object:[UIDevice currentDevice]];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryChanged:) name:UIDeviceBatteryStateDidChangeNotification object:[UIDevice currentDevice]];
		[self batteryChanged:nil];
		
		/*NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:MTPreferencesFile];
         NSDictionary *dictionaryPlugins = [dictionary objectForKey:@"plugins"];
         NSDictionary *preferences = [dictionaryPlugins objectForKey:[[NSBundle bundleForClass:[self class]] bundleIdentifier]];
         
         showPercentage = [[preferences objectForKey:@"showpercentage"] boolValue];
         
         NSString *positionString = [preferences objectForKey:@"percentageposition"];
         
         if (showPercentage) {
         if ([positionString isEqualToString:@"right"]) {
         position = PositionRight;
         }
         else {
         position = PositionLeft;
         }
         }
         
         [self batteryChanged:nil];
         
         CGFloat x = 0;
         if (position == PositionRight) {
         x = 25;
         }
         
         percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, [self frame].size.width - 23, [self frame].size.height)];
         [percentageLabel setBackgroundColor:[UIColor clearColor]];
         [percentageLabel setTextColor:[UIColor whiteColor]];
         [percentageLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
         
         switch (position) {
         case PositionLeft:
         [percentageLabel setTextAlignment:UITextAlignmentRight];
         break;
         case PositionRight:
         [percentageLabel setTextAlignment:UITextAlignmentLeft];
         break;
         }
         
         NSString *progressString = [NSString stringWithFormat:@"%.0f", progress * 100];
         progressString = [progressString stringByAppendingString:@"%"];
         [percentageLabel setText:progressString];
         if (showPercentage) {
         [self addSubview:percentageLabel];
         }
         
         [self setNeedsDisplay];*/
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    /*NSString *progressString = [NSString stringWithFormat:@"%.0f", progress * 100];
     progressString = [progressString stringByAppendingString:@"%"];
     [percentageLabel setText:progressString];
     CGFloat width = [progressString sizeWithFont:[percentageLabel font]].width;
     CGRect rect = [percentageLabel frame];
     rect.size.width = width;
     [percentageLabel setFrame:rect];
     
     CGFloat x = 0;
     if (showPercentage && position == PositionLeft) {
     x = [self frame].size.width - 21;
     }
     
     if (showPercentage) {
     CGRect rect2 = rect;
     rect2.size.width += 25;
     if (rect2.size.width != [[self superview] frame].size.width) {
     //[[self superview] setFrame:rect2];
     [self setFrame:rect2];
     [[objc_getClass("MTIconLayoutView") sharedInstance] reorderAllIcons];
     }
     }*/
    
    if (isCharged) {
        [chargedImage drawInRect:CGRectMake(0, 0, 21, 20)];
        return;
    }
    
    if (isCharging) {
        [chargingImage drawInRect:CGRectMake(0, 0, 21, 20)];
        return;
    }
    
    [drainingBackground drawInRect:CGRectMake(0, 0, 21, 20)];
    
    if (progress < 0) {
        progress = 0.05;
    }
    
    if (progress > 0.3) {
        [drainingInsidesImage drawAsPatternInRect:CGRectMake(2, 0, progress * 15, 20)];
    }
    else {
        [drainingInsidesLowImage drawAsPatternInRect:CGRectMake(2, 0, progress * 15, 20)];
    }
}

- (void)setIsCharged:(BOOL)charged {
	isCharged = charged;
	isCharging = NO;
	[self setNeedsDisplay];
}

- (void)setIsCharging:(BOOL)charging {
	isCharging = charging;
	isCharged = NO;
	[self setNeedsDisplay];
}

- (void)setProgress:(CGFloat)prog {
	progress = prog / 100;
	isCharged = NO;
	isCharging = NO;
	[self setNeedsDisplay];
}

- (void)batteryChanged:(NSNotification *)notif {
	if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateFull) {
		[self setIsCharged:YES];
	}
	else if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging) {
		[self setIsCharging:YES];
	}
	else {
		[self setProgress:(CGFloat)[(SBUIController *)[objc_getClass("SBUIController") sharedInstance] batteryCapacityAsPercentage]];
	}
	
	[self setNeedsDisplay];
}

@end
