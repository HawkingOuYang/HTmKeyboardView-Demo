//
//  HTmPlaceHolderTextView.h
//  HTmKeyboardView-Demo
//
//  Created by OYXJ on 16/03/28.
//  Copyright (c) 2016年 OYXJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTmPlaceHolderTextView;


#pragma mark - types
/**
 *  输入内容改变的回调block
 */
typedef void(^TextChangeBlock)(HTmPlaceHolderTextView *thePlaceHolderTextView, NSString *theText);


#pragma mark - class
/*! @brief 带有PlaceHolder的TextView
 *  @author OuYangXiaoJin 2016.03.28
 */
@interface HTmPlaceHolderTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor  *placeholderColor;
@property (nonatomic, strong) UIFont   *placeholderFont;
@property (nonatomic, assign) NSTextAlignment placeholderAlignment;

/**
 *  输入内容改变的回调block
 */
@property (nonatomic, copy) TextChangeBlock textChangeBlock;

@end
