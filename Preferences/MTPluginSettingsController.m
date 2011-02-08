//
//  MTPluginSettingsController.m
//  Preferences
//
//  Created by Alistair Geesing on 22-01-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MTPluginSettingsController.h"

NSArray *SpecifiersFromPlist(NSDictionary* plist,
										PSSpecifier* prevSpec,
										id target,
										NSString* plistName,
										NSBundle* curBundle,
										NSString** pTitle,
										NSString** pSpecifierID,
										PSListController* callerList,
										NSMutableArray** pBundleControllers);

@implementation MTPluginSettingsController

- (void)setSpecifier:(PSSpecifier *)specifier {
	path = [[specifier propertyForKey:@"bundlePath"] retain];
	bundle = [[NSBundle bundleWithPath:path] retain];
	
	[super setSpecifier:specifier];
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		NSMutableArray *specs = [NSMutableArray new];
		
		NSString *plist = [NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"PluginTemplate" ofType:@"plist"] encoding:NSUTF8StringEncoding error:NULL];
		
		plist = [plist stringByReplacingOccurrencesOfString:@"%identifier%" withString:[bundle objectForInfoDictionaryKey:@"MTIdentifier"]];
		plist = [plist stringByReplacingOccurrencesOfString:@"%defaultposition%" withString:[bundle objectForInfoDictionaryKey:@"MTDefaultPosition"]];
		
		
		NSMutableDictionary *dict = [NSPropertyListSerialization propertyListFromData:[plist dataUsingEncoding:NSUTF8StringEncoding] mutabilityOption:0 format:NULL errorDescription:NULL];
		
		[specs addObjectsFromArray:[self loadSpecifiersFromDictionary:dict inBundle:[NSBundle bundleForClass:[self class]] target:self]];
		
		[specs addObjectsFromArray:[self loadSpecifiersFromPlistName:[bundle objectForInfoDictionaryKey:@"MTPreferencesFile"] inBundle:bundle target:self]];
		
		_specifiers = specs;
	}
	
	return _specifiers;
}

- (NSArray *)loadSpecifiersFromDictionary:(NSDictionary *)dictionary inBundle:(NSBundle *)b target:(id)target {
	return SpecifiersFromPlist(dictionary, nil, self, nil, b, NULL, NULL, self, NULL);
}

- (NSArray *)loadSpecifiersFromPlistName:(NSString*)plistName inBundle:(NSBundle *)b target:(id)target {
	NSDictionary* plist = [[NSDictionary alloc] initWithContentsOfFile:[b pathForResource:plistName ofType:@"plist"]];
	return [self loadSpecifiersFromDictionary:plist inBundle:b target:target];
}

@end
