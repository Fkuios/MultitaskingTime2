//
//  FKBatteryView.h
//  BatteryIcon
//
//  Created by Alistair Geesing on 9/18/10.
//  Copyright 2010 None. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKBatteryView : UIView {
	UIImage *chargedImage;
	UIImage *chargingImage;
	UIImage *drainingBackground;
	UIImage *drainingInsidesImage;
	UIImage *drainingInsidesLowImage;
	
	CGFloat progress;
	BOOL isCharged;
	BOOL isCharging;
}

@property (nonatomic) CGFloat progress;
@property (nonatomic) BOOL isCharged;
@property (nonatomic) BOOL isCharging;
@property (nonatomic) BOOL isVisible;

- (void)batteryChanged:(NSNotification *)notif;

@end
