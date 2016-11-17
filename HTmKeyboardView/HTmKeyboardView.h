//
//  HTmKeyboardView.h
//  HTmKeyboardView-Demo
//
//  Created by OYXJ on 16/03/24.
//  Copyright (c) 2016年 [OYXJlucky@163.com] All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTmKeyboardView;//当前类


#import "HTmKeyboardViewNotificationName.h"





#pragma mark - protocol HTmKeyboardViewDelegate

@protocol HTmKeyboardViewDelegate <NSObject>
@optional
/**
 *  拨号键盘输入变化
 *
 *  @param theKeyboardView  当前键盘
 *  @param totalInputString 输入的全部字符
 */
- (void)keyboardView:(HTmKeyboardView *)theKeyboardView
      tapTotalString:(NSString *)totalInputString;

/**
 *  长按删除按键，删除所有已经输入的字符串。
 *  @attention 长按删除按键，删除所有已经输入的字符串
 *
 *  @param theKeyboardView  当前键盘
 *  @param totalInputString 输入的全部字符，全部删除
 */
- (void)keyboardView:(HTmKeyboardView *)theKeyboardView
longPressDeleteAllInputString:(NSString *)totalInputString;

/**
 *  长按 数字按键
 *  @attention 长按 数字按键
 *
 *  @param theKeyboardView  当前键盘
 *  @param digitString      数字NSString
 */
- (void)keyboardView:(HTmKeyboardView *)theKeyboardView
longPressDigitString:(NSString *)digitString;
@end



#pragma mark - types
/**
 *  拨号键盘输入变化
 *
 *  @param theKeyboardView 当前键盘
 *  @param inputString     输入的字符
 *
    @attention HTmKeyboardView实例 已经retain了 HTmKeyboardTopView实例、HTmKeyboardBottomView实例、还有当前block，所以 这个block使用时，要避免 该block实例 retain HTmKeyboardView实例。
 
    @note  HTmKeyboardView -----> 当前block
           HTmKeyboardView <--X-- 当前block
 */
typedef void(^KeyboardViewInputChangeBlock)(HTmKeyboardView *theKeyboardView, NSString *totalInputString);
typedef void(^KeyboardViewLongPressDigitBlock)(HTmKeyboardView *theKeyboardView, NSString *digitString);


#pragma mark - CLASS HTmKeyboardView

/*! @brief  拨号模块-界面层-拨号键盘,可以自定义键盘上方和下放的视图
 *  @author OuYangXiaoJin on 2016.03.24
 */
@interface HTmKeyboardView : UIView

/**
    键盘输入改变
    @attention 注意避免 引用环。
    @note   HTmKeyboardView -----> 当前block ,
            HTmKeyboardView <--X-- 当前block 。
 */
@property (nonatomic, copy) KeyboardViewInputChangeBlock inputStringChangedBlock;
/**
    键盘长按数字
    @attention 注意避免 引用环。
    @note   HTmKeyboardView -----> 当前block ,
            HTmKeyboardView <--X-- 当前block 。
 */
@property (nonatomic, copy) KeyboardViewLongPressDigitBlock longPressDigitBlock;

//! 键盘顶部view的高度
@property (nonatomic, readonly) CGFloat keyboardTopViewHeight;


#pragma mark 初始化
/**
 *  拨号键盘,可以自定义键盘上方和下方的视图
 *
 *  @param delegate 代理
 *  @param topV     键盘上方的视图，必须初始化其size
 *  @param bottomV  键盘下方的视图，必须初始化其size
 *  @param isShow   是否显示默认：拨号键盘(0~9数字键盘)的底部功能按键：关闭按键、拨号按键、删除按键 --- 注意若bottomV不为nil，则该参数始终为NO。
 *
 *  @return 实例
 */
- (instancetype)initWithDelegate:(id<HTmKeyboardViewDelegate>)delegate
                    topToolsView:(UIView *)topV
                 bottomToolsView:(UIView *)bottomV
      showDefaultBottomToolsView:(BOOL)isShow;

/**
 只包含数字按键的键盘。
 */
- (instancetype)initWithDelegate:(id<HTmKeyboardViewDelegate>)delegate;


#pragma mark 显示、隐藏

/**
 键盘是否弹出了。
 */
- (BOOL)isKeyboardViewShown;

/**
 键盘是否关闭，但是露出上部分。
 */
- (BOOL)isKeyboardViewDismissOffset;

/**
 *  打开当前 拨号键盘 视图
 *  @attention 如果，当前键盘，用作UITextField或者UITextView的inputView，一定不能调用此方法。
 *
 *  @param view 当前 拨号键盘 视图 的父视图，可以为nil；若为nil，则键盘使用Window作为父视图。
 *  @param isOverlapTabbar 是否覆盖TabBar；若参数view为nil，则键盘使用Window作为父视图，那么参数isOverlapTabbar被忽略，且键盘覆盖TabBar；若参数view不为nil，那么键盘是否覆盖TabBar由参数isOverlapTabbar决定。
 */
- (void)showInView:(UIView *)view overlapTabbar:(BOOL)isOverlapTabbar;

/**
 *  打开当前 拨号键盘 视图
 *  @attention 如果，当前键盘，用作UITextField或者UITextView的inputView，一定不能调用此方法。
 *
 *  @param view 当前 拨号键盘 视图 的父视图，可以为nil；若为nil，则键盘使用Window作为父视图。
 *  @param animationDuration 键盘弹出的动画时间；如果小于0，则使用默认值0.35
 *  @param isOverlapTabbar 是否覆盖TabBar；若参数view为nil，则键盘使用Window作为父视图，那么参数isOverlapTabbar被忽略，且键盘覆盖TabBar；若参数view不为nil，那么键盘是否覆盖TabBar由参数isOverlapTabbar决定。
 */
- (void)showInView:(UIView *)view
animateWithDuration:(NSTimeInterval)animationDuration
     overlapTabbar:(BOOL)isOverlapTabbar;


/**
 *  打开当前 拨号键盘 视图
 *  @attention 如果，当前键盘，用作UITextField或者UITextView的inputView，一定不能调用此方法。
 *
 *  @param view 当前 拨号键盘 视图 的父视图，可以为nil；若为nil，则键盘使用Window作为父视图。
 *  @param animationDuration 键盘弹出的动画时间；如果小于0，则使用默认值0.35
 *  @param isAnimate 是否动画
 *  @param isOverlapTabbar 是否覆盖TabBar；若参数view为nil，则键盘使用Window作为父视图，那么参数isOverlapTabbar被忽略，且键盘覆盖TabBar；若参数view不为nil，那么键盘是否覆盖TabBar由参数isOverlapTabbar决定。
 */
- (void)showInView:(UIView *)view
animateWithDuration:(NSTimeInterval)animationDuration
          animated:(BOOL)isAnimate
     overlapTabbar:(BOOL)isOverlapTabbar;


/**
 *  关闭当前 拨号键盘 视图
 *  @attention 如果，当前键盘，用作UITextField或者UITextView的inputView，一定不能调用此方法。
 */
- (void)remove;

/**
 *  关闭当前 拨号键盘 视图，但是保留 偏移 offsetY 。
 *  @attention 如果，当前键盘，用作UITextField或者UITextView的inputView，一定不能调用此方法。
 *  @param aFlag    如果YES则remove当前view(即执行[self removeFromSuperview];)，如果NO则dismiss当前view(即，不 执行[self removeFromSuperview];)。
 *  @param aOffsetY 该参数，仅当aFlag为NO(即dismiss当前view)时，aOffsetY参数有效；含义是：键盘不完全关闭，露出上面部分。
 */
- (void)removeOrDismiss:(BOOL)aFlag offsetY:(CGFloat)aOffsetY;



#pragma mark 设置 键盘的字符
/**
 *  设置 键盘的字符
 *  @attention
    1、外部 调用此方法 之后，键盘的字符 改变；内部 不会 调用 键盘的 delegate方法 和 block回调，以表示 字符内容 改变。
    2、只有 用户ACTION(比如点按了键盘上的按键) 导致 键盘的输入字符改变，内部才会调用 键盘的 delegate方法 和 block回调。
 *
 *  @param totalInputString
 */
- (void)setupHTmKeyboardViewTotalInputString:(NSString *)totalInputString;

@end



