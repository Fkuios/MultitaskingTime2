//
//  FKWiFi.h
//  WiFi
//
//  Created by Alistair Geesing on 9/22/10.
//  Copyright 2010 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTStatusBarIcon.h"
#import "FKWiFiStrengthView.h"


@interface FKWiFi : NSObject <MTStatusBarIcon> {
	CGSize size;
    
	FKWiFiStrengthView *strengthView;
}

@end
