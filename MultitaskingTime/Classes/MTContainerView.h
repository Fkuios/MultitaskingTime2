//
//  MTContainerView.h
//  MultitaskingTime
//
//  Created by Alistair Geesing on 18-01-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTContainerView : UIView {
	SBAppSwitcherBarView *barView;
	SBLinenView *linenView;
	UIView *iconView;
	
	BOOL sizeSet;
	
	UIImage *topShadowImage;
	UIImageView *topShadowView;
	
	BOOL shouldOffset;
	double animationDuration;
}

@property (nonatomic, assign) SBAppSwitcherBarView *barView;
@property (readonly) SBLinenView *linenView;
@property (readonly) UIView *iconView;
@property (nonatomic, retain) UIImage *topShadowImage;
@property (readonly) UIImageView *topShadowView;
@property (assign) BOOL shouldOffset;
@property (assign) double animationDuration;

- (void)animateRotationWithDuration:(NSTimeInterval)duration;

@end
