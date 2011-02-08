//
//  FKBattery.h
//  MultitaskingTime
//
//  Created by Alistair Geesing on 9/22/10.
//  Copyright 2010 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FKBatteryView.h"

typedef enum {
	PositionLeft,
	PositionRight
} Position;

@interface FKBattery : NSObject <MTStatusBarIcon> {
    BOOL showPercentage;
    Position position;
    
    UIView *containerView;
	FKBatteryView *batteryView;
    UILabel *percentageLabel;
    
    NSInteger progress;
	BOOL isCharged;
	BOOL isCharging;
}

@property (nonatomic) NSInteger progress;
@property (nonatomic) BOOL isCharged;
@property (nonatomic) BOOL isCharging;
@property (nonatomic) BOOL isVisible;

- (NSString *)currentBatteryPercentageString;
- (void)batteryChanged:(NSNotification *)notif;
- (void)layoutContainerView;

@end
