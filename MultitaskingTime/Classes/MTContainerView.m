//
//  MTContainerView.m
//  MultitaskingTime
//
//  Created by Alistair Geesing on 18-01-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MTContainerView.h"
#import "MTSBIconServer.h"

//#define MTDEBUG

#ifdef MTDEBUG
@implementation NSInvocation (BetterDescription)

- (NSString *)description {
	NSMutableArray *arguments = [NSMutableArray array];
	
	for (int i = 0; i < [[self methodSignature] numberOfArguments]; i++) {
		const char *type = [[self methodSignature] getArgumentTypeAtIndex:i];
		void *argument;
		[self getArgument:&argument atIndex:i];
		if (type == "c" || type == "C") {
			char *c = argument;
			[arguments addObject:[NSNumber numberWithChar:*c]];
		}
		else if (type == "s" || type == "S") {
			short *s = argument;
			[arguments addObject:[NSNumber numberWithShort:*s]];
		}
		else if (type == "i" || type == "I") {
			int *integer = argument;
			[arguments addObject:[NSNumber numberWithInt:*integer]];
		}
		else if (type == "l" || type == "L") {
			long *l = argument;
			[arguments addObject:[NSNumber numberWithLong:*l]];
		}
		else if (type == "q" || type == "Q") {
			long long *q = argument;
			[arguments addObject:[NSNumber numberWithLongLong:*q]];
		}
		else if (type == "f") {
			float *f = argument;
			[arguments addObject:[NSNumber numberWithFloat:*f]];
		}
		else if (type == "d") {
			double *d = argument;
			[arguments addObject:[NSNumber numberWithDouble:*d]];
		}
		else if (type == "v" || type == ":" || type == "*" || type == "?") {
			[arguments addObject:[NSValue value:argument withObjCType:type]];
		}
		else if (type == "@" || type == "#") {
			[arguments addObject:argument];
		}
	}
	
	return [NSString stringWithFormat:@"<%@: %p; target: %@ (%p); selector: %@ (%p); arguments: %@>", [self class], self, [[self target] class], [self target], NSStringFromSelector([self selector]), [self selector], arguments];
}

@end
#endif

@implementation MTContainerView

@synthesize barView;
@synthesize linenView;
@synthesize iconView;
@synthesize topShadowImage;
@synthesize topShadowView;
@synthesize shouldOffset;
@synthesize animationDuration;

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		linenView = [[objc_getClass("SBLinenView") alloc] initWithFrame:CGRectZero];
		[linenView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin)];
		[self addSubview:linenView];
		
		iconView = [[UIView alloc] initWithFrame:CGRectZero];
		[iconView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin)];
		[self addSubview:iconView];
		
		topShadowView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[iconView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin)];
		[self addSubview:topShadowView];
		
		[self setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin)];
	}
	return self;
}

- (void)dealloc {
	[linenView release];
	[iconView release];
	[topShadowView release];
	[topShadowImage release];
	
	[super dealloc];
}

- (void)setBarView:(SBAppSwitcherBarView *)b {
	[barView removeFromSuperview];
	
	[linenView removeFromSuperview];
	[iconView removeFromSuperview];
	[topShadowView removeFromSuperview];
	
	
	barView = b;
	CGRect barFrame = [(SBUIController *)[objc_getClass("SBUIController") sharedInstance] _switcherFrameForRotationOrientation:[[UIDevice currentDevice] orientation] inView:self];
	barFrame.origin.x = 0;
	barFrame.origin.y = kMTAdditionalBarHeight;
	[barView setFrame:barFrame];
	//[barView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin/* | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin*/)];
	
	sizeSet = NO;
	[self setFrame:[self frame]];
	
	[self addSubview:barView];
	
	[self addSubview:linenView];
	[self addSubview:iconView];
	[self addSubview:topShadowView];	
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	if ([barView respondsToSelector:aSelector]) {
		return [barView methodSignatureForSelector:aSelector];
	}
	
	return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	//NSLog(@"forwardInvocation:%@", anInvocation);
	if ([super respondsToSelector:[anInvocation selector]] && [anInvocation selector] != @selector(setEditing:) ) {
		//NSLog(@"super");
		[super forwardInvocation:anInvocation];
	}
	else {
		//NSLog(@"barView");
		[anInvocation invokeWithTarget:barView];
	}
}

- (BOOL)respondsToSelector:(SEL)aSelector {
	if (aSelector == @selector(setEditing:)) {
		//NSLog(@"respondsToSelector:%@", NSStringFromSelector(aSelector));
		return NO;
	}
	
	return ([super respondsToSelector:aSelector] || [barView respondsToSelector:aSelector]);
}

- (void)setFrame:(CGRect)frame {
	//frame.size.height += kMTAdditionalBarHeight;
	/*if (animationDuration > 0) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:animationDuration];
	}*/
	
	/*if ([(SBDisplayStack *)SBActiveDisplayStack topApplication] || shouldOffset) {
		frame.origin.y -= kMTAdditionalBarHeight;
		//shouldOffset = NO;
	}*/
	
	if (!sizeSet) {
		CGRect barFrame = CGRectZero;
		barFrame.size.width = frame.size.width;
		barFrame.size.height = [[barView class] viewSize:0].height;
		barFrame.origin.y = kMTAdditionalBarHeight;
		[barView setFrame:barFrame];
		
		[linenView setFrame:CGRectMake(0, 0, frame.size.width, kMTAdditionalBarHeight)];
		
		[iconView setFrame:CGRectMake(0, 0, frame.size.width, kMTAdditionalBarHeight)];
		
		[topShadowView setFrame:CGRectMake(0, kMTAdditionalBarHeight, frame.size.width, [topShadowView image].size.height)];
		
		sizeSet = YES;
	}
	
	[super setFrame:frame];
	
	
	/*CGRect barFrame = CGRectZero;
	barFrame.size.width = frame.size.width;
	barFrame.size.height = [[barView class] viewSize:0].height;
	barFrame.origin.y = kMTAdditionalBarHeight;*/
	
	//[barView setFrame:barFrame];
	
	
	/*[linenView setFrame:CGRectMake(0, 0, frame.size.width, kMTAdditionalBarHeight)];
	
	[iconView setFrame:CGRectMake(0, 0, frame.size.width, kMTAdditionalBarHeight)];*/
	[[MTSBIconServer sharedInstance] reorderAllIcons];
	
	/*[topShadowView setFrame:CGRectMake(0, kMTAdditionalBarHeight, frame.size.width, [topShadowView image].size.height)];*/
	
	/*if (animationDuration > 0) {
		[UIView commitAnimations];
	}*/
}

- (void)setTopShadowImage:(UIImage *)i {
	[topShadowImage release];
	
	topShadowImage = [i retain];
	[topShadowView setImage:topShadowImage];
	
	[topShadowView setFrame:CGRectMake(0, kMTAdditionalBarHeight, [self frame].size.width, [topShadowView image].size.height)];
}

/*- (void)animateRotationWithDuration:(NSTimeInterval)duration {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:duration];
	
	CGRect rect = [self frame];
	rect.origin.y -= kMTAdditionalBarHeight;
	[self setFrame:rect];
	
	[UIView commitAnimations];
}*/

@end
