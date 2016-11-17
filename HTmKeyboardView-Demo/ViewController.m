//
//  ViewController.m
//  HTmKeyboardView-Demo
//
//  Created by OYXJ on 2016/11/17.
//  Copyright © 2016年 OYXJ. All rights reserved.
//

#import "ViewController.h"

#import "HTmKeyboard.h"

@interface ViewController ()
{
    HTmKeyboardView *mBoardView;
    BOOL mIsShow;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self demo:YES];
        self->mIsShow = YES;
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    mIsShow = !mIsShow;
    [self demo: mIsShow];
}

- (void)demo:(BOOL)isShow
{
    if (isShow) {
        [[self mainUI_initialize_htmKeyboardView]
         showInView:[self view]
         animateWithDuration:-100
         animated:YES
         overlapTabbar:YES];
    }else{
        [mBoardView remove];
    }
}


/**
 自定义键盘 (getter方法)
 */
- (HTmKeyboardView *)mainUI_initialize_htmKeyboardView
{
    if (mBoardView) {
        return mBoardView;
    }
    
    __weak __typeof(self) weakSelf = self;
    
    
    HTmKeyboardTopView *kbTopView = [[HTmKeyboardTopView alloc]
                                     initWithFrame:CGRectMake( 0, 0, [self.view window].frame.size.width, R(43) )];
    HTmKeyboardBottomView *kbBottomView = [[HTmKeyboardBottomView alloc]
                                           initWithFrame:CGRectMake(0, 0, [self.view window].frame.size.width, R(58))];
    
//    [kbBottomView.videoButton addTarget:self action:@selector(onVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [kbBottomView.audioButton addTarget:self action:@selector(onAudioButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    HTmKeyboardView *htmKeyboardView = [[HTmKeyboardView alloc] initWithDelegate:nil
                                                                    topToolsView:kbTopView
                                                                 bottomToolsView:kbBottomView
                                                      showDefaultBottomToolsView:NO];
    
    __weak __typeof(kbTopView) _weak_kbTopView = kbTopView;
    htmKeyboardView.inputStringChangedBlock = ^(HTmKeyboardView *theKeyboardView, NSString *totalInputString) {
        __strong __typeof(_weak_kbTopView) _strong_kbTopView = _weak_kbTopView;
        __strong __typeof(weakSelf)         strongSelf       = weakSelf;
        
        
        _strong_kbTopView.placeHolderTextView.text = totalInputString;
        
        
        {////
//            [strongSelf setHtmKeyboardViewTotalInputString: totalInputString];
        }////
        
//        DDLogVerbose(@"%@,%@  %@  %@", THIS_FILE,THIS_METHOD, @"htmKeyboardView.inputStringChangedBlock", totalInputString);
    };
    
    __weak __typeof(htmKeyboardView) _weak_keyboardView = htmKeyboardView;
    /*
     kbTopView.closeKeyboardBlock = ^(HTmKeyboardTopView *theHTmKeyboardTopView){
     __strong __typeof(_weak_keyboardView) _strong_keyboardView = _weak_keyboardView;
     
     [_strong_keyboardView remove];
     };
     */
    kbTopView.deleteButtonBlock = ^(HTmKeyboardTopView *theHTmKeyboardTopView){//点击删除按钮
        __strong __typeof(_weak_keyboardView) _strong_keyboardView  = _weak_keyboardView;
        __strong __typeof(weakSelf)            strongSelf           = weakSelf;
        
        NSString *currentInputText = [theHTmKeyboardTopView.placeHolderTextView.text copy];
        if (currentInputText.length>=1) {
            currentInputText = [currentInputText substringToIndex:currentInputText.length-1];//删除最后一个字符
            
            
            theHTmKeyboardTopView.placeHolderTextView.text = currentInputText;
            
            [_strong_keyboardView setupHTmKeyboardViewTotalInputString:currentInputText];
            
            
            {////
//                [strongSelf setHtmKeyboardViewTotalInputString: currentInputText];
                NSDictionary *notifyDic = @{HTmKeyboardView_NotificationUserInfoKEY_TotalInputString
                                            :
                                            currentInputText.length?currentInputText:@""
                                            };
                [[NSNotificationCenter defaultCenter] postNotificationName:HTmKeyboardView_NotificationName_InputString_DidChangeNotification
                                                                    object:nil
                                                                  userInfo:notifyDic];
            }////
            
//            DDLogVerbose(@"%@,%@  %@  %@", THIS_FILE,THIS_METHOD, @"kbTopView.deleteButtonBlock", currentInputText);
        }
    };
    kbTopView.longPressDeleteButtonBlock = ^(HTmKeyboardTopView *theHTmKeyboardTopView){//长按删除按钮
        __strong __typeof(_weak_keyboardView) _strong_keyboardView  = _weak_keyboardView;
        __strong __typeof(weakSelf)             strongSelf          = weakSelf;
        
        
        theHTmKeyboardTopView.placeHolderTextView.text = @"";
        
        [_strong_keyboardView setupHTmKeyboardViewTotalInputString:@""];
        
        
        {////
//            [strongSelf setHtmKeyboardViewTotalInputString: @""];
            NSDictionary *notifyDic = @{HTmKeyboardView_NotificationUserInfoKEY_TotalInputString
                                        :
                                        @""
                                        };
            [[NSNotificationCenter defaultCenter] postNotificationName:HTmKeyboardView_NotificationName_InputString_DidChangeNotification
                                                                object:nil
                                                              userInfo:notifyDic];
        }////
        
//        DDLogVerbose(@"%@,%@  %@  %@", THIS_FILE,THIS_METHOD, @"kbTopView.longPressDeleteButtonBlock", @"");
    };
    kbTopView.popBubbleMenuPasteBlock = ^(HTmKeyboardTopView *theHTmKeyboardTopView, NSString *pastedString) {
        // 弹起气泡菜单，点击 “粘贴”：剪切板 粘贴
        __strong __typeof(_weak_keyboardView) _strong_keyboardView  = _weak_keyboardView;
        __strong __typeof(weakSelf)             strongSelf          = weakSelf;
        
        if ([pastedString length] > 0)
        {
            theHTmKeyboardTopView.placeHolderTextView.text = pastedString;
            
            [_strong_keyboardView setupHTmKeyboardViewTotalInputString:pastedString];
            
            
            {////
//                [strongSelf setHtmKeyboardViewTotalInputString: pastedString];
                NSDictionary *notifyDic = @{HTmKeyboardView_NotificationUserInfoKEY_TotalInputString
                                            :
                                            pastedString
                                            };
                [[NSNotificationCenter defaultCenter] postNotificationName:HTmKeyboardView_NotificationName_InputString_DidChangeNotification
                                                                    object:nil
                                                                  userInfo:notifyDic];
            }////
            
//            DDLogVerbose(@"%@,%@  %@  %@", THIS_FILE,THIS_METHOD, @"kbTopView.popBubbleMenuPasteBlock", pastedString);
        }else{
//            DDLogVerbose(@"%@,%@  %@  %@  %@", THIS_FILE,THIS_METHOD, @"kbTopView.popBubbleMenuPasteBlock", pastedString,@"粘贴字符为空");
        }
    };
    
    
    kbTopView.panGestureOpenKeyboardBlock = ^(HTmKeyboardTopView *theHTmKeyboardTopView){//往上拖动打开keyboard
        __strong __typeof(_weak_keyboardView) _strong_keyboardView  = _weak_keyboardView;
        //__strong __typeof(weakSelf)             strongSelf          = weakSelf;
        
        UIView *kbSuperV = [_strong_keyboardView superview];
        [_strong_keyboardView showInView:kbSuperV overlapTabbar:YES];
        
//        DDLogVerbose(@"%@,%@  %@  %@", THIS_FILE,THIS_METHOD, @"kbTopView.panGestureOpenKeyboardBlock", @"");
    };
    kbTopView.tapGestureOpenKeyboardBlock = ^(HTmKeyboardTopView *theHTmKeyboardTopView){//点击打开keyboard
        __strong __typeof(_weak_keyboardView) _strong_keyboardView  = _weak_keyboardView;
        //__strong __typeof(weakSelf)             strongSelf          = weakSelf;
        
        UIView *kbSuperV = [_strong_keyboardView superview];
        [_strong_keyboardView showInView:kbSuperV overlapTabbar:YES];
        
//        DDLogVerbose(@"%@,%@  %@  %@", THIS_FILE,THIS_METHOD, @"kbTopView.tapGestureOpenKeyboardBlock", @"");
    };
    
    
    /*** [htmKeyboardView showInView: self.view]; ***/
    
    mBoardView = htmKeyboardView;
    
    return htmKeyboardView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
