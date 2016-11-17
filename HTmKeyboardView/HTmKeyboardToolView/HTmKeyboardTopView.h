//
//  HTmKeyboardTopView.h
//  HTmKeyboardView-Demo
//
//  Created by OYXJ on 16/04/06.
//  Copyright (c) 2016年 [OYXJlucky@163.com] All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTmPlaceHolderTextView.h"
@class HTmKeyboardTopView;


#pragma mark - types
/**
 @attention HTmKeyboardView实例 已经retain了 HTmKeyboardTopView实例，
            所以 这个block使用时，要避免 HTmKeyboardTopView实例 retain HTmKeyboardView实例。
 
 @note  HTmKeyboardView -----> HTmKeyboardTopView
        HTmKeyboardView <--X-- HTmKeyboardTopView
 */
typedef void(^KeyboardTopViewBlock)(HTmKeyboardTopView *theHTmKeyboardTopView);

/**
 *  剪切板 粘贴
 *
 *  @param theHTmKeyboardTopView 当前类，即self
 *  @param pastedString          粘贴的字符串
 */
typedef void(^KeyboardTopViewPasteBlock)(HTmKeyboardTopView *theHTmKeyboardTopView, NSString *pastedString);



#pragma mark - CLASS HTmKeyboardTopView

/*! @brief  拨号键盘-上方自定义视图
 *  @author OuYangXiaoJin on 2016.04.06
 */
@interface HTmKeyboardTopView : UIView

@property (nonatomic, strong) HTmPlaceHolderTextView    *placeHolderTextView;
//@property (nonatomic, strong) UIButton                  *closeKeyboardButton;
@property (nonatomic, strong) UIButton                  *deleteButton;
@property (nonatomic, strong) UIView                    *lineView;


/**
 关闭键盘
 */
//@property (nonatomic, copy) KeyboardTopViewBlock closeKeyboardBlock;

/**
 删除按钮点击，删除最后一个字符
 */
@property (nonatomic, copy) KeyboardTopViewBlock deleteButtonBlock;

/**
 长按删除按钮，删除所有字符
 */
@property (nonatomic, copy) KeyboardTopViewBlock longPressDeleteButtonBlock;

/**
 弹起气泡菜单，点击 “粘贴”：剪切板 粘贴
 */
@property (nonatomic, copy) KeyboardTopViewPasteBlock popBubbleMenuPasteBlock;


/**
 往上拖动打开keyboard
 */
@property (nonatomic, copy) KeyboardTopViewBlock panGestureOpenKeyboardBlock;

/**
 点击打开keyboard
 */
@property (nonatomic, copy) KeyboardTopViewBlock tapGestureOpenKeyboardBlock;


@end
