//
//  FKWiFiStrengthView.h
//  MultitaskingTime
//
//  Created by Alistair Geesing on 9/19/10.
//  Copyright 2010 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTStatusBarIcon.h"

typedef enum {
	PositionLeft,
	PositionRight
} Position;

@interface FKWiFiStrengthView : UIView {
	void *libHandle;
	void *airportHandle;    
	int (*apple80211Open)(void *);
	int (*apple80211Bind)(void *, NSString *);
	int (*apple80211GetInfoCopy)(void *, NSDictionary **);
	int (*apple80211Close)(void *);
	
	NSDictionary *wifiInfo;
	NSTimer *updateTimer;
	
	UIImage *bars3;
	UIImage *bars2;
	UIImage *bars1;
	UIImage *bars0;
	UIImage *currentImage;
	
	//UILabel *ssidLabel;
	
	BOOL isUpdating;
	//BOOL showSSID;
	//Position ssidPosition;
}

- (id)init;
- (void)updateInfo;
- (void)startUpdating;
- (void)stopUpdating;

@end
