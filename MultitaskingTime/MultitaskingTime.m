#import "MTSBIconServer.h"
#import "MTIconLayoutView.h"
#import <QuartzCore/QuartzCore.h>

static BOOL isNot42 = NO;
static MTIconLayoutView *layoutView = nil;
static UIImageView *shadowView = nil;
static BOOL didOffsetRotationLockButton = NO;

CHDeclareClass(SBAppSwitcherBarView);
CHDeclareClass(SBAppSwitcherController);
CHDeclareClass(SBApplicationIcon);
CHDeclareClass(SBNowPlayingBarMediaControlsView);

CHClassMethod(1, CGSize, SBAppSwitcherBarView, viewSize, int, unknown) {
	CGSize orig = CHSuper(1, SBAppSwitcherBarView, viewSize, unknown);
	orig.height += kMTAdditionalHeight;
	return orig;
}

CHMethod(1, id, SBAppSwitcherBarView, initWithFrame, CGRect, frame) {
	if (isNot42) {
		frame.size.height += kMTAdditionalHeight;
	}
	
	self = CHSuper(1, SBAppSwitcherBarView, initWithFrame, frame);
	
	layoutView = [[MTIconLayoutView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, kMTBarHeight)];
	[[MTSBIconServer sharedInstance] setLayoutView:layoutView];
	[[[self subviews] objectAtIndex:0] addSubview:layoutView];
	
	[layoutView release];
	
	[[MTSBIconServer sharedInstance] loadPlugins];
	[[MTSBIconServer sharedInstance] setVisible:NO];
	
	UIImageView *_topShadowView = CHIvar(self, _topShadowView, UIImageView *);
	UIImage *image = [_topShadowView image];
	
	shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kMTBarHeight, frame.size.width, image.size.height)];
	[shadowView setImage:image];
	[[[self subviews] objectAtIndex:0] addSubview:shadowView];
	
	[shadowView release];
	
	[_topShadowView removeFromSuperview];
	
	return self;
}

CHMethod(1, id, SBAppSwitcherBarView, initWithOrientation, int, orientation) {
	self = CHSuper(1, SBAppSwitcherBarView, initWithOrientation, orientation);
	
	NSLog(@"%@", [self recursiveDescription]);
	
	return self;
}

CHMethod(1, void, SBAppSwitcherBarView, setFrame, CGRect, frame) {
	if (isNot42) {
		frame.size.height += kMTAdditionalHeight;
	}
	
	CHSuper(1, SBAppSwitcherBarView, setFrame, frame);
	
	[layoutView setFrame:CGRectMake(0, 0, frame.size.width, kMTBarHeight)];
	[layoutView reorderAllIcons];
}

CHMethod(0, void, SBAppSwitcherBarView, layoutSubviews) {
	CHSuper(0, SBAppSwitcherBarView, layoutSubviews);
	
	for (UIView *scrollView in [[[self subviews] objectAtIndex:0] subviews]) {
		if ([scrollView isKindOfClass:objc_getClass("SBAppSwitcherScrollView")]) {
			for (UIView *subview in [scrollView subviews]) {
				if ([subview isKindOfClass:objc_getClass("SBNowPlayingBarView")] && !didOffsetRotationLockButton) {
					UIButton *lockButton = [(SBNowPlayingBarView *)subview orientationLockButton];
					
					UIView *superview = [lockButton superview];
					
					CGFloat addition = ceil(kMTAdditionalHeight / 2) + 1;
					
					CGRect frame = [lockButton frame];
					frame.origin.y += addition;
					[lockButton setFrame:frame];
					
					UIView *shadow = [[superview subviews] objectAtIndex:0];
					CGRect shadowFrame = [shadow frame];
					shadowFrame.origin.y += addition - 1;
					[shadow setFrame:shadowFrame];
					
					[superview setFrame:frame];
					
					didOffsetRotationLockButton = YES;
				}
				
				if (![subview isKindOfClass:objc_getClass("SBApplicationIcon")]) {
					CGRect frame = [subview frame];
					frame.origin.y += ceil(kMTAdditionalHeight / 2) - 1;
					[subview setFrame:frame];
				}
			}
		}
	}
	
	CGRect shadowFrame = [shadowView frame];
	shadowFrame.size.width = [self frame].size.width;
	[shadowView setFrame:shadowFrame];
	
	[layoutView setFrame:CGRectMake(0, 0, [self frame].size.width, kMTBarHeight)];
	[layoutView reorderAllIcons];
}

/*CHMethod(3, void, SBAppSwitcherBarView, _iconRemoveDidStop, id, unknown, finished, id, unknown2, context, id, context) {
	NSLog(@"_iconRemoveDidStopContext: %@", context);
	CHSuper(3, SBAppSwitcherBarView, _iconRemoveDidStop, unknown, finished, unknown2, context, context);
}*/

CHMethod(0, void, SBAppSwitcherController, viewWillAppear) {
	CHSuper(0, SBAppSwitcherController, viewWillAppear);
	
	NSLog(@"%@", [CHIvar(self, _bottomBar, SBAppSwitcherBarView *) recursiveDescription]);
	
	[[MTSBIconServer sharedInstance] setVisible:YES];
}

CHMethod(0, void, SBAppSwitcherController, viewDidDisappear) {
	CHSuper(0, SBAppSwitcherController, viewDidDisappear);
	
	[[MTSBIconServer sharedInstance] setVisible:NO];
}

/*CHMethod(2, void, CALayer, addAnimation, CAKeyframeAnimation *, animation, forKey, id, key) {*/
	/*if ([[self delegate] isKindOfClass:objc_getClass("SBApplicationIcon")] && [animation isKindOfClass:[CAKeyframeAnimation class]]) {
		NSMutableArray *values = [NSMutableArray array];
		for (NSValue *value in [animation values]) {
			CGPoint point;
			[value getValue:&point];
			point.y = ceil(kMTAdditionalHeight / 2) - 1;
			[values addObject:NSStringFromCGPoint(point)];
		}
		NSLog(@"values: %@", values);
		[animation setValues:values];
	}*/
	
	/*CHSuper(2, CALayer, addAnimation, animation, forKey, key);
}*/

CHMethod(1, void, SBApplicationIcon, setFrame, CGRect, frame) {
	if ([[self superview] isKindOfClass:objc_getClass("SBAppSwitcherScrollView")]) {
		frame.origin.y += ceil(kMTAdditionalHeight / 2) - 1;
	}
	
	CHSuper(1, SBApplicationIcon, setFrame, frame);
}

CHMethod(0, void, SBNowPlayingBarMediaControlsView, layoutSubviews) {
	CHSuper(0, SBNowPlayingBarMediaControlsView, layoutSubviews);
	
	for (SBIconLabel *iconLabel in [self subviews]) {
		if ([iconLabel isKindOfClass:objc_getClass("SBIconLabel")]) {
			CGRect f = [iconLabel frame];
			f.origin.y -= ceil(kMTAdditionalHeight / 2) + 1;
			[iconLabel setFrame:f];
		}
	}
}

CHConstructor {
	NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
	
	NSArray *components = [systemVersion componentsSeparatedByString:@"."];
	NSInteger majorVersion = [[components objectAtIndex:0] integerValue];
	NSInteger minorVersion = [[components objectAtIndex:1] integerValue];
	NSInteger revisionVersion = 0;
	if ([components count] >= 3) {
		revisionVersion = [[components objectAtIndex:2] integerValue];
	}
	
	isNot42 = (majorVersion == 4 && minorVersion < 2);
	
	if ((majorVersion == 4 && minorVersion >= 2) || (majorVersion > 4)) {
		BOOL enabled = YES;
		NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:MTPreferencesFile];
		
		if (preferences && [[preferences allKeys] containsObject:@"enabled"]) {
			enabled = [[preferences objectForKey:@"enabled"] boolValue];
		}
		
		if (enabled) {
			(void)CHLoadLateClass(SBAppSwitcherBarView);
			(void)CHLoadLateClass(SBAppSwitcherController);
			(void)CHLoadLateClass(SBApplicationIcon);
			(void)CHLoadLateClass(SBNowPlayingBarMediaControlsView);
			
			CHClassHook(1, SBAppSwitcherBarView, viewSize);
			CHHook(1, SBAppSwitcherBarView, initWithFrame);
			CHHook(0, SBAppSwitcherBarView, layoutSubviews);
			
			CHHook(0, SBAppSwitcherController, viewWillAppear);
			CHHook(0, SBAppSwitcherController, viewDidDisappear);
			
			CHHook(1, SBApplicationIcon, setFrame);
			
			CHHook(0, SBNowPlayingBarMediaControlsView, layoutSubviews);
		}
	}
}