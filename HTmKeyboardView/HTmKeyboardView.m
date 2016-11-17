//
//  HTmKeyboardView.m
//  HTmKeyboardView-Demo
//
//  Created by OYXJ on 16/03/24.
//  Copyright (c) 2016年 [OYXJlucky@163.com] All rights reserved.
//

#import "HTmKeyboardView.h"

#import "HTmKeyboardDialView.h"//拨号键盘视图



static const NSTimeInterval HTmKeyboardView_DefaultAnimationDuration = 0.35;



#pragma mark - CLASS HTmKeyboardView
@interface HTmKeyboardView () <HTmKeyboardDialViewDelegate>
{
    /**
     放置在键盘上方的view
     */
    UIView    *m_keyboardTopView;
    
    /**
     放置在键盘下方的view
     */
    UIView    *m_keyboardBottomView;
    
    /**
     是否显示默认：拨号键盘(0~9数字键盘)的底部功能按键：关闭按键、拨号按键、删除按键 --- 注意若bottomV不为nil，则该参数始终为NO。
     */
    BOOL       m_isShowDefaultBottomToolsView;
    
    /**
     当前视图 原始高度
     */
    CGFloat    m_selfOriginHeight;
    
    /**
     当前视图 的父视图 高度
     */
    CGFloat    m_selfSuperViewHeight;
    
    /**
     是否显示了 键盘
     */
    BOOL       m_isKeyboardShowup;
    
    /**
     键盘是否关闭，但是露出上部分。
     */
    BOOL       m_isKeyboardViewDismissOffset;
    
    /**
     关闭(是dismiss，而不是remove)当前 拨号键盘 视图，但是保留 偏移 offsetY 。
     @(floatValue)
     */
    NSNumber   *m_offsetY_AfterSelfDismiss;
}

/**
 *  mainContentView 包含的子视图：拨号键盘视图、键盘上方的视图、键盘下方的视图。
 */
@property (nonatomic, strong) UIView    *mainContentView;

@property (nonatomic, strong) HTmKeyboardDialView *keyboardDialView;

/**
 记录 输入字符串
 */
@property (nonatomic, copy) NSString  *totalInputString;

@property (nonatomic, weak) id<HTmKeyboardViewDelegate>delegate;

//! 键盘顶部view的高度
@property (nonatomic, readwrite) CGFloat keyboardTopViewHeight;

@end




@implementation HTmKeyboardView


#pragma mark - PUBLIC method
#pragma mark 显示、隐藏

/**
 键盘是否弹出了。
 */
- (BOOL)isKeyboardViewShown
{
    return m_isKeyboardShowup;
}

/**
 键盘是否关闭，但是露出上部分。
 */
- (BOOL)isKeyboardViewDismissOffset
{
    return m_isKeyboardViewDismissOffset;
}


/**
 *  打开当前 拨号键盘 视图
 *
 *  @param view 当前 拨号键盘 视图 的父视图，可以为nil；若为nil，则键盘使用Window作为父视图。
 *  @param isOverlapTabbar 是否覆盖TabBar；若参数view为nil，则键盘使用Window作为父视图，那么参数isOverlapTabbar被忽略，且键盘覆盖TabBar；若参数view不为nil，那么键盘是否覆盖TabBar由参数isOverlapTabbar决定。
 */
- (void)showInView:(UIView *)view
     overlapTabbar:(BOOL)isOverlapTabbar
{
//    DDLogInfo(@"%@,%@", THIS_FILE,THIS_METHOD);
    
    [self showInView:view
 animateWithDuration:-100
       overlapTabbar:isOverlapTabbar];
}

/**
 *  打开当前 拨号键盘 视图
 *
 *  @param view 当前 拨号键盘 视图 的父视图，可以为nil；若为nil，则键盘使用Window作为父视图。
 *  @param animationDuration 键盘弹出的动画时间；如果小于0，则使用默认值0.35
*  @param overlapTabbarHeight 是否覆盖TabBar，大雨；若参数view为nil，则键盘使用Window作为父视图，那么参数overlapTabbarHeight被忽略，且键盘覆盖TabBar；若参数view不为nil，那么键盘是否覆盖TabBar由参数overlapTabbarHeight决定。
 */
- (void)showInView:(UIView *)view
animateWithDuration:(NSTimeInterval)animationDuration
     overlapTabbar:(BOOL)isOverlapTabbar
{
//    DDLogInfo(@"%@,%@", THIS_FILE,THIS_METHOD);
    
    [self showInView:view
 animateWithDuration:animationDuration
            animated:YES
       overlapTabbar:isOverlapTabbar];
}

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
{
//    DDLogInfo(@"%@,%@", THIS_FILE,THIS_METHOD);
 
//    DDLogDebug(@"%@,%@ %@ %@", THIS_FILE,THIS_METHOD, @"调用弹出键盘",[NSThread callStackSymbols]);
    
    if (m_isKeyboardShowup == YES) {
        return;
    }
    //! 是否显示了 键盘
    m_isKeyboardShowup = YES;
    

    
    CGFloat yDeltaForTabbarHeight = 0; //overlapTabbarHeight;
    
    CGFloat superViewHeight = [UIScreen mainScreen].bounds.size.height;
    if (view != nil) {//view 当前 拨号键盘 视图 的父视图
        
        superViewHeight = CGRectGetHeight(view.frame);
        
        if (m_offsetY_AfterSelfDismiss == nil) {//之前是remove
            [view addSubview:self];
        }else{//之前是dismiss
        }
        
    }else{
        
        superViewHeight = [UIScreen mainScreen].bounds.size.height;
        
        yDeltaForTabbarHeight = 0;
        
        // [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        [[UIApplication sharedApplication].delegate.window addSubview:self];
        
    }
    //! 当前视图 的父视图 高度
    m_selfSuperViewHeight = superViewHeight;

    
    NSTimeInterval duration = animationDuration;
    if (animationDuration < 0) {
        duration = HTmKeyboardView_DefaultAnimationDuration;
    }
    
    
    float h = m_selfOriginHeight;
    if (m_offsetY_AfterSelfDismiss == nil) {//之前是 remove
        
        self.frame = CGRectMake(0,
                                //[UIScreen mainScreen].bounds.size.height,
                                superViewHeight - yDeltaForTabbarHeight,
                                [UIScreen mainScreen].bounds.size.width,
                                h);
        
    }else{//之前是 dismiss
        
        self.frame = CGRectMake(0,
                                //[UIScreen mainScreen].bounds.size.height,
                                superViewHeight - yDeltaForTabbarHeight - [m_offsetY_AfterSelfDismiss floatValue],
                                [UIScreen mainScreen].bounds.size.width,
                                h);
    }
    self.alpha = 1.0f;
    
    
    
    
    CGRect targetFrame = CGRectMake(0,
                                    //[UIScreen mainScreen].bounds.size.height-h,
                                    superViewHeight - yDeltaForTabbarHeight  - h,
                                    [UIScreen mainScreen].bounds.size.width,
                                    h);
    //! 键盘的动画时间
    NSNumber *userInfoObj_Duration = nil;
    if (isAnimate) {//动画
        userInfoObj_Duration = [NSNumber numberWithDouble: duration];
    }else{//不 动画
        userInfoObj_Duration = [NSNumber numberWithDouble: 0.0];
    }
    //! 键盘大小
    NSValue *userInfoObj_Frame = [NSValue valueWithCGRect: targetFrame];
    
    
    //! 通知的字典
    NSDictionary *notifyDic = nil;
    if (m_offsetY_AfterSelfDismiss == nil) {//之前是 remove
        
        //! 通知的字典
        notifyDic           = @{
                                //自定义键盘，动画时间@(floatValue) 对应的KEY
                                HTmKeyboardView_NotificationUserInfoKEY_KeyboardAnimationDuration
                                :
                                userInfoObj_Duration,
                                
                                //自定义键盘，键盘位置@(CGRectValue) 对应的KEY
                                HTmKeyboardView_NotificationUserInfoKEY_KeyboardFrame
                                :
                                userInfoObj_Frame,
                                
                                };
        
    }else{//之前是 dismiss
        
        notifyDic       = @{
                            //自定义键盘，动画时间@(floatValue) 对应的KEY
                            HTmKeyboardView_NotificationUserInfoKEY_KeyboardAnimationDuration
                            :
                            userInfoObj_Duration,
                            
                            //自定义键盘，键盘位置@(CGRectValue) 对应的KEY
                            HTmKeyboardView_NotificationUserInfoKEY_KeyboardFrame
                            :
                            userInfoObj_Frame,
                            
                            //自定义键盘，关闭键盘之后保留的y偏移@(floatValue) (露出键盘的上方) 对应的KEY
                            HTmKeyboardView_NotificationUserInfoKEY_OffsetYafterDismiss
                            :
                            m_offsetY_AfterSelfDismiss
                            
                            };
    }
    
    
    {////
        [[NSNotificationCenter defaultCenter] postNotificationName:HTmKeyboardView_NotificationName_KeyboardWillShowNotification
                                                            object:nil
                                                          userInfo:notifyDic];//自定义键盘，键盘将要出现
    }////
    
    
    if (isAnimate) {//动画
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveLinear
                         animations:^(void) {
                             self.frame = CGRectMake(0,
                                                     //[UIScreen mainScreen].bounds.size.height-h,
                                                     superViewHeight - yDeltaForTabbarHeight  - h,
                                                     [UIScreen mainScreen].bounds.size.width,
                                                     h);
                         }
                         completion:^(BOOL finished) {
                             if (finished)
                             {////
                                 
                                 [[NSNotificationCenter defaultCenter] postNotificationName:HTmKeyboardView_NotificationName_KeyboardDidShowNotification
                                                                                     object:nil
                                                                                   userInfo:notifyDic];//自定义键盘，键盘已经出现
                             }////
                         }];
        
    }else{//不用动画
        
        self.frame = CGRectMake(0,
                                //[UIScreen mainScreen].bounds.size.height-h,
                                superViewHeight - yDeltaForTabbarHeight  - h,
                                [UIScreen mainScreen].bounds.size.width,
                                h);
        
        {////
            
            [[NSNotificationCenter defaultCenter] postNotificationName:HTmKeyboardView_NotificationName_KeyboardDidShowNotification
                                                                object:nil
                                                              userInfo:notifyDic];//自定义键盘，键盘已经出现
        }////
    }
    
}



/**
 关闭当前 拨号键盘 视图
 */
- (void)remove
{
    [self removeOrDismiss:YES offsetY:0];
}

/**
 *  关闭当前 拨号键盘 视图，但是保留 偏移 offsetY 。
 *  @attention 如果，当前键盘，用作UITextField或者UITextView的inputView，一定不能调用此方法。
 *  @param aFlag    如果YES则remove当前view(即执行[self removeFromSuperview];)，如果NO则dismiss当前view(即，不 执行[self removeFromSuperview];)。
 *  @param aOffsetY 该参数，仅当aFlag为NO(即dismiss当前view)时，aOffsetY参数有效；含义是：键盘不完全关闭，露出上面部分。
 */
- (void)removeOrDismiss:(BOOL)aFlag offsetY:(CGFloat)aOffsetY
{
//    DDLogInfo(@"%@,%@", THIS_FILE,THIS_METHOD);
    
    if (m_isKeyboardShowup == NO) {
        return;
    }
    //! 是否显示了 键盘
    m_isKeyboardShowup = NO;

    
    
    
    if (aFlag) {//remove
        
        m_offsetY_AfterSelfDismiss = nil;
        
        m_isKeyboardViewDismissOffset = NO;
        
    }else{//dismiss
        
        NSNumber *floatNum = [NSNumber numberWithFloat:aOffsetY];
        /**
         关闭(是dismiss，而不是remove)当前 拨号键盘 视图，但是保留 偏移 offsetY 。
         @(floatValue)
         */
        m_offsetY_AfterSelfDismiss = [floatNum copy];
        
        m_isKeyboardViewDismissOffset = YES;
    }
    
    
    CGFloat superViewHeight = [UIScreen mainScreen].bounds.size.height;
    if (m_selfSuperViewHeight > 0) {
        superViewHeight = m_selfSuperViewHeight;
    }
    
    CGRect targetFrame = CGRectZero;
    if (aFlag) {//remove
        
        targetFrame    = CGRectMake(0,
                                    //[UIScreen mainScreen].bounds.size.height,
                                    superViewHeight,
                                    [UIScreen mainScreen].bounds.size.width,
                                    0);
        
    }else{//dissmiss
        
        targetFrame    = CGRectMake(0,
                                    //[UIScreen mainScreen].bounds.size.height,
                                    superViewHeight - aOffsetY,
                                    [UIScreen mainScreen].bounds.size.width,
                                    m_selfOriginHeight);
        
    }
    
    
    //! 键盘的动画时间
    NSNumber *userInfoObj_Duration = [NSNumber numberWithDouble:HTmKeyboardView_DefaultAnimationDuration];
    //! 键盘大小
    NSValue *userInfoObj_Frame = [NSValue valueWithCGRect:targetFrame];

    //! 通知的字典
    NSDictionary *notifyDic = nil;
    if (aFlag) {//remove
        
        notifyDic           = @{
                                //自定义键盘，动画时间@(floatValue) 对应的KEY
                                HTmKeyboardView_NotificationUserInfoKEY_KeyboardAnimationDuration
                                :
                                userInfoObj_Duration,
                                
                                //自定义键盘，键盘位置@(CGRectValue) 对应的KEY
                                HTmKeyboardView_NotificationUserInfoKEY_KeyboardFrame
                                :
                                userInfoObj_Frame
                                
                                };
        
    }else{//dismiss
        
        if (m_offsetY_AfterSelfDismiss) {
            
            notifyDic       = @{
                                //自定义键盘，动画时间@(floatValue) 对应的KEY
                                HTmKeyboardView_NotificationUserInfoKEY_KeyboardAnimationDuration
                                :
                                userInfoObj_Duration,
                                
                                //自定义键盘，键盘位置@(CGRectValue) 对应的KEY
                                HTmKeyboardView_NotificationUserInfoKEY_KeyboardFrame
                                :
                                userInfoObj_Frame,
                                
                                //自定义键盘，关闭键盘之后保留的y偏移@(floatValue) (露出键盘的上方) 对应的KEY
                                HTmKeyboardView_NotificationUserInfoKEY_OffsetYafterDismiss
                                :
                                m_offsetY_AfterSelfDismiss
                                
                                };
            
        }else{
            
            notifyDic       = @{
                                //自定义键盘，动画时间@(floatValue) 对应的KEY
                                HTmKeyboardView_NotificationUserInfoKEY_KeyboardAnimationDuration
                                :
                                userInfoObj_Duration,
                                
                                //自定义键盘，键盘位置@(CGRectValue) 对应的KEY
                                HTmKeyboardView_NotificationUserInfoKEY_KeyboardFrame
                                :
                                userInfoObj_Frame,
                                
                                };
        }
    }
    
    {////
        [[NSNotificationCenter defaultCenter] postNotificationName:HTmKeyboardView_NotificationName_KeyboardWillHideNotification
                                                            object:nil
                                                          userInfo:notifyDic];//自定义键盘，键盘将要消失
    }////
    
    
    [UIView animateWithDuration:HTmKeyboardView_DefaultAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveLinear
                     animations:^(void) {
                         if (aFlag) {//remove
                             
                             [self setFrame:CGRectMake(0,
                                                       //[UIScreen mainScreen].bounds.size.height,
                                                       superViewHeight,
                                                       [UIScreen mainScreen].bounds.size.width,
                                                       0)];
                             
                         }else{//dismiss
                             
                             [self setFrame:CGRectMake(0,
                                                       //[UIScreen mainScreen].bounds.size.height,
                                                       superViewHeight - aOffsetY,
                                                       [UIScreen mainScreen].bounds.size.width,
                                                       m_selfOriginHeight)];
                             
                         }
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             if (aFlag) {//remove
                                 
                                 [self removeFromSuperview];
                                 
                             }else{//dismiss
                                 
                                 //do nothing
                             }
                             
                             {////
                                 [[NSNotificationCenter defaultCenter] postNotificationName:HTmKeyboardView_NotificationName_KeyboardDidHideNotification
                                                                                     object:nil
                                                                                   userInfo:notifyDic];//自定义键盘，键盘已经消失
                             }////
                         }
                     }];
}


#pragma mark 设置 键盘的字符
/**
 *  设置 键盘的字符
 *  @attention
 1、外部 调用此方法 之后，键盘的字符 改变；内部 不会 调用 键盘的 delegate方法 和 block回调，以表示 字符内容 改变。
 2、只有 用户ACTION(比如点按了键盘上的按键) 导致 键盘的输入字符改变，内部才会调用 键盘的 delegate方法 和 block回调。
 *
 *  @param totalInputString
 */
- (void)setupHTmKeyboardViewTotalInputString:(NSString *)totalInputString
{
    if (totalInputString.length <= 0) {
        [self setTotalInputString:@""];
    }else{
        [self setTotalInputString:totalInputString];
    }
}





#pragma mark - life cycle
#pragma mark 初始化
/**
 *  拨号键盘,可以自定义键盘上方和下放的视图
 *
 *  @param delegate 代理
 *  @param topV     键盘上方的视图，必须初始化其size
 *  @param bottomV  键盘下放的视图，必须初始化其size
 *  @param isShow   是否显示默认：拨号键盘(0~9数字键盘)的底部功能按键：关闭按键、拨号按键、删除按键 --- 注意若bottomV不为nil，则该参数始终为NO。
 *
 *  @return 实例
 */
- (instancetype)initWithDelegate:(id<HTmKeyboardViewDelegate>)delegate
                    topToolsView:(UIView *)topV
                 bottomToolsView:(UIView *)bottomV
      showDefaultBottomToolsView:(BOOL)isShow
{
    self = [super init];
    if (self) {
        
        //步骤一
        if (delegate) {
            self.delegate = delegate;
        }
        m_keyboardTopView = topV;
        m_keyboardBottomView = bottomV;
        m_isShowDefaultBottomToolsView = isShow;
        if (bottomV) {
            m_isShowDefaultBottomToolsView = NO;
        }
            
        
        //步骤二
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        //步骤三
        [self addSubview: [self mainContentView]];
        self.frame = _mainContentView.bounds;
        
        //步骤四
        m_selfOriginHeight = self.frame.size.height;
    }
    return self;
}

/**
 只包含数字按键的键盘。
 */
- (instancetype)initWithDelegate:(id<HTmKeyboardViewDelegate>)delegate;
{
    return [self initWithDelegate:delegate topToolsView:nil bottomToolsView:nil showDefaultBottomToolsView:NO];
}

- (instancetype)init
{
    return [self initWithDelegate:nil topToolsView:nil bottomToolsView:nil showDefaultBottomToolsView:NO];
}



#pragma mark - private method - 视图组件(getters)

/**
 创建子视图
 */
- (UIView *)mainContentView
{
    if (!_mainContentView) {
        // 拨号键盘(0~9数字键盘)
        _keyboardDialView = [[HTmKeyboardDialView alloc] initWithDelegate: self
                                                      showBottomToolsView: m_isShowDefaultBottomToolsView];
        
        CGFloat mainContentWidth = _keyboardDialView.frame.size.width;
        
        CGFloat mainContentHeight = [_keyboardDialView totalHeight]
                                    + m_keyboardTopView.frame.size.height + m_keyboardBottomView.frame.size.height;
        mainContentHeight += 1;
        
        
        _mainContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainContentWidth, mainContentHeight)];
        _mainContentView.backgroundColor = [UIColor whiteColor];
        
        CGFloat keyboardDialView_minY = _keyboardDialView.frame.origin.y;
        if (m_keyboardTopView) {
            CGRect f = m_keyboardTopView.frame;
            f.origin.x = ( CGRectGetWidth(_mainContentView.frame) - CGRectGetWidth(m_keyboardTopView.frame) )/2.0;
            f.origin.y = 0;
            m_keyboardTopView.frame = f;
            
            [_mainContentView addSubview:m_keyboardTopView];
            
            keyboardDialView_minY = CGRectGetMaxY(m_keyboardTopView.frame) + 0.5;
            
            //键盘顶部view的高度
            [self setKeyboardTopViewHeight: CGRectGetHeight(m_keyboardTopView.frame)];
        }else{
            //键盘顶部view的高度
            [self setKeyboardTopViewHeight: CGRectGetHeight(m_keyboardTopView.frame)];
        }
        
        if (m_keyboardBottomView) {
            CGRect f = m_keyboardBottomView.frame;
            f.origin.x = ( CGRectGetWidth(_mainContentView.frame) - CGRectGetWidth(m_keyboardBottomView.frame) )/2.0;
            f.origin.y = keyboardDialView_minY + [_keyboardDialView totalHeight] + 0.5;
            m_keyboardBottomView.frame = f;
            
            [_mainContentView addSubview:m_keyboardBottomView];
        }
        
        
        CGRect r = _keyboardDialView.frame;
        r.origin.y = keyboardDialView_minY;
        _keyboardDialView.frame = r;
        
        [_mainContentView addSubview:_keyboardDialView];
        
        
        _mainContentView.userInteractionEnabled = YES;
    }
    
    return _mainContentView;
}

#pragma mark - private method - 属性(getters)

- (NSString *)totalInputString
{
    if (!_totalInputString) {
        _totalInputString = [[NSString alloc] init];
    }
    
    return _totalInputString;
}



#pragma mark - <HTmKeyboardDialViewDelegate>

- (void)keyboardDialView:(HTmKeyboardDialView *)keyboardDialView
            tappedAction:(UIButton *)sender
            buttonString:(NSString *)btnString
{
    NSLog(@"%@", btnString);
    
    if ([btnString isEqualToString:NSLocalizedString(@"删除", nil)] || [btnString isEqualToString:NSLocalizedString(@"回退", nil)] || [btnString isEqualToString:@"delete"])
    {
        int count = (int)self.totalInputString.length;
        NSString *str = [self.totalInputString substringToIndex: MAX(count-1,0) ];
        
        self.totalInputString = str.length > 0 ? [str copy] : [@"" copy];
    }
    else if ( btnString.length > 0 && [@"0123456789*#" rangeOfString:btnString].location != NSNotFound )
    {
        self.totalInputString = [self.totalInputString stringByAppendingString:btnString];
    }
    
    NSLog(@"%@", self.totalInputString);
    
    
    // delegate out
    if (self.delegate
        &&
        [self.delegate respondsToSelector:@selector(keyboardView:tapTotalString:)])
    {
        [self.delegate keyboardView:self tapTotalString:self.totalInputString];
    }
    
    // block call back
    if (_inputStringChangedBlock) {
        _inputStringChangedBlock(self, self.totalInputString);
    }
    
    
    {////
        NSDictionary *notifyDic = @{HTmKeyboardView_NotificationUserInfoKEY_TotalInputString
                                    :
                                    self.totalInputString.length?self.totalInputString:@""
                                    };
        [[NSNotificationCenter defaultCenter] postNotificationName:HTmKeyboardView_NotificationName_InputString_DidChangeNotification
                                                            object:nil
                                                          userInfo:notifyDic];//输入字符串，已经改变。
    }////
    
}

//! 拨号键盘：长按删除按钮，删除所有已经输入的字符串。
- (void)longPressDeleteWholeString:(HTmKeyboardDialView *)keyboardDialView
{
    
    // delegate out
    if (self.delegate
        &&
        [self.delegate respondsToSelector:@selector(keyboardView:longPressDeleteAllInputString:)])
    {
        [self.delegate keyboardView:self longPressDeleteAllInputString:self.totalInputString];
    }
    
    // block call back
    if (_inputStringChangedBlock) {
        _inputStringChangedBlock(self, nil);//删除所有已经输入的字符串
    }
    
    self.totalInputString = nil;//删除所有已经输入的字符串
    
    
    {////
        NSDictionary *notifyDic = @{HTmKeyboardView_NotificationUserInfoKEY_TotalInputString
                                    :
                                    @""
                                    };
        [[NSNotificationCenter defaultCenter] postNotificationName:HTmKeyboardView_NotificationName_InputString_DidChangeNotification
                                                            object:nil
                                                          userInfo:notifyDic];//输入字符串，已经改变。
    }////
}


/**
 *  拨号键盘：长按 数字按键
 *  @attention 长按 数字按键
 *
 *  @param  btnString，长按的 数字NSString
 */
- (void)keyboardDialView:(HTmKeyboardDialView *)keyboardDialView
    longPressDigitString:(NSString *)btnString;
{
    
    // delegate out
    if (self.delegate
        &&
        [self.delegate respondsToSelector:@selector(keyboardView:longPressDigitString:)])
    {//长按 数字按键
        [self.delegate keyboardView:self longPressDigitString:btnString];
    }
    
    // block call back
    if (_longPressDigitBlock) {//长按 数字按键
        _longPressDigitBlock(self, btnString);
    }
    
    
    {////
        NSDictionary *notifyDic = @{HTmKeyboardView_NotificationUserInfoKEY_LongPressDigitString
                                    :
                                    btnString.length?btnString:@""
                                    };
        [[NSNotificationCenter defaultCenter] postNotificationName:HTmKeyboardView_NotificationName_DidLongPressDigitNotification
                                                            object:nil
                                                          userInfo:notifyDic];//长按 数字按键
    }////

}


@end
