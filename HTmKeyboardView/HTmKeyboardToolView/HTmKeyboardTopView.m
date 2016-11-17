//
//  HTmKeyboardTopView.m
//  HTmKeyboardView-Demo
//
//  Created by OYXJ on 16/04/06.
//  Copyright (c) 2016年 [OYXJlucky@163.com] All rights reserved.
//

#import "HTmKeyboardTopView.h"

#import "MenuPopOverView.h"//气泡弹出菜单


//! 气泡弹出菜单 类型
typedef NS_ENUM(NSInteger, HTm_MenuPopOverView_Type) {
    
    //! 0 默认
    HTm_MenuPopOverView_Type_None       = 0,
    
    //! 粘贴
    HTm_MenuPopOverView_Type_Paste      = 1,
    
    //! 拷贝、粘贴
    HTm_MenuPopOverView_Type_CopyPaste  = 2,
};

const static NSString *kString_MenuPopOver_Copy  = @"拷贝";
const static NSString *kString_MenuPopOver_Paste = @"粘贴";



#pragma mark - CLASS HTmKeyboardTopView
@interface HTmKeyboardTopView () <
MenuPopOverViewDelegate
>
{
    //! 气泡弹出菜单 类型
    HTm_MenuPopOverView_Type  m_MenuPopOverView_Type;
}
@property (nonatomic, strong) UIImageView *topMaskImgV;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressCopyPasteGR;
@end



@implementation HTmKeyboardTopView


#pragma mark - PUBLIC method




#pragma mark - life cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:HTmKeyboardView_NotificationName_InputString_DidChangeNotification //自定义键盘 通知
                                                  object:nil];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview: [self topMaskImgV] ];
        [self addSubview: [self placeHolderTextView] ];
        /** [self addSubview: [self closeKeyboardButton] ]; **/
        [self addSubview: [self deleteButton] ];
        [self addSubview: [self lineView]];
        
        [self addGestureRecognizer: [self tapGestureRecognizer] ];
        [self addGestureRecognizer: [self panGestureRecognizer] ];
        [self addGestureRecognizer: [self longPressCopyPasteGR]];
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        _deleteButton.hidden = YES;//默认隐藏 删除按钮
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(on_HTmKeyboardView_NotificationName_InputString_DidChangeNotification:)
                                                     name:HTmKeyboardView_NotificationName_InputString_DidChangeNotification //自定义键盘 通知
                                                   object:nil];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat topMaskPercent = 40.0 / 43.0;
    
    _topMaskImgV.frame = CGRectMake(0,
                                    - CGRectGetHeight(self.frame) * topMaskPercent,
                                    CGRectGetWidth(self.frame),
                                    CGRectGetHeight(self.frame) * topMaskPercent);
    
    _placeHolderTextView.frame = CGRectMake(CGRectGetHeight(self.frame),
                                            0,
                                            CGRectGetWidth(self.frame)-CGRectGetHeight(self.frame)*2,
                                            CGRectGetHeight(self.frame));
    
    _deleteButton.frame = CGRectMake(CGRectGetWidth(self.frame)-CGRectGetHeight(self.frame),
                                     0,
                                     CGRectGetHeight(self.frame),
                                     CGRectGetHeight(self.frame));
    
    _lineView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1);
}



#pragma mark - 自定义键盘通知

- (void)on_HTmKeyboardView_NotificationName_InputString_DidChangeNotification:(NSNotification *)aNotification
{
    NSString *totalInputString = [[aNotification userInfo] objectForKey:HTmKeyboardView_NotificationUserInfoKEY_TotalInputString];
    if ([totalInputString length] > 0) {
        _deleteButton.hidden = NO;
    }else{
        _deleteButton.hidden = YES;
    }
    _placeHolderTextView.text = totalInputString;
}



#pragma mark - private method - 视图组件(getters)

- (UITapGestureRecognizer *)tapGestureRecognizer
{
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(onTapGR:)];
        
    }
    
    return _tapGestureRecognizer;
}

- (UIPanGestureRecognizer *)panGestureRecognizer
{
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(onPanGR:)];
        
    }
    
    return _panGestureRecognizer;
}

-(UILongPressGestureRecognizer *)longPressCopyPasteGR
{
    if (!_longPressCopyPasteGR) {
        _longPressCopyPasteGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(onCopyPasteLongPressGR:)];
        
        
    }
    
    return _longPressCopyPasteGR;
}


- (UIImageView *)topMaskImgV
{
    if (!_topMaskImgV) {
        _topMaskImgV = [[UIImageView alloc] init];
        
        _topMaskImgV.image = [UIImage imageNamed:@"pic_ _dial_projection"];
        
        _topMaskImgV.userInteractionEnabled = NO;
    }
    
    return _topMaskImgV;
}

- (HTmPlaceHolderTextView *)placeHolderTextView
{
    if (!_placeHolderTextView) {
        _placeHolderTextView = [[HTmPlaceHolderTextView alloc] init];
        _placeHolderTextView.editable   = NO;
        _placeHolderTextView.selectable = NO;
        
        _placeHolderTextView.placeholder =NSLocalizedString( @"请输入号码", nil);
        _placeHolderTextView.placeholderColor = [UIColor colorWithHex:0x000000 alpha:0.30];
        _placeHolderTextView.placeholderFont = [UIFont systemFontOfSize:R(14.f)];
        _placeHolderTextView.placeholderAlignment = NSTextAlignmentCenter;
        
        _placeHolderTextView.textColor = [UIColor colorWithHex:0x52cd9e];
        _placeHolderTextView.font = [UIFont boldSystemFontOfSize:R(22.f)];
        _placeHolderTextView.textAlignment = NSTextAlignmentCenter;
        
        _placeHolderTextView.textContainer.maximumNumberOfLines = 1;
        _placeHolderTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingHead;

        _placeHolderTextView.backgroundColor = [UIColor clearColor];

    }
    
    return _placeHolderTextView;
}

- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] init];
        
        [_deleteButton setImage:[UIImage imageNamed:@"ic_ _tab_delete"]
                       forState:UIControlStateNormal];
        [_deleteButton setImage:[HTmKeyboardTopView image:[UIImage imageNamed:@"ic_ _tab_delete"]
                                          byApplyingAlpha:0.50]
                       forState:UIControlStateHighlighted];
        
        _deleteButton.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,R(18.f));
        
        
        [_deleteButton addTarget:self action:@selector(onDeleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(onDeleteLongPressGR:)];
        [_deleteButton addGestureRecognizer:longPressGR];//长按 删除全部
    }
    
    return _deleteButton;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        
        _lineView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.10];
    }
    return _lineView;
}


#pragma mark - private method - Actions

- (void)onDeleteButtonAction:(UIButton *)sender
{
    // 删除按钮点击
    if (_deleteButtonBlock) {
        _deleteButtonBlock(self);
    }
}

- (void)onDeleteLongPressGR:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
//        DDLogVerbose(@"onDeleteLongPressGR: Long press detected.");
        
        // 长按 删除全部
        if (_longPressDeleteButtonBlock) {
            _longPressDeleteButtonBlock(self);
        }
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
//        DDLogVerbose(@"onDeleteLongPressGR: Long press Ended");
    }
    
}

- (void)onTapGR:(UITapGestureRecognizer *)sender
{
    // 点击打开keyboard
    if (_tapGestureOpenKeyboardBlock) {
        _tapGestureOpenKeyboardBlock(self);
    }
}

- (void)onPanGR:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint velocity = [sender velocityInView:self];
        
        if(velocity.y < 0)
        {
            NSLog(@"gesture went top");
            // 往上拖动打开keyboard
            if (_panGestureOpenKeyboardBlock) {
                _panGestureOpenKeyboardBlock(self);
            }
        }
        else
        {
            NSLog(@"gesture went down");
        }
    }
}

-(void)onCopyPasteLongPressGR:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
//        DDLogVerbose(@"onCopyPasteLongPressGR: Long press detected.");
        
        UIView *theView = self;
        
        CGPoint pt = [sender locationInView: theView];
        UIView *touched = [theView hitTest:pt withEvent:nil];
        
        if (
            [touched isDescendantOfView:_deleteButton]==NO
            &&
            [touched isDescendantOfView:self]==YES
           )
        {
            // 剪切版
            BOOL isCanPaste = NO;
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            NSString *pasteboardStr = pasteboard.string;
            // Remove non numeric characters from the phone number
            pasteboardStr = [[pasteboardStr componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""];
            // 删除 ｀空格｀
            pasteboardStr = [pasteboardStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if ([pasteboardStr length] > 0) {
                isCanPaste = YES;
            }else{
                isCanPaste = NO;
            }
            
            NSString *copyingPhoneNumber = _placeHolderTextView.text;
            if ([copyingPhoneNumber length] > 0) {// 拷贝、粘贴
                m_MenuPopOverView_Type = HTm_MenuPopOverView_Type_CopyPaste;
                
                MenuPopOverView *popOver = [[MenuPopOverView alloc] init];
                popOver.delegate = self;
                
                if (isCanPaste) {//可以｀粘贴｀
                    [popOver presentPopoverFromRect: CGRectMake(pt.x, pt.y, 0, 0)
                                             inView: theView
                                        withStrings: @[kString_MenuPopOver_Copy,kString_MenuPopOver_Paste]];// 拷贝、粘贴
                }else{//不可以｀粘贴｀
                    [popOver presentPopoverFromRect: CGRectMake(pt.x, pt.y, 0, 0)
                                             inView: theView
                                        withStrings: @[kString_MenuPopOver_Copy]];// 拷贝、粘贴
                }
                
            }else{// 粘贴
                
                if (isCanPaste) {//可以｀粘贴｀
                    m_MenuPopOverView_Type = HTm_MenuPopOverView_Type_Paste;
                    
                    MenuPopOverView *popOver = [[MenuPopOverView alloc] init];
                    popOver.delegate = self;
                    [popOver presentPopoverFromRect: CGRectMake(pt.x, pt.y, 0, 0)
                                             inView: theView
                                        withStrings: @[kString_MenuPopOver_Paste]];// 粘贴
                }else{//不可以｀粘贴｀
                    // do nothing here
                }
            }
        }
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
//        DDLogVerbose(@"onCopyPasteLongPressGR: Long press Ended");
    }
}


#pragma mark - <MenuPopOverViewDelegate>

- (void)popoverView:(MenuPopOverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
//    DDLogVerbose(@"select at %ld", (long)index);
    
    switch (m_MenuPopOverView_Type) {
        case HTm_MenuPopOverView_Type_None: // 0 默认
        {
            // do nothing
        }break;
    
        case HTm_MenuPopOverView_Type_Paste: // 粘贴
        {
            switch (index) {
                case 0:
                {//@"粘贴"
                    
                    // 剪切版
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    NSString *textAlreadyCopied = pasteboard.string;
                    
                    // Remove non numeric characters from the phone number
                    textAlreadyCopied = [[textAlreadyCopied componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""];
                    // 删除 ｀空格｀
                    textAlreadyCopied = [textAlreadyCopied stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    
                    if ([textAlreadyCopied length] > 0)
                    {
                        if (_popBubbleMenuPasteBlock) {//弹起气泡菜单，点击 “粘贴”：剪切板 粘贴
                            _popBubbleMenuPasteBlock(self, textAlreadyCopied);
                        }
                    }
                    
                }break;
                    
            //  状态机 不需要default
            //        default:
            //            break;
            }
            
        }break;
            
        case HTm_MenuPopOverView_Type_CopyPaste: // 拷贝、粘贴
        {
            switch (index) {
                case 0:
                {//@"拷贝"
                    
                    // 拷贝手机号
                    NSString *textToBeCopied = _placeHolderTextView.text;
                    
                    // 拷贝到剪切版
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    if ([textToBeCopied length] > 0) {
                        pasteboard.string = textToBeCopied;
                    }
                    
                }break;
                    
                case 1:
                {//@"粘贴"
                    
                    // 剪切版
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    NSString *textAlreadyCopied = pasteboard.string;
                    
                    // Remove non numeric characters from the phone number
                    textAlreadyCopied = [[textAlreadyCopied componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""];
                    // 删除 ｀空格｀
                    textAlreadyCopied = [textAlreadyCopied stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    
                    if ([textAlreadyCopied length] > 0)
                    {
                        if (_popBubbleMenuPasteBlock) {//弹起气泡菜单，点击 “粘贴”：剪切板 粘贴
                            _popBubbleMenuPasteBlock(self, textAlreadyCopied);
                        }
                    }
                    
                }break;
                    
            //  状态机 不需要default
            //        default:
            //            break;
            }
            
        }break;
            
//  状态机 不需要default
//        default:
//            break;
    }

}

- (void)popoverViewDidDismiss:(MenuPopOverView *)popoverView
{
//    DDLogVerbose(@"popOver dismissed.");
}



#pragma mark - helpers

/**
 给UIImage设置透明度
 */
+ (UIImage*)image:(UIImage *)aImage byApplyingAlpha:(CGFloat)alpha
{
    /**
     How to set the opacity/alpha of a UIImage?
     http://stackoverflow.com/questions/5084845/how-to-set-the-opacity-alpha-of-a-uiimage
     */
    
    UIGraphicsBeginImageContextWithOptions(aImage.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, aImage.size.width, aImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, aImage.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
