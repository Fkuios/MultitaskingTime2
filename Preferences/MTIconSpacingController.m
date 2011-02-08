//
//  MTIconSpacingController.m
//  Preferences
//
//  Created by Alistair Geesing on 22-01-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MTIconSpacingController.h"
#import "MTSettingsController.h"


@implementation MTIconSpacingController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"IconSpacing" target:self] retain];
	}
	
	return _specifiers;
}

@end
