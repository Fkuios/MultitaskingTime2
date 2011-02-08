//
//  PSSpecifier+Actions.h
//  Preferences
//
//  Created by Alistair Geesing on 23-01-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Preferences/Preferences.h>

@interface PSSpecifier (Actions)

- (SEL)action;
- (void)setAction:(SEL)action;

@end