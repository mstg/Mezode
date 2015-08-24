//
//  Mezode.m
//  Mezode
//
//  Created by Mustafa Gezen on 23.08.2015.
//  Copyright © 2015 Mustafa Gezen. All rights reserved.
//

#import "ZKSwizzle.h"
#import "fakelogos.h"
#import <UIKit/UIKit.h>

@interface UIApplication (Private)
-(id)_rootViewControllers;
@end

UIColor *iMessageColor;
UIColor *SMSColor;
UIColor *grayColor;

@interface CKNavigationBar : UINavigationBar
@end

CKNavigationBar *activeBar;
UIButton *activeButton;

UINavigationController *activeNav;
BOOL inConversation = false;

hook(CKNavigationBar)
- (id)initWithFrame:(CGRect)arg1 {
	[UIApplication sharedApplication].statusBarStyle = UIBarStyleBlack;
	id orig = _orig(id, arg1);
	activeBar = orig;
	return orig;
}
endhook

hook(CKMessageEntryView)
- (void)setSendButton:(UIButton*)sendButton {
	_orig(void, sendButton);
	activeButton = sendButton;
}
endhook

hook(CKTranscriptController)
- (id)initWithNavigationController:(id)arg1 {
	activeNav = arg1;
	return _orig(id, arg1);
}

- (void)viewWillDisappear:(BOOL)animated {
	_orig(void, animated);
	inConversation = false;
	activeBar.barStyle = UIBarStyleDefault;
	activeNav.navigationBar.barStyle = UIBarStyleDefault;
	[activeBar setBarTintColor:nil];
	[activeBar setTintColor:nil];
	[activeNav.navigationBar setBarTintColor:nil];
	[activeNav.navigationBar setTintColor:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	inConversation = true;
	activeBar.barStyle = 1;
	activeNav.navigationBar.barStyle = 1;
	[activeBar setTintColor:UIColor.whiteColor];
	[activeNav.navigationBar setTintColor:UIColor.whiteColor];
	if (!activeButton.isEnabled) {
		[activeBar setBarTintColor:SMSColor];
		[activeNav.navigationBar setBarTintColor:SMSColor];
	} else {
		[activeBar setBarTintColor:activeButton.titleLabel.textColor];
		[activeNav.navigationBar setBarTintColor:activeButton.titleLabel.textColor];
	}
	_orig(void, animated);
}
endhook

hook(UIViewController)
- (UIStatusBarStyle)preferredStatusBarStyle {
	return inConversation ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}
endhook

hook(CKMessagesController)
-(void)showConversation:(id)conversation animate:(BOOL)animate {
	_orig(void, conversation, animate);
	inConversation = true;
	activeBar.barStyle = 1;
	activeNav.navigationBar.barStyle = 1;
	[activeBar setTintColor:UIColor.whiteColor];
	[activeNav.navigationBar setTintColor:UIColor.whiteColor];
	if (!activeButton.isEnabled) {
		[activeBar setBarTintColor:SMSColor];
		[activeNav.navigationBar setBarTintColor:SMSColor];
	} else {
		[activeBar setBarTintColor:activeButton.titleLabel.textColor];
		[activeNav.navigationBar setBarTintColor:activeButton.titleLabel.textColor];
	}
}
endhook

hook(CKColoredBalloonView)
-(unsigned long long)balloonCorners {
	return 0;
}

-(BOOL)hasTail {
	return NO;
}

-(void)setFrame:(CGRect)arg1 {
	_orig(void, CGRectMake(arg1.origin.x == 14.0 ? -8 : arg1.origin.x+25, arg1.origin.y, arg1.size.width, arg1.size.height));
}
endhook

ctor {
	iMessageColor = [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1];
	SMSColor = [UIColor colorWithRed:0 green:0.8 blue:0.278431 alpha:1];
	grayColor = [UIColor colorWithRed:0.556863 green:0.556863 blue:0.576471 alpha:1];
}