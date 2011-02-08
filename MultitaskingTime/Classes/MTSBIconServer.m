//
//  MTSBIconServer.m
//  MultitaskingTime
//
//  Created by Fkuios on 9/20/10.
//  Copyright 2010 Fkuios. All rights reserved.
//

#import "MTSBIconServer.h"
#import "MTIconLayoutView.h"

static MTSBIconServer *sharedInstance = nil;

static inline MTSBIconPosition MTPositionFromString(NSString *string) {
	if ([string isEqualToString:@"left"]) {
		return MTSBIconPositionLeft;
	}
	else if ([string isEqualToString:@"center"]) {
		return MTSBIconPositionCenter;
	}
	
	return MTSBIconPositionRight;
}

@implementation MTSBIconServer

@synthesize visible;
@synthesize layoutView;

+ (MTSBIconServer *)sharedInstance {
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [[MTSBIconServer alloc] init];
        }
    }
    
	return sharedInstance;
}

- (id)init {
    if ((self = [super init])) {
        pluginBundles = [[NSMutableArray alloc] init];
        plugins = [[NSMutableArray alloc] init];     
    }
    
    return self;
}

- (NSArray *)plugins {
	return plugins;
}

- (void)loadPlugins {	
	/*NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
	NSString *pluginDir = MTIconsPath;
	NSArray *contents = [fileManager contentsOfDirectoryAtPath:pluginDir error:NULL];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:MTPreferencesFile];
	NSDictionary *dictPlugins = [dict objectForKey:@"plugins"];
    
    NSMutableArray *icons = [[NSMutableArray alloc] init];
    
    NSArray *iconOrder = [dict objectForKey:@"iconorder"];
    if (iconOrder) {
        NSMutableArray *unsortedIcons = [[NSMutableArray alloc] init];
        for (NSString *file in contents) {
            if ([[file pathExtension] isEqualToString:@"bundle"]) {
                [icons addObject:@""];
                [unsortedIcons addObject:file];
            }
        }
        
        for (int fileIndex = 0; fileIndex < [unsortedIcons count]; fileIndex++) {
            NSString *file = [unsortedIcons objectAtIndex:fileIndex];
            NSBundle *bundle = [NSBundle bundleWithPath:[MTIconsPath stringByAppendingPathComponent:file]];
            NSString *identifier = [bundle bundleIdentifier];
            
            for (int i = 0; i < [iconOrder count]; i++) {
                NSString *iconID = [iconOrder objectAtIndex:i];
                if ([identifier isEqualToString:iconID]) {
                    [icons insertObject:file atIndex:i];
                    [unsortedIcons removeObject:file];
                }
            }
        }
        
        [icons addObjectsFromArray:unsortedIcons];
        
        NSMutableArray *iconsToRemove = [[NSMutableArray alloc] init];
        for (NSString *file in icons) {
            if ([file isEqualToString:@""]) {
                [iconsToRemove addObject:file];
            }
        }
        
        [icons removeObjectsInArray:iconsToRemove];
        [iconsToRemove release];
        [unsortedIcons release];
    }
    else {
        for (NSString *file in contents) {
            if ([[file pathExtension] isEqualToString:@"bundle"]) {
                [icons addObject:file];
            }
        }
    }
    
    for (NSString *icon in icons) {
        NSString *fullPath = [pluginDir stringByAppendingPathComponent:icon];
        NSBundle *plugin = [NSBundle bundleWithPath:fullPath];
        NSDictionary *bundleDict = [dictPlugins objectForKey:[plugin bundleIdentifier]];
        NSString *string = [bundleDict objectForKey:@"enabled"];
        BOOL enabled = [string boolValue];
        if (!string || [string isEqualToString:@""]) {
            enabled = YES;
        }
        
        if (enabled) {
            [pluginBundles addObject:plugin];
        }
    }
	
	NSDictionary *preferences = [[NSDictionary alloc] initWithContentsOfFile:MTPreferencesFile];
	NSDictionary *preferencesPlugins = [[NSDictionary alloc] initWithDictionary:[preferences objectForKey:@"plugins"]];
	
	for (NSBundle *bundle in pluginBundles) {
		[bundle load];
		Class <MTStatusBarIcon> principalClass = [bundle principalClass];
		if ([principalClass conformsToProtocol:@protocol(MTStatusBarIcon)]) {
			MTSBIconPosition position = [principalClass position];
			
			NSDictionary *currentPreferences = [[NSDictionary alloc] initWithDictionary:[preferencesPlugins objectForKey:[bundle bundleIdentifier]]];
			
			NSString *positionString = [[currentPreferences objectForKey:@"position"] lowercaseString];
			
			if (positionString && ![positionString isEqualToString:@""]) {
				if ([positionString isEqualToString:@"left"]) {
					position = MTSBIconPositionLeft;
				}
				else if ([positionString isEqualToString:@"center"]) {
					position = MTSBIconPositionCenter;
				}
				else {
					position = MTSBIconPositionRight;
				}
			}
			
			[currentPreferences release];
			
			NSObject <MTStatusBarIcon> *plugin = [[principalClass alloc] init];
            [plugin didHideView];
			[plugins addObject:plugin];
            [layoutView addView:[plugin view] withPosition:position];
			[plugin release];
		}
	}
    
    [preferences release];
    [preferencesPlugins release];*/
	
	NSFileManager *fileManager = [NSFileManager new];
	
	NSMutableArray *files = [[fileManager contentsOfDirectoryAtPath:MTIconsPath error:NULL] mutableCopy];
	
	NSMutableArray *filesToRemove = [NSMutableArray array];
	for (NSString *file in files) {
		if (![[file pathExtension] isEqualToString:@"bundle"]) {
			[filesToRemove addObject:file];
		}
	}
	[files removeObjectsInArray:filesToRemove];
	[filesToRemove removeAllObjects];
	
	for (NSString *file in files) {
		NSBundle *bundle = [NSBundle bundleWithPath:[MTIconsPath stringByAppendingPathComponent:file]];
		
		BOOL enabled = YES;
		
		NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:MTPluginPreferenceFile([bundle objectForInfoDictionaryKey:@"MTIdentifier"])];
		
		if (!preferences) {
			preferences = [NSDictionary dictionary];
		}
		
		if ([[preferences allKeys] containsObject:@"enabled"]) {
			enabled = [[preferences objectForKey:@"enabled"] boolValue];
		}
		
		if (!enabled) {
			[filesToRemove addObject:file];
		}
	}
	[files removeObjectsInArray:filesToRemove];
	[filesToRemove removeAllObjects];
	
	for (NSString *file in files) {
		NSBundle *bundle = [NSBundle bundleWithPath:[MTIconsPath stringByAppendingPathComponent:file]];
		
		[bundle load];
		
		Class principalClass = [bundle principalClass];
		
		if ([principalClass conformsToProtocol:@protocol(MTStatusBarIcon)]) {
			NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:MTPluginPreferenceFile([bundle objectForInfoDictionaryKey:@"MTIdentifier"])];
			
			MTSBIconPosition position = MTSBIconPositionLeft;
			
			if ([[preferences allKeys] containsObject:@"position"]) {
				position = MTPositionFromString([preferences objectForKey:@"position"]);
			}
			else {
				position = MTPositionFromString([bundle objectForInfoDictionaryKey:@"MTDefaultPosition"]);
			}
			
			NSObject <MTStatusBarIcon> *plugin = [[principalClass alloc] init];
            [plugin didHideView];
			[plugins addObject:plugin];
            [layoutView addView:[plugin view] withPosition:position];
			[plugin release];
		}
	}
	
	[fileManager release];
}

/*- (NSDictionary *)preferencesForBundleID:(NSString *)bundleID {
    NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:MTPreferencesFile];
    NSDictionary *preferencesPlugins = [preferences objectForKey:@"plugins"];
    
    return [[[preferencesPlugins objectForKey:bundleID] copy] autorelease];
}*/

- (void)setVisible:(BOOL)v {
	if (!v) {
		for (NSObject <MTStatusBarIcon> *plugin in plugins) {
			[plugin didHideView];
		}
	}
	else {
		for (NSObject <MTStatusBarIcon> *plugin in plugins) {
			[plugin didShowView];
		}
	}
}

- (void)reorderAllIcons {
    [layoutView reorderAllIcons];
}

- (void)dealloc {
	[pluginBundles release];
	[plugins release];
	
	[super dealloc];
}

@end