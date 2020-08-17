//
//  CertificatePasswordTextField.h
//  mobileshield
//
//  Created by 宋朝阳 on 2020/7/22.
//  Copyright © 2020 anxin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class CertificatePasswordTextField;

@protocol CPTextFieldDelegate <NSObject>

- (void)cpTextFieldDeleteBackward:(CertificatePasswordTextField *)textField;

@end

@interface CertificatePasswordTextField : UITextField

@property (nonatomic, assign) id <CPTextFieldDelegate> cp_delegate;

@end

NS_ASSUME_NONNULL_END
