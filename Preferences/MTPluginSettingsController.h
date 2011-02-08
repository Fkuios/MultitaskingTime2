//
//  MTPluginSettingsController.h
//  Preferences
//
//  Created by Alistair Geesing on 22-01-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MTPluginSettingsController : PSListController {
	NSString *path;
	NSBundle *bundle;
}

- (NSArray *)loadSpecifiersFromDictionary:(NSDictionary *)dictionary inBundle:(NSBundle *)b target:(id)target;
- (NSArray *)loadSpecifiersFromPlistName:(NSString*)plistName inBundle:(NSBundle *)b target:(id)target;

@end
