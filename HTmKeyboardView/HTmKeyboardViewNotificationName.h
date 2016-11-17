//
//  HTmKeyboardViewNotificationName.h
//  TemplatesProject
//
//  Created by OYXJ on 16/5/17.
//  Copyright © 2016年 OYXJ. All rights reserved.
//

#import <Foundation/Foundation.h>



#pragma mark - Constants
/**
 通知名称：自定义键盘，输入字符串，已经改变。
 */
extern NSString * const _Nonnull HTmKeyboardView_NotificationName_InputString_DidChangeNotification;
/**
 通知KEY：自定义键盘，输入全部字符串 对应的KEY
 */
extern NSString * const _Nonnull HTmKeyboardView_NotificationUserInfoKEY_TotalInputString;

/**
 通知名称：自定义键盘，长按 数字按键
 */
extern NSString * const _Nonnull HTmKeyboardView_NotificationName_DidLongPressDigitNotification;
/**
 通知KEY：自定义键盘，长按 数字NSString 对应的KEY
 */
extern NSString * const _Nonnull HTmKeyboardView_NotificationUserInfoKEY_LongPressDigitString;


//! 通知名称：自定义键盘，键盘将要出现
extern NSString * const _Nonnull HTmKeyboardView_NotificationName_KeyboardWillShowNotification;

//! 通知名称：自定义键盘，键盘将要消失
extern NSString * const _Nonnull HTmKeyboardView_NotificationName_KeyboardWillHideNotification;

//! 通知名称：自定义键盘，键盘已经出现
extern NSString * const _Nonnull HTmKeyboardView_NotificationName_KeyboardDidShowNotification;

//! 通知名称：自定义键盘，键盘已经消失
extern NSString * const _Nonnull HTmKeyboardView_NotificationName_KeyboardDidHideNotification;

//! 通知KEY：自定义键盘，动画时间@(floatValue) 对应的KEY
extern NSString * const _Nonnull HTmKeyboardView_NotificationUserInfoKEY_KeyboardAnimationDuration;

//! 通知KEY：自定义键盘，键盘位置@(CGRectValue) 对应的KEY
extern NSString * const _Nonnull HTmKeyboardView_NotificationUserInfoKEY_KeyboardFrame;

//! 通知KEY：自定义键盘，关闭键盘之后保留的y偏移@(floatValue) (露出键盘的上方) 对应的KEY
extern NSString * const _Nonnull HTmKeyboardView_NotificationUserInfoKEY_OffsetYafterDismiss;