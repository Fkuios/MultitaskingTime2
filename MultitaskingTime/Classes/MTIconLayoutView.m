//
//  MTIconLayoutView.m
//  MultitaskingTime
//
//  Created by Fkuios on 10/13/10.
//  Copyright (c) 2010 Fkuios. All rights reserved.
//

#import "MTIconLayoutView.h"

@implementation MTIconLayoutView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		CGRect rect = CGRectBounds(frame);
		leftView = [[UIView alloc] initWithFrame:rect];
		centerView = [[UIView alloc] initWithFrame:rect];
		rightView = [[UIView alloc] initWithFrame:rect];
		[self addSubview:leftView];
		[self addSubview:centerView];
		[self addSubview:rightView];
	}
	
	return self;
}

- (void)addView:(UIView *)view withPosition:(MTSBIconPosition)pos {
	if (pos == MTSBIconPositionCenter) {
		[centerView addSubview:view];
	}
	else if (pos == MTSBIconPositionLeft) {
		[leftView addSubview:view];
	}
	else {
		[rightView addSubview:view];
	}
	
	[self reorderAllIcons];
}

- (void)setFrame:(CGRect)f {
	[super setFrame:f];
	
	CGRect rect = CGRectBounds(f);
	[leftView setFrame:rect];
	[centerView setFrame:rect];
	[rightView setFrame:rect];
}

- (void)reorderAllIcons {
	[self layoutView:leftView withAlignment:MTSBIconPositionLeft];
	[self layoutView:centerView withAlignment:MTSBIconPositionCenter];
	[self layoutView:rightView withAlignment:MTSBIconPositionRight];
}

- (void)layoutView:(UIView *)v withAlignment:(MTSBIconPosition)position {
	NSInteger topMargin = 0;
	NSInteger bottomMargin = 0;
	
	NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:MTPreferencesFile];
	NSNumber *value = [preferences objectForKey:@"spacing"];
	if (![[preferences allKeys] containsObject:@"spacing"]) {
		value = [NSNumber numberWithFloat:5.0];
	}
	NSInteger spacing = [value floatValue];
	NSInteger leftMargin = 5;
	NSInteger rightMargin = 5;
	if (leftMargin < 5) { leftMargin = 5; }
	if (rightMargin < 5) { rightMargin = 5; }
	BOOL effectively = YES;
	UIControlContentHorizontalAlignment hAlignment;
	switch (position) {
		case MTSBIconPositionLeft:
			hAlignment = UIControlContentHorizontalAlignmentLeft;
			break;
		case MTSBIconPositionCenter:
			hAlignment = UIControlContentHorizontalAlignmentCenter;
			break;
		case MTSBIconPositionRight:
			hAlignment = UIControlContentHorizontalAlignmentRight;
			break;
	}
	UIControlContentVerticalAlignment vAlignment = UIControlContentVerticalAlignmentCenter;
	
	int total_width = leftMargin, max_height = 0;
    for (UIView *child in v.subviews)
    {
        total_width += child.frame.size.width;
        if (max_height < child.frame.size.height)
            max_height = child.frame.size.height;
    }
    total_width += ([v.subviews count] - 1) * spacing + rightMargin;
    if (effectively == YES)
    {
        int left, top, baseline = (v.frame.size.height - topMargin
                                   - bottomMargin) / 2 + topMargin;
        switch (hAlignment)
        {
            case UIControlContentHorizontalAlignmentLeft:
                left = leftMargin;
                break;
            case UIControlContentHorizontalAlignmentRight:
                left = v.frame.size.width - total_width + leftMargin;
                break;
            default: // center
                left = v.frame.size.width / 2 - total_width / 2 + leftMargin;
                break;
        }
        left -= spacing;
        for (UIView *child in v.subviews)
        {
            left += spacing;
            switch (vAlignment)
            {
                case UIControlContentVerticalAlignmentTop:
                    top = topMargin;
                    break;
                case UIControlContentVerticalAlignmentBottom:
                    top = v.frame.size.height - bottomMargin
					- child.frame.size.height;
                    break;
                default: // center
                    top = baseline - child.frame.size.height / 2;
                    break;
            }
            child.frame = CGRectMake(left, top, child.frame.size.width,
                                     child.frame.size.height);
            left += child.frame.size.width;
        }
    }
}

- (void)dealloc {
    [super dealloc];
}


@end
