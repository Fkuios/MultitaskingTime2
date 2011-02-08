//
//  FKTime.h
//  MultitaskingTime
//
//  Created by Alistair Geesing on 9/22/10.
//  Copyright 2010 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FKLabelUpdater.h"

#define LabelFont	[UIFont boldSystemFontOfSize:15.0]

@interface FKTime : NSObject <MTStatusBarIcon> {
    UILabel *timeLabel;
	FKLabelUpdater *updater;
}

@end
