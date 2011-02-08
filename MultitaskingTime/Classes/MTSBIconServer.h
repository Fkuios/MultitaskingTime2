//
//  MTSBIconServer.h
//  MultitaskingTime
//
//  Created by Fkuios on 9/20/10.
//  Copyright 2010 Fkuios. All rights reserved.
//

#import "MTStatusBarIcon.h"
#import "MTIconLayoutView.h"

@interface MTSBIconServer : NSObject {
    MTIconLayoutView *layoutView;
	NSMutableArray *pluginBundles;
	NSMutableArray *plugins;
	BOOL visible;
}

@property (nonatomic, assign) BOOL visible;
@property (nonatomic, retain) MTIconLayoutView *layoutView;

+ (MTSBIconServer *)sharedInstance;
- (id)init;
- (void)loadPlugins;
- (NSArray *)plugins;
- (void)reorderAllIcons;

@end
