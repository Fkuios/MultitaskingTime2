//
//  FKLabelUpdater.h
//  MultitaskingTime
//
//  Created by Alistair Geesing on 9/19/10.
//  Copyright 2010 None. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FKLabelUpdater : NSObject {
	UILabel *label;
	NSTimer *timer;
	NSDateFormatter *dateFormatter;
	
	BOOL isUpdating;
}

+ (id)sharedInstance;
- (void)updateTimeForLabel:(UILabel *)l;
- (void)_update;
- (void)startUpdating;
- (void)stopUpdating;

@end