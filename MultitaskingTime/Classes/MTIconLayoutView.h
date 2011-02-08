//
//  MTIconLayoutView.h
//  MultitaskingTime
//
//  Created by Fkuios on 10/13/10.
//  Copyright (c) 2010 Fkuios. All rights reserved.
//

#import "MTStatusBarIcon.h"

@interface MTIconLayoutView : UIView {
	UIView *leftView;
	UIView *centerView;
	UIView *rightView;
}

- (void)addView:(UIView *)view withPosition:(MTSBIconPosition)pos;
- (void)reorderAllIcons;
- (void)layoutView:(UIView *)v withAlignment:(MTSBIconPosition)position;

@end
