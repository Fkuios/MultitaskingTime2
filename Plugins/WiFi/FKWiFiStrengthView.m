//
//  FKWiFiStrengthView.m
//  MultitaskingTime
//
//  Created by Alistair Geesing on 9/19/10.
//  Copyright 2010 None. All rights reserved.
//

#import "FKWiFiStrengthView.h"
#import <dlfcn.h>

@interface UIImage (KitImage)

+ (UIImage *)kitImageNamed:(NSString *)name;

@end


@implementation FKWiFiStrengthView

const CGFloat width = 20;
const CGFloat height = 20;

- (id)initWithFrame:(CGRect)frame {
	if ((self = [self init])) {
		[self setFrame:frame];
		
		/*NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:MTPreferencesFile];
		NSDictionary *dictionaryPlugins = [dictionary objectForKey:@"plugins"];
		NSDictionary *preferences = [dictionaryPlugins objectForKey:@"WiFi.bundle"];*/
		/*showSSID = [[preferences objectForKey:@"showssid"] boolValue];
		NSString *positionString = [preferences objectForKey:@"ssidposition"];
		
		CGFloat x = 0;
		if (showSSID) {
			if ([positionString isEqualToString:@"right"]) {
				ssidPosition = PositionRight;
				x = 23;
			}
			else {
				ssidPosition = PositionLeft;
				x = [self frame].size.width - batteryWidth - 5 - labelWidth;
			}
		}*/
		
		/*ssidLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, -1, labelWidth, [self frame].size.height)];
		[ssidLabel setBackgroundColor:[UIColor clearColor]];
		[ssidLabel setTextColor:[UIColor whiteColor]];
		[ssidLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
		
		if (showSSID) {
			switch (ssidPosition) {
				case PositionLeft:
					[ssidLabel setTextPosition:UITextPositionRight];
					break;
				case PositionRight:
					[ssidLabel setTextPosition:UITextPositionLeft];
					break;
			}
		}
		
		if (showSSID) {
			//[self addSubview:ssidLabel];
		}*/
	}
	
	return self;
}

- (id)init {
    if ((self = [super initWithFrame:CGRectMake(0, 0, width, height)])) {
		const char *path = "/System/Library/SystemConfiguration/WiFiManager.bundle/WiFiManager";
		
		FILE *fp = fopen(path, "r");
		if (!fp) {
			//[self dealloc];
			[super dealloc];
			return nil;
		}
		fclose(fp);
		
		libHandle = dlopen(path, RTLD_LAZY);
		
		apple80211Open = dlsym(libHandle, "Apple80211Open");
		apple80211Bind = dlsym(libHandle, "Apple80211BindToInterface");
		apple80211GetInfoCopy = dlsym(libHandle, "Apple80211GetInfoCopy");
		apple80211Close = dlsym(libHandle, "Apple80211Close");
		
		apple80211Open(&airportHandle);
		apple80211Bind(airportHandle, @"en0");
		
		[self setBackgroundColor:[UIColor clearColor]];
		
		bars3 = [UIImage kitImageNamed:@"Black_3_WifiBars.png"];
		bars2 = [UIImage kitImageNamed:@"Black_2_WifiBars.png"];
		bars1 = [UIImage kitImageNamed:@"Black_1_WifiBars.png"];
		bars0 = [UIImage kitImageNamed:@"Black_0_WifiBars.png"];
    }
    return self;
}

- (void)stopUpdating {
	if (isUpdating) {
		[updateTimer invalidate];
		isUpdating = NO;
	}
}

- (void)startUpdating {
	if (!isUpdating) {
		[self updateInfo];
		updateTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
		[[NSRunLoop mainRunLoop] addTimer:updateTimer forMode:NSDefaultRunLoopMode];
		isUpdating = YES;
	}
}

- (void)updateInfo {
	apple80211GetInfoCopy(airportHandle, &wifiInfo);
	
	NSString *rssi = [NSString stringWithFormat:@"%@", [(NSDictionary *)[wifiInfo valueForKey:@"RSSI"] valueForKey:@"RSSI_CTL_AGR"]];
	NSInteger strength = [rssi integerValue];
	UIImage *oldImage = currentImage;
	if (strength > -70) {
		currentImage = bars3;
	}
	else if (strength > -85) {
		currentImage = bars2;
	}
	else if (strength > -100) {
		currentImage = bars1;
	}
	else {
		currentImage = bars0;
	}
	
	if ([(NSNumber *)[[wifiInfo valueForKey:@"POWER"] objectAtIndex:0] integerValue] == 0) {
		currentImage = nil;
	}
	
	if ([(NSNumber *)[wifiInfo valueForKey:@"STATE"] integerValue] != 4) {
		currentImage = nil;
	}
	
	BOOL needsDisplay = NO;
	
	if (oldImage != currentImage) {
		needsDisplay = YES;
	}
    
    if (!currentImage) {
        CGRect rect = [self frame];
        if (rect.size.width != 0) {
            rect.size.width = 0;
            [self setFrame:rect];
            [[objc_getClass("MTSBIconServer") sharedInstance] reorderAllIcons];
        }
    }
    else {
        CGRect rect = [self frame];
        rect.size.width = width;
        [self setFrame:rect];
        [[objc_getClass("MTSBIconServer") sharedInstance] reorderAllIcons];
    }
	
	/*NSString *ssid = [wifiInfo valueForKey:@"SSID_STR"];
	[ssidLabel setText:ssid];
	CGSize size = [ssid sizeWithFont:[ssidLabel font]];
	//[[objc_getClass("MTSBIconServer") sharedInstance] loadPlugins];*/
	
	if (needsDisplay) {
		[self setNeedsDisplay];
	}
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	/*CGSize size = [[ssidLabel text] sizeWithFont:[ssidLabel font]];
	CGFloat x = size.width - 5 - batteryWidth;
	if (showSSID && ssidPosition == PositionLeft) {
		x = [self frame].size.width - batteryWidth;
	}*/
	[currentImage drawAtPoint:CGPointMake(0, 0)];
}

- (void)dealloc {
	apple80211Close(&airportHandle);
	dlclose(&libHandle);
    [super dealloc];
}


@end
