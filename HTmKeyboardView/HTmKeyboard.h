//
//  HTmKeyboard.h
//  HTmKeyboardView-Demo
//
//  Created by OYXJ on 16/04/06.
//  Copyright (c) 2016年 [OYXJlucky@163.com] All rights reserved.
//

/**
 自定义键盘
 */
#import "HTmKeyboardView.h"
#import "HTmKeyboardTopView.h"
#import "HTmKeyboardBottomView.h"
#import "HTmKeyboardViewNotificationName.h"



#pragma mark - how to use

/*
 
HTmKeyboardTopView *kbTopView = [[HTmKeyboardTopView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
HTmKeyboardBottomView *kbBottomView = [[HTmKeyboardBottomView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];

HTmKeyboardView *keyboardView = [[HTmKeyboardView alloc] initWithDelegate:nil
                                                             topToolsView:kbTopView
                                                          bottomToolsView:kbBottomView
                                               showDefaultBottomToolsView:YES];

__weak __typeof(kbTopView) _weak_kbTopView = kbTopView;
keyboardView.keyboardViewBlock = ^(HTmKeyboardView *theKeyboardView, NSString *inputString) {
    __strong __typeof(_weak_kbTopView) _strong_kbTopView = _weak_kbTopView;
    
    _strong_kbTopView.placeHolderTextView.text = inputString;
};

__weak __typeof(keyboardView) _weak_keyboardView = keyboardView;
kbTopView.closeKeyboardBlock = ^{
    __strong __typeof(_weak_keyboardView) _strong_keyboardView = _weak_keyboardView;
    
    [_strong_keyboardView remove];
};

[keyboardView showInView: self.view];

*/
