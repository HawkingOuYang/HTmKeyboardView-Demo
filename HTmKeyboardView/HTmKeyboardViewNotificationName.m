//
//  HTmKeyboardViewNotificationName.m
//  TemplatesProject
//
//  Created by OYXJ on 16/5/17.
//  Copyright © 2016年 OYXJ. All rights reserved.
//

#import "HTmKeyboardViewNotificationName.h"


/**
 通知名称：自定义键盘，输入字符串，已经改变。
 */
NSString * const _Nonnull HTmKeyboardView_NotificationName_InputString_DidChangeNotification
                       =@"HTmKeyboardView_NotificationName_InputString_DidChangeNotification";
/**
 通知KEY：自定义键盘，输入全部字符串 对应的KEY
 */
NSString * const _Nonnull HTmKeyboardView_NotificationUserInfoKEY_TotalInputString
                       =@"HTmKeyboardView_NotificationUserInfoKEY_TotalInputString";

/**
 通知名称：自定义键盘，长按 数字按键
 */
NSString * const _Nonnull HTmKeyboardView_NotificationName_DidLongPressDigitNotification
                       =@"HTmKeyboardView_NotificationName_DidLongPressDigitNotification";
/**
 通知KEY：自定义键盘，长按 数字NSString 对应的KEY
 */
NSString * const _Nonnull HTmKeyboardView_NotificationUserInfoKEY_LongPressDigitString
                       =@"HTmKeyboardView_NotificationUserInfoKEY_LongPressDigitString";


//! 通知名称：自定义键盘，键盘将要出现
NSString * const _Nonnull HTmKeyboardView_NotificationName_KeyboardWillShowNotification
                      = @"HTmKeyboardView_NotificationName_KeyboardWillShowNotification";

//! 通知名称：自定义键盘，键盘将要消失
NSString * const _Nonnull HTmKeyboardView_NotificationName_KeyboardWillHideNotification
                      = @"HTmKeyboardView_NotificationName_KeyboardWillHideNotification";

//! 通知名称：自定义键盘，键盘已经出现
NSString * const _Nonnull HTmKeyboardView_NotificationName_KeyboardDidShowNotification
                      = @"HTmKeyboardView_NotificationName_KeyboardDidShowNotification";

//! 通知名称：自定义键盘，键盘已经消失
NSString * const _Nonnull HTmKeyboardView_NotificationName_KeyboardDidHideNotification
                      = @"HTmKeyboardView_NotificationName_KeyboardDidHideNotification";

//! 通知KEY：自定义键盘，动画时间@(floatValue) 对应的KEY
NSString * const _Nonnull HTmKeyboardView_NotificationUserInfoKEY_KeyboardAnimationDuration
                      = @"HTmKeyboardView_NotificationUserInfoKEY_KeyboardAnimationDuration";

//! 通知KEY：自定义键盘，键盘位置@(CGRectValue) 对应的KEY
NSString * const _Nonnull HTmKeyboardView_NotificationUserInfoKEY_KeyboardFrame
                      = @"HTmKeyboardView_NotificationUserInfoKEY_KeyboardFrame";

//! 通知KEY：自定义键盘，关闭键盘之后保留的y偏移@(floatValue) (露出键盘的上方) 对应的KEY
NSString * const _Nonnull HTmKeyboardView_NotificationUserInfoKEY_OffsetYafterDismiss
                       =@"HTmKeyboardView_NotificationUserInfoKEY_OffsetYafterDismiss";
