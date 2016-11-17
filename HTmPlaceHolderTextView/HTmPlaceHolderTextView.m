//
//  HTmPlaceHolderTextView.m
//  HTmKeyboardView-Demo
//
//  Created by OYXJ on 16/03/28.
//  Copyright (c) 2016年 OYXJ. All rights reserved.
//

#import "HTmPlaceHolderTextView.h"


/**
 Placeholder in UITextView
 
 http://stackoverflow.com/questions/1328638/placeholder-in-uitextview?page=1&tab=votes#tab-top
 */


/**
 Enable copy and paste on UITextField without making it editable
 
 http://stackoverflow.com/questions/1920541/enable-copy-and-paste-on-uitextfield-without-making-it-editable
 */


@interface HTmPlaceHolderTextView ()
@property (nonatomic, strong) UILabel *placeHolderLabel;
@end


@implementation HTmPlaceHolderTextView


#pragma mark - life cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Use Interface Builder User Defined Runtime Attributes to set
    // placeholder and placeholderColor in Interface Builder.
    if (!self.placeholder) {
        [self setPlaceholder:@""];
    }
    
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onTextViewTextDidChangeNotification:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onTextViewTextDidChangeNotification:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
    }
    return self;
}



#pragma mark - Override

/**
 *  Override setter  setText
 */
- (void)setText:(NSString *)text {
    [super setText:text];
    [self onTextViewTextDidChangeNotification:nil];
}

/**
 *  Override setText
 */
- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if (_placeHolderLabel == nil )
        {
            CGFloat fontSize = self.placeholderFont?self.placeholderFont.pointSize:self.font.pointSize;
            CGFloat y = 12;
            if (self.placeholderAlignment == NSTextAlignmentCenter) {
                CGFloat yY = ( CGRectGetHeight(self.bounds) - (fontSize+2) ) / 2;
                y = MAX(y, yY);
            }
            
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,
                                                                          y,
                                                                          self.bounds.size.width-32,
                                                                          fontSize+2)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            if (self.placeholderFont) {
                _placeHolderLabel.font = self.placeholderFont;
            }else{
                _placeHolderLabel.font = self.font;
            }
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        
        _placeHolderLabel.text = self.placeholder;
        _placeHolderLabel.textAlignment = self.placeholderAlignment;
        
        /** [_placeHolderLabel sizeToFit]; **/
        {//[begin] --- 文本 换行时 调整 Label高度
            NSString *inputString = self.placeholder;
            UIFont *font = _placeHolderLabel.font;
            CGSize inputSize = _placeHolderLabel.bounds.size;
            
            CGSize result;
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
            NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine |
                                                NSStringDrawingUsesLineFragmentOrigin |
                                                NSStringDrawingUsesFontLeading;
            CGRect rect1=[inputString boundingRectWithSize:inputSize
                                                   options:options
                                                attributes:dic
                                                   context:nil];
            result=rect1.size;
            
            if (
                result.height >= _placeHolderLabel.bounds.size.height * 2    //高度 两行
                ||
                [inputString rangeOfString:@"\n"].location != NSNotFound    //换行 字符串
               )
            {//是否需要换行
                [_placeHolderLabel sizeToFit];
            }else{
                // do nothing
            }
        }//[end] --- 文本 换行时 调整 Label高度
    
        
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}



#pragma mark - Notification

- (void)onTextViewTextDidChangeNotification:(NSNotification *)notification
{
    if (_textChangeBlock) {
        _textChangeBlock(self, [self text]);
    }
    
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}


@end
