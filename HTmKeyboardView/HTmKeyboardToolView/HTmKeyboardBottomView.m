//
//  HTmKeyboardBottomView.m
//  HTmKeyboardView-Demo
//
//  Created by OYXJ on 16/04/26.
//  Copyright (c) 2016年 [OYXJlucky@163.com] All rights reserved.
//

#import "HTmKeyboardBottomView.h"

#import "UIImage+ImageWithColor.h"


@implementation HTmKeyboardBottomView



#pragma mark - life cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview: [self videoButton] ];
        [self addSubview: [self audioButton] ];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /*
    float w      = R(137.0);
    float spaceX = R(15.0);
    
    float h         = R(36.0);
    float topMargin = R(11.0);
    */
    
    /**
     根据iPhone5S 的标注 来适配
     */
    float width      = CGRectGetWidth(self.frame) * (137.0/320.0);
    float spaceX     = CGRectGetWidth(self.frame) * (15.0 /320.0);
    float leftMargin = CGRectGetWidth(self.frame) * (1 - (137.0+15.0+137.0)/320.0 ) / 2.0;
    
    float height    = CGRectGetHeight(self.frame) * (  36.0/58.0);
    float topMargin = CGRectGetHeight(self.frame) * (1-36.0/58.0) / 2.0;
    
    _videoButton.frame = CGRectMake(leftMargin,
                                    topMargin,
                                    width,
                                    height);
    _audioButton.frame = CGRectMake(leftMargin + width + spaceX,
                                    topMargin,
                                    width,
                                    height);
    
    _videoButton.layer.cornerRadius = height/2.0f;
    _videoButton.layer.masksToBounds = YES;
    
    _audioButton.layer.cornerRadius = height/2.0f;
    _audioButton.layer.masksToBounds = YES;
}



#pragma mark - getters

- (UIButton *)videoButton
{
    if (!_videoButton) {
        _videoButton = [[UIButton alloc] init];
        
        
        [_videoButton setBackgroundImage:[UIImage imageWithColor:SystemGray]
                                forState:UIControlStateNormal];
        [_videoButton setBackgroundImage:[UIImage imageWithColor:SystemOrange]
                                forState:UIControlStateHighlighted];
        
        [_videoButton setImage:[UIImage imageNamed:@"btn_ _dial_video"]
                      forState:UIControlStateNormal];
        [_videoButton setImage:[UIImage imageNamed:@"btn_ _dial_video"]
                      forState:UIControlStateHighlighted];
    
    }
    
    return _videoButton;
}


- (UIButton *)audioButton
{
    if (!_audioButton) {
        _audioButton = [[UIButton alloc] init];
        
        
        [_audioButton setBackgroundImage:[UIImage imageWithColor:SystemGray]
                                forState:UIControlStateNormal];
        [_audioButton setBackgroundImage:[UIImage imageWithColor:SystemYellow]
                                forState:UIControlStateHighlighted];
        
        [_audioButton setImage:[UIImage imageNamed:@"btn_ _dial_voice"]
                      forState:UIControlStateNormal];
        [_audioButton setImage:[UIImage imageNamed:@"btn_ _dial_voice"]
                      forState:UIControlStateHighlighted];
         
    }
    
    return _audioButton;
}


@end
