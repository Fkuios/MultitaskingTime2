//
//  MTSettingsController.m
//  Preferences
//
//  Created by Alistair Geesing on 22-01-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MTSettingsController.h"
#import "MTStatusBarIcon.h"
#import "MTIconSpacingController.h"
#import "MTPluginSettingsController.h"
#import "PSSpecifier+Actions.h"

#define CopyrightText		@"Settings will take effect after respring\n\nCopyright 2011 Fkuios\n "

@implementation MTSettingsController

- (id)initForContentSize:(CGSize)contentSize {
	if ((self = [super initForContentSize:contentSize])) {
		NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
		
		NSArray *components = [systemVersion componentsSeparatedByString:@"."];
		NSInteger majorVersion = [[components objectAtIndex:0] integerValue];
		NSInteger minorVersion = [[components objectAtIndex:1] integerValue];
		NSInteger revisionVersion = 0;
		if ([components count] >= 3) {
			revisionVersion = [[components objectAtIndex:2] integerValue];
		}
		
		if (!((majorVersion == 4 && minorVersion >= 2) || (majorVersion > 4))) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Multitasking Time is only compatible with iOS 4.2 or higher" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
		
		preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:MTPreferencesFile];
		if (!preferences) {
			preferences = [NSMutableDictionary new];
			
			NSData *data = [NSPropertyListSerialization dataFromPropertyList:preferences format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];
			[data writeToFile:MTPreferencesFile atomically:NO];
		}
	}
	
	return self;
}

- (void)dealloc {
	[preferences release];
	
	[super dealloc];
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		NSMutableArray *specs = [[self loadSpecifiersFromPlistName:@"Root" target:self] mutableCopy];
		
		PSSpecifier *groupSpecifier = [PSSpecifier emptyGroupSpecifier];
		[specs addObject:groupSpecifier];
		
		PSSpecifier *donateSpecifier = [PSSpecifier preferenceSpecifierNamed:@"Donate" target:self set:NULL get:NULL detail:Nil cell:PSButtonCell edit:Nil];
		[donateSpecifier setAction:@selector(donate)];
		[specs addObject:donateSpecifier];
		
		
		PSSpecifier *iconsGroupSpecifier = [PSSpecifier emptyGroupSpecifier];
		[iconsGroupSpecifier setProperty:CopyrightText forKey:@"footerText"];
		[specs addObject:iconsGroupSpecifier];
		
		
		NSFileManager *fileManager = [[NSFileManager alloc] init];
		NSArray *contents = [fileManager contentsOfDirectoryAtPath:MTIconsPath error:NULL];
		
		if ([contents count] == 0) {
			[specs removeLastObject];
			
			PSSpecifier *footerSpecifier = [PSSpecifier emptyGroupSpecifier];
			[footerSpecifier setProperty:CopyrightText forKey:@"footerText"];
			[specs addObject:footerSpecifier];
		}
		
		for (NSString *file in contents) {
			if ([[file pathExtension] isEqualToString:@"bundle"]) {
				NSBundle *bundle = [NSBundle bundleWithPath:[MTIconsPath stringByAppendingPathComponent:file]];
				PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:[bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"] target:self set:NULL get:NULL detail:[MTPluginSettingsController class] cell:PSLinkCell edit:Nil];
				
				[specifier setProperty:[MTIconsPath stringByAppendingPathComponent:file] forKey:@"bundlePath"];
				[specs addObject:specifier];
			}
		}
		
		[fileManager release];
		
		
		
		_specifiers = specs;
	}
	
	return _specifiers;
}

- (void)donate {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=AR2L6SX288N86"]];
}

- (void)respring {
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setBackgroundColor:[UIColor blackColor]];
	[window setAlpha:0.0];
	[window setWindowLevel:UIWindowLevelStatusBar];
	[window makeKeyAndVisible];
	
	[UIView animateWithDuration:0.5 animations:^ {
		[window setAlpha:1.0];
	} completion:^(BOOL finished) {
		[window release];
		system("killall SpringBoard");
	}];
}

- (void)resetDefaults {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"This will reset all settings to their defaults and respring your device." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Reset to defaults" otherButtonTitles:nil];
	[actionSheet showInView:[self view]];
	[actionSheet release];
}

- (void)_resetDefaults {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith 'com.fkuios.multitaskingtime.'"];
	
	NSFileManager *fileManager = [NSFileManager new];
	
	NSString *preferencesPath = @"/var/mobile/Library/Preferences/";
	
	NSArray *files = [fileManager contentsOfDirectoryAtPath:preferencesPath error:NULL];
	
	files = [files filteredArrayUsingPredicate:predicate];
	
	for (NSString *file in files) {
		file = [preferencesPath stringByAppendingPathComponent:file];
		[fileManager removeItemAtPath:file error:NULL];
	}
	
	[fileManager release];
	
	[self respring];
}

- (void)actionSheet:(id)sheet clickedButtonAtIndex:(int)index {
	if (index == 0) {
		[self _resetDefaults];
	}
}

@end