//
//  HTmKeyboardDialView.m
//  HTmKeyboardView-Demo
//
//  Created by OYXJ on 16/03/24.
//  Copyright (c) 2016年 [OYXJlucky@163.com] All rights reserved.
//

#import "HTmKeyboardDialView.h"

#import "UIImage+ImageWithColor.h"



//----- 屏幕 宽高 --- begin -----//
#define HTmKeyboardView_kScreenWidth        CGRectGetWidth([UIScreen mainScreen].bounds)
#define HTmKeyboardView_kScreenHeight       CGRectGetHeight([UIScreen mainScreen].bounds)
//----- 屏幕 宽高 --- end -----//


//----- 根据屏幕宽度比例；按比例缩放坐标 --- begin -----//
// 使用示范：kbvR(20)
// 含义：kbv 指 keyboardView； R 指 针对Retina缩放坐标； 20 指 坐标值。
//----- 屏幕宽度，考虑到 屏幕旋转 -----//
#define HTmKeyboardView_min_SCREEN_WIDTH        MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
//----- 根据屏幕宽度比例；按比例缩放坐标 -----//
#define HTmKeyboardView_SCREEN_SCALE        (HTmKeyboardView_min_SCREEN_WIDTH)>320?HTmKeyboardView_min_SCREEN_WIDTH/320.f:1.f
#define kbvR(x)   (HTmKeyboardView_SCREEN_SCALE)*(x)
//----- 根据屏幕宽度比例；按比例缩放坐标 --- end -----//



const int HTmKeyboardView_Button_BaseTag = 199;
const int HTmKeyboardView_Delta_BaseTag  = 12;  // 数字0~9加＊＃共12个按键

//2，为纵向的两根分割线宽度，每根分割线宽度为1
#define HTmKeyboardView_buttonWidth     ((HTmKeyboardView_kScreenWidth-2)/3.f)
/**
 键盘每个按键的高度
 */
CGFloat const HTmKeyboardView_buttonHeight = 46.f;


//! 隐藏*按键(index为9)
BOOL const HTmKeyboardView_isDisableAndHide_StarKey = YES;

//! 把#按键变成删除按键(index为11)
BOOL const HTmKeyboardView_isChange_PoundKeyToDeleteKey = YES;

//! 隐藏#按键或者删除按钮(index为11)
BOOL const HTmKeyboardView_isDisableAndHide_PoundKeyOrDeleteKey = YES;



#pragma mark - CLASS HTmKeyboardDialView
@interface HTmKeyboardDialView ()
{
    /**
     按键数字 和 ＊＃
     */
    NSArray *m_buttonTitleArray;
    
    /**
     是否显示底部功能view，包含三个按键：关闭按键、拨号按键、删除按键。
     */
    BOOL     m_isShowBottomToolsView;
    
    /**
     拨号键盘高度
     */
    CGFloat  m_keyboardDailViewHeight;
}
/**
 *  backGroundView 为按键的父视图
 */
@property (nonatomic, strong) UIView    *backGroundView;

@property (nonatomic, weak) id<HTmKeyboardDialViewDelegate>delegate;

@end



@implementation HTmKeyboardDialView


#pragma mark - PUBLIC

/**
 *  拨号键盘(0~9数字键盘)
 *
 *  @param delegate 代理
 *  @param isShow   是否显示 拨号键盘(0~9数字键盘)的底部功能按键：关闭按键、拨号按键、删除按键。
 *
 *  @return 实例
 */
- (instancetype)initWithDelegate:(id<HTmKeyboardDialViewDelegate>)delegate
             showBottomToolsView:(BOOL)isShow
{
    self = [super init];
    if (self) {
        
        //步骤一
        if (delegate) {
            self.delegate = delegate;
        }
        m_isShowBottomToolsView = isShow;
        
        //步骤二
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        //步骤三
        [self addSubview: [self backGroundView] ];
        self.frame = _backGroundView.bounds;
    }
    return self;
}

/*! @brief  拨号键盘总高度
 *  @note   是否显示 拨号键盘(0~9数字键盘)的底部功能按键：关闭按键、拨号按键、删除按键；若是，则总高度是 HTmKeyboardDialView_buttonHeight*5，否则，HTmKeyboardDialView_buttonHeight*4 。
 */
- (CGFloat)totalHeight
{
    return m_keyboardDailViewHeight;
}



#pragma mark - life cycle

- (instancetype)init
{
    return [self initWithDelegate:nil showBottomToolsView:NO];
}


#pragma mark - private method - 视图组件(getters)

/**
 创建子视图
 */
- (UIView *)backGroundView
{
    if (_backGroundView) {//只初始化一次
        return _backGroundView;
    }
    
    
    /**
     按键数字 和 ＊＃
     */
    m_buttonTitleArray = [@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"*",@"0",@"删除"] copy];
    
    
    //! 长按 进入 “我的设备” 页面
    NSString *imageName_mine_MyDevice = @"ic_ _dial_mine";
    
    
    /**
     键盘按键 图片名字－常态
     */
    NSArray *imageNormalArray = @[@"HTmKeyboardView.bundle/phone_ic_num_1",
                                  @"HTmKeyboardView.bundle/phone_ic_num_2",
                                  @"HTmKeyboardView.bundle/phone_ic_num_3",
                                  @"HTmKeyboardView.bundle/phone_ic_num_4",
                                  @"HTmKeyboardView.bundle/phone_ic_num_5",
                                  @"HTmKeyboardView.bundle/phone_ic_num_6",
                                  @"HTmKeyboardView.bundle/phone_ic_num_7",
                                  @"HTmKeyboardView.bundle/phone_ic_num_8",
                                  @"HTmKeyboardView.bundle/phone_ic_num_9",
                                  @"HTmKeyboardView.bundle/phone_ic_num_symbol1",
                                  @"HTmKeyboardView.bundle/phone_ic_num_0",
                                  @"HTmKeyboardView.bundle/phone_ic_num_symbol2"];
    
    /**
     键盘按键 图片名字－高亮态
     */
    NSArray *imageHighlightedArray = @[@"HTmKeyboardView.bundle/phone_ic_numchoose_1",
                                       @"HTmKeyboardView.bundle/phone_ic_numchoose_2",
                                       @"HTmKeyboardView.bundle/phone_ic_numchoose_3",
                                       @"HTmKeyboardView.bundle/phone_ic_numchoose_4",
                                       @"HTmKeyboardView.bundle/phone_ic_numchoose_5",
                                       @"HTmKeyboardView.bundle/phone_ic_numchoose_6",
                                       @"HTmKeyboardView.bundle/phone_ic_numchoose_7",
                                       @"HTmKeyboardView.bundle/phone_ic_numchoose_8",
                                       @"HTmKeyboardView.bundle/phone_ic_numchoose_9",
                                       @"HTmKeyboardView.bundle/phone_ic_numchoose_symbol1",
                                       @"HTmKeyboardView.bundle/phone_ic_numchoose_0",
                                       @"HTmKeyboardView.bundle/phone_ic_numchoose_symbol2"];

    /**
     功能按键 图片
     */
    NSArray *functionImageArray = @[@"HTmKeyboardView.bundle/phone_ic_dial.png",
                                    @"HTmKeyboardView.bundle/phone_ic_call.png",
                                    @"HTmKeyboardView.bundle/phone_ic_num_delete.png"];
    
    
    //纵向、横向 的分割线，宽度预留 1。
    float keyboardH = m_isShowBottomToolsView ? kbvR(HTmKeyboardView_buttonHeight*5) : kbvR(HTmKeyboardView_buttonHeight*4);
    keyboardH += m_isShowBottomToolsView ? 1*(5+1) : 1*(4+1);
    _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                               [UIScreen mainScreen].bounds.size.width,
                                                               keyboardH)
                           ];
    _backGroundView.backgroundColor = [UIColor whiteColor];
    
    
    m_keyboardDailViewHeight = keyboardH;
    
    
    for (int jRow = 0; jRow < 4; jRow++) {//4行
        for (int iColumn = 0; iColumn < 3; iColumn++) {//3列
            int curPosition = 3*jRow+iColumn;//当前位置
            
            //part1
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:26.0f];
            
            //纵向、横向 的分割线，宽度预留 1。
            button.frame = CGRectMake(iColumn * 1  + iColumn * HTmKeyboardView_buttonWidth,
                                      (jRow+1) * 1 + jRow * kbvR(HTmKeyboardView_buttonHeight),
                                      HTmKeyboardView_buttonWidth,
                                      kbvR(HTmKeyboardView_buttonHeight));
            
            
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]
                                                          size:CGSizeMake(HTmKeyboardView_buttonWidth, kbvR(HTmKeyboardView_buttonHeight))]
                    forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x000000 alpha:0.10]
                                                          size:CGSizeMake(HTmKeyboardView_buttonWidth, kbvR(HTmKeyboardView_buttonHeight))]
                    forState:UIControlStateHighlighted];
            
            
            if (curPosition == 9 && HTmKeyboardView_isDisableAndHide_StarKey) {//隐藏*按键(index为9)
                //do nothing
                //*按键，隐藏*按键
            }
            else if (curPosition == 11 && HTmKeyboardView_isDisableAndHide_PoundKeyOrDeleteKey) {//隐藏#按键或者删除按钮(index为11)
                //do nothing
                //#按键 或者 删除按钮，隐藏。
            }
            else if(curPosition == 11 && HTmKeyboardView_isChange_PoundKeyToDeleteKey) {//把#按键变成删除按键(index为11)
                
                [button setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
                [button setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateHighlighted];
                
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                
                
                button.tag = curPosition + HTmKeyboardView_Button_BaseTag;
                
                [button addTarget:self action:@selector(p_tappedAction:) forControlEvents:UIControlEventTouchUpInside];
                
                
                UILongPressGestureRecognizer *longPressDeleteGR = [[UILongPressGestureRecognizer alloc]
                                                             initWithTarget:self
                                                             action:@selector(p_onLongPressDeleteGR:)];
                [button addGestureRecognizer:longPressDeleteGR];//长按 删除全部
                
                
                //part1+
                [_backGroundView addSubview:button];
            }
            else{//其它按键(数字键0~9)
                UIImage *norImg = [UIImage imageNamed:[imageNormalArray      objectAtIndex:curPosition]];
                UIImage *hihImg = [UIImage imageNamed:[imageHighlightedArray objectAtIndex:curPosition]];
                
                [button setImage:norImg forState:UIControlStateNormal];
                [button setImage:hihImg forState:UIControlStateHighlighted];
                
                CGSize imageSize = {32, 35};//图片宽32，高35
                button.imageEdgeInsets = UIEdgeInsetsMake
                                        (button.bounds.size.height/2 -imageSize.height/2, button.bounds.size.width/2  -imageSize.width/2,
                                         button.bounds.size.height/2 -imageSize.height/2, button.bounds.size.width/2  -imageSize.width/2);
                
                {////////////////////////////
                    if (curPosition == 0) {//数字“1”，添加图片，长按数字“1”，进入“我的设备页面”。
                        UIImage *aImg = [UIImage imageNamed:imageName_mine_MyDevice];
                        UIImageView *aImgV = [[UIImageView alloc] initWithImage:aImg highlightedImage:aImg];
                        
                        CGFloat imgV_WH     = CGRectGetHeight(button.frame) * (10.0 / (float)HTmKeyboardView_buttonHeight);
                        CGFloat imgV_bottom = CGRectGetHeight(button.frame) * (7.0 / (float)HTmKeyboardView_buttonHeight);
                        aImgV.frame = CGRectMake(CGRectGetWidth(button.frame) / 2 - imgV_WH / 2,
                                                 CGRectGetHeight(button.frame) - imgV_WH - imgV_bottom,
                                                 imgV_WH,
                                                 imgV_WH);
                    
                        [button addSubview:aImgV];
                    }
                }////////////////////////////
                
                
                button.tag = curPosition + HTmKeyboardView_Button_BaseTag;
                
                [button addTarget:self action:@selector(p_tappedAction:) forControlEvents:UIControlEventTouchUpInside];
                
                //part1+
                [_backGroundView addSubview:button];
            }//<-- if语句结束：*按键 #按键 -->//
            
        }//行end
    }//列end
    for (int i = 0; i < 5; i++) {//横向分割线 5条
        
        //part2
        //纵向、横向 的分割线，宽度预留 1。
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    i * 1 + kbvR(HTmKeyboardView_buttonHeight) * i,
                                                                    HTmKeyboardView_kScreenWidth,
                                                                    1)
                            ];
        lineView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.08];
        
        
        //part2+
        [_backGroundView addSubview:lineView];
    }
    for (int i = 0; i < 2; i++) {//纵向分割线 2条
        
        //part3
        //纵向、横向 的分割线，宽度预留 1。
        CGFloat rowCount = m_isShowBottomToolsView ? 4 : 4;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i * 1 + HTmKeyboardView_buttonWidth * (i+1),
                                                                    1,
                                                                    1,
                                                                    (rowCount-1) * 1 + kbvR(HTmKeyboardView_buttonHeight) * rowCount)
                            ];
        lineView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.08];
        
        
        //part3+
        [_backGroundView addSubview:lineView];
    }
    
    
    if (m_isShowBottomToolsView) {//是否显示底部功能view，包含三个按键：关闭按键、拨号按键、删除按键。
        
        //part4
        UIImageView *callIconImgV = [[UIImageView alloc] initWithFrame:
                                     CGRectMake((HTmKeyboardView_kScreenWidth - (HTmKeyboardView_buttonWidth+10) )/2,
                                                1*5 + kbvR(HTmKeyboardView_buttonHeight)*4 + kbvR(HTmKeyboardView_buttonHeight-45)/2.0,
                                                HTmKeyboardView_buttonWidth+10,
                                                kbvR(45) )];
        
        callIconImgV.backgroundColor = [UIColor colorWithRed:78/255.0f  green:181/255.0f  blue:44/255.0f  alpha:1.0f];
        callIconImgV.layer.cornerRadius = 6.0;
        
        //part4+
        [_backGroundView addSubview:callIconImgV];
        
        
        for (int i = 0; i < 3; i++) {//功能按键
            
            //part5
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            
            button.frame = CGRectMake(i * 1 + HTmKeyboardView_buttonWidth * i,
                                      1*5 + kbvR(HTmKeyboardView_buttonHeight)*4,
                                      HTmKeyboardView_buttonWidth,
                                      kbvR(HTmKeyboardView_buttonHeight) );
            
            [button setBackgroundColor:[UIColor clearColor]];
            
            
            button.tag = i + HTmKeyboardView_Button_BaseTag + HTmKeyboardView_Delta_BaseTag; //数字0~9加＊＃共12个按键
            
            [button addTarget:self action:@selector(p_tappedAction:) forControlEvents:UIControlEventTouchUpInside];
            
            //part5+
            [_backGroundView addSubview:button];
            
            
            //part6
            UIImageView *funcImgV = [[UIImageView alloc] initWithFrame:
                                     CGRectMake( HTmKeyboardView_buttonWidth * i + (HTmKeyboardView_buttonWidth - kbvR(24))/2,
                                                1*5 + kbvR(HTmKeyboardView_buttonHeight)*4 + (kbvR(HTmKeyboardView_buttonHeight)-kbvR(24))/2,
                                                kbvR(24),
                                                kbvR(24))];//图片宽高24
            
            funcImgV.image = [UIImage imageNamed:[functionImageArray objectAtIndex:i]];
            
            //part6+
            [_backGroundView addSubview:funcImgV];
        }
        
    }//结束 m_isShowBottomToolsView
    
    
    {//长按手势
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(p_onLongPressGR:)];
        [_backGroundView addGestureRecognizer:longPressGR];//长按
    }//长按手势

    
    _backGroundView.userInteractionEnabled = YES;
    return _backGroundView;
}


#pragma mark - private method - Actions

- (void)p_tappedAction:(UIButton *)sender
{
    NSInteger idx = sender.tag - HTmKeyboardView_Button_BaseTag;
    
    NSArray *btnStrArr = [m_buttonTitleArray arrayByAddingObjectsFromArray:@[NSLocalizedString(@"关闭", nil),NSLocalizedString(@"拨号", nil) ,NSLocalizedString(@"删除", nil)]];
    NSString *btnString = nil;
    if (idx < btnStrArr.count) {
        btnString = btnStrArr[idx];
    }
    
    // delegate out
    if (self.delegate
        &&
        [self.delegate respondsToSelector:@selector(keyboardDialView:tappedAction:buttonString:)])
    {
        [self.delegate keyboardDialView:self
                           tappedAction:sender
                           buttonString:btnString.length?btnString:@""];
    }
}

//! 长按 '删除'
- (void)p_onLongPressDeleteGR:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"p_onLongPressDeleteGR: Long press detected.");
        
        if (HTmKeyboardView_isChange_PoundKeyToDeleteKey) {//把#按键变成删除按键
            
            // delegate out
            if (self.delegate
                &&
                [self.delegate respondsToSelector:@selector(longPressDeleteWholeString:)])
            {
                [self.delegate longPressDeleteWholeString:self];
            }
            
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"p_onLongPressDeleteGR: Long press Ended");
    }
    
}

//! 长按 手势
- (void)p_onLongPressGR:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"p_onLongPressGR: Long press detected.");
        
        CGPoint pt = [sender locationInView: _backGroundView];
        UIView *touched = [_backGroundView hitTest:pt withEvent:nil];
        if ([touched isKindOfClass:[UIButton class]]) {
            NSInteger idx = [(UIButton*)touched tag] - HTmKeyboardView_Button_BaseTag;
            if (idx <= m_buttonTitleArray.count) {
                NSString *tapNumberStr = m_buttonTitleArray[idx];
                NSLog(@"p_onLongPressGR: %@", tapNumberStr);
                
                // delegate out
                // 长按 数字按键，长按的 数字。
                if (self.delegate
                    &&
                    [self.delegate respondsToSelector:@selector(keyboardDialView:longPressDigitString:)])
                {
                    [self.delegate keyboardDialView:self
                               longPressDigitString:tapNumberStr.length?tapNumberStr:@""];
                }
            }
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"p_onLongPressGR: Long press Ended");
    }
   
}


@end
