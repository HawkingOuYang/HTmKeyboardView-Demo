//
//  HTmKeyboardDialView.h
//  HTmKeyboardView-Demo
//
//  Created by OYXJ on 16/03/24.
//  Copyright (c) 2016年 [OYXJlucky@163.com] All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTmKeyboardDialView;//当前类


/**
 每个按键的高度
 */
extern NSInteger const HTmKeyboardDialView_buttonHeight;


#pragma mark - protocol HTmKeyboardDialViewDelegate

@protocol HTmKeyboardDialViewDelegate <NSObject>
@optional
/**
 *  拨号键盘
 *
 *  @param sender    点击的按键
 *  @param btnString 按键的标题
 */
- (void)keyboardDialView:(HTmKeyboardDialView *)keyboardDialView
            tappedAction:(UIButton *)sender
            buttonString:(NSString *)btnString;

/**
 *  拨号键盘：长按删除按键，删除所有已经输入的字符串。
 *  @attention 长按删除按键，删除所有已经输入的字符串。
 */
- (void)longPressDeleteWholeString:(HTmKeyboardDialView *)keyboardDialView;

/**
 *  拨号键盘：长按 数字按键
 *  @attention 长按 数字按键
 *
 *  @param  btnString，长按的 数字NSString
 */
- (void)keyboardDialView:(HTmKeyboardDialView *)keyboardDialView
    longPressDigitString:(NSString *)btnString;

@end



#pragma mark - CLASS HTmKeyboardDialView

/*! @brief  拨号模块-界面层-拨号键盘(0~9数字键盘)
 *  @author OuYangXiaoJin on 2016.03.24
 */
@interface HTmKeyboardDialView : UIView

/**
 *  拨号键盘(0~9数字键盘)
 *
 *  @param delegate 代理
 *  @param isShow   是否显示 拨号键盘(0~9数字键盘)的底部功能按键：关闭按键、拨号按键、删除按键。
 *
 *  @return 实例
 */
- (instancetype)initWithDelegate:(id<HTmKeyboardDialViewDelegate>)delegate
             showBottomToolsView:(BOOL)isShow;

/*! @brief  拨号键盘总高度
 *  @note   是否显示 拨号键盘(0~9数字键盘)的底部功能按键：关闭按键、拨号按键、删除按键；若是，则总高度是 HTmKeyboardDialView_buttonHeight*5，否则，HTmKeyboardDialView_buttonHeight*4 。
 */
- (CGFloat)totalHeight;

@end
