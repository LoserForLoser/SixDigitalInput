//
//  CertificatePasswordTextField.m
//  mobileshield
//
//  Created by 宋朝阳 on 2020/7/22.
//  Copyright © 2020 anxin. All rights reserved.
//

#import "CertificatePasswordTextField.h"

@implementation CertificatePasswordTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.keyboardType = UIKeyboardTypeNumberPad;
        [self setTintColor:[UIColor clearColor]]; // 光标隐藏，可根据需要设置
        self.alpha = 0.3;
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blueColor].CGColor;
    }
    return self;
}

- (void)deleteBackward {
    [super deleteBackward];
    if ([self.cp_delegate respondsToSelector:@selector(cpTextFieldDeleteBackward:)]) {
        [self.cp_delegate cpTextFieldDeleteBackward:self];
    }
}

@end
