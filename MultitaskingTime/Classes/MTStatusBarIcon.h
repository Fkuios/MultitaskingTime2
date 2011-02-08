//
//  StatusBarIcon.h
//  MultitaskingTime
//
//  Created by Fkuios on 9/20/10.
//  Copyright 2010 Fkuios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define MTBasePath              @"/var/mobile/Library/MultitaskingTime/"
#define MTPreferencesFileOld	[MTBasePath stringByAppendingPathComponent:@"Preferences.plist"]

#ifdef MTIdentifier
#define MTPreferencesFile       [NSString stringWithFormat:@"/var/mobile/Library/Preferences/com.fkuios.multitaskingtime.%@.plist", MTIdentifier]
#else
#define MTPreferencesFile		@"/var/mobile/Library/Preferences/com.fkuios.multitaskingtime.plist"
#endif

#define MTPluginPreferenceFile(identifier) [NSString stringWithFormat:@"/var/mobile/Library/Preferences/com.fkuios.multitaskingtime.%@.plist", identifier]

#define MTPluginsPathOld        [MTBasePath stringByAppendingPathComponent:@"Plugins"]
#define MTPluginsBasePath       @"/Library/MultitaskingTime/"
#define MTIconsPath             [MTPluginsBasePath stringByAppendingPathComponent:@"Icons/"]

typedef enum {
	MTSBIconPositionLeft,
	MTSBIconPositionCenter,
	MTSBIconPositionRight
} MTSBIconPosition;

@protocol MTStatusBarIcon <NSObject>

+ (BOOL)conformsToProtocol:(Protocol *)protocol;

+ (id)alloc;

+ (MTSBIconPosition)position;
- (id)init;
- (UIView *)view;
- (void)didHideView;
- (void)didShowView;

@end