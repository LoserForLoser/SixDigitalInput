//
//  ViewController.m
//  SixDigitalInputTest
//
//  Created by 宋朝阳 on 2020/8/16.
//  Copyright © 2020 宋朝阳. All rights reserved.
//

#import "ViewController.h"
#import "CertificatePasswordTextField.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITextFieldDelegate, CPTextFieldDelegate>

@property (nonatomic, strong) CertificatePasswordTextField *oneText;
@property (nonatomic, strong) CertificatePasswordTextField *twoText;
@property (nonatomic, strong) CertificatePasswordTextField *threeText;
@property (nonatomic, strong) CertificatePasswordTextField *fourText;
@property (nonatomic, strong) CertificatePasswordTextField *fiveText;
@property (nonatomic, strong) CertificatePasswordTextField *sixText;

@property (nonatomic, strong) NSMutableArray *passwordArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 此处初始化防止后面输入后数组添加失败
    self.passwordArray = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", @"", nil];
    
    [self customView];
}

#pragma mark - UIView

- (void)customView {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 100, 100, 20)];
    titleLabel.text = @"输入验证码";
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [self.view addSubview:titleLabel];
    
    self.oneText = [self passwordTextField];
    self.oneText.frame = CGRectMake(24, 150, 20, 30);
    
    self.twoText = [self passwordTextField];
    self.twoText.frame = CGRectMake(54, 150, 20, 30);
    
    self.threeText = [self passwordTextField];
    self.threeText.frame = CGRectMake(84, 150, 20, 30);
    
    self.fourText = [self passwordTextField];
    self.fourText.frame = CGRectMake(114, 150, 20, 30);
    
    self.fiveText = [self passwordTextField];
    self.fiveText.frame = CGRectMake(144, 150, 20, 30);
    
    self.sixText = [self passwordTextField];
    self.sixText.frame = CGRectMake(174, 150, 20, 30);
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(50, 300, 150, 44);
    [confirmButton setTitle:@"确  认" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
}

- (CertificatePasswordTextField *)passwordTextField {
    CertificatePasswordTextField *textField = [CertificatePasswordTextField new];
    textField.delegate = self;
    textField.cp_delegate = self;
    [textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:textField];
    return textField;
}

#pragma mark - Text Field Notification

- (void)changedTextField:(UITextField *)textField {
    // 使 shouldChangeCharactersInRange 为当前第一响应者 textfield，否则输入判断获取的是当前响应者的前一位造成 array 数据错误
    if ([textField isEqual:self.oneText]) {
        [self.twoText becomeFirstResponder];
    } else if ([textField isEqual:self.twoText]) {
        [self.threeText becomeFirstResponder];
    } else if ([textField isEqual:self.threeText]) {
        [self.fourText becomeFirstResponder];
    } else if ([textField isEqual:self.fourText]) {
        [self.fiveText becomeFirstResponder];
    } else if ([textField isEqual:self.fiveText]) {
        [self.sixText becomeFirstResponder];
    }
}

#pragma mark - CP Text Field Delegate

- (void)cpTextFieldDeleteBackward:(CertificatePasswordTextField *)textField {
    // 若输入中断再次输入时可以立即定位并唤起正确第一响应者
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"";
        if ([textField isEqual:self.sixText]) {
            [self.fiveText becomeFirstResponder];
        } else if ([textField isEqual:self.fiveText]) {
            [self.fourText becomeFirstResponder];
        } else if ([textField isEqual:self.fourText]) {
            [self.threeText becomeFirstResponder];
        } else if ([textField isEqual:self.threeText]) {
            [self.twoText becomeFirstResponder];
        } else if ([textField isEqual:self.twoText]) {
            [self.oneText becomeFirstResponder];
        }
    }
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // 若当前 textfield 有输入内容则变色
    if ([textField isEqual:self.oneText] && self.twoText.text.length < 1) {
        textField.alpha = 1;
           return YES;
    } else if ([textField isEqual:self.twoText] && self.threeText.text.length < 1) {
        if (self.oneText.text.length > 0) {
            textField.alpha = 1;
            return YES;
        }
    } else if ([textField isEqual:self.threeText] && self.fourText.text.length < 1) {
        if (self.twoText.text.length > 0) {
            textField.alpha = 1;
            return YES;
        }
    } else if ([textField isEqual:self.fourText] && self.fiveText.text.length < 1) {
        if (self.threeText.text.length > 0) {
            textField.alpha = 1;
            return YES;
        }
    } else if ([textField isEqual:self.fiveText] && self.sixText.text.length < 1) {
        if (self.fourText.text.length > 0) {
            textField.alpha = 1;
            return YES;
        }
    } else if ([textField isEqual:self.sixText]) {
        if (self.fiveText.text.length > 0) {
            textField.alpha = 1;
            return YES;
        }
    }
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    // 根据输入判断是否改变 layer 颜色
    if (textField.text.length > 0) {
        textField.alpha = 1;
    } else {
        textField.alpha = 0.3;
    }
    if (textField.text.length > 1) {
        // 经测试 iOS13 以上在通过键盘一次性多位输入会出现第一个 TexitField 多位输入
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 1)];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length < 1 || [string isEqualToString:@""]) {
        // 对 textfield 应位 array 输入记录
        if ([textField isEqual:self.oneText]) {
            [self.passwordArray replaceObjectAtIndex:0 withObject:string];
        } else if ([textField isEqual:self.twoText]) {
            [self.passwordArray replaceObjectAtIndex:1 withObject:string];
        } else if ([textField isEqual:self.threeText]) {
            [self.passwordArray replaceObjectAtIndex:2 withObject:string];
        } else if ([textField isEqual:self.fourText]) {
            [self.passwordArray replaceObjectAtIndex:3 withObject:string];
        } else if ([textField isEqual:self.fiveText]) {
            [self.passwordArray replaceObjectAtIndex:4 withObject:string];
        } else if ([textField isEqual:self.sixText]) {
            [self.passwordArray replaceObjectAtIndex:5 withObject:string];
        }
        return YES;
    }
    // 若输入中断再次输入时可以立即定位并唤起正确第一响应者
    if ([textField isEqual:self.oneText]) {
        self.twoText.text = string;
        [self.twoText becomeFirstResponder];
    } else if ([textField isEqual:self.twoText]) {
        self.threeText.text = string;
        [self.threeText becomeFirstResponder];
    } else if ([textField isEqual:self.threeText]) {
        self.fourText.text = string;
        [self.fourText becomeFirstResponder];
    } else if ([textField isEqual:self.fourText]) {
        self.fiveText.text = string;
        [self.fiveText becomeFirstResponder];
    } else if ([textField isEqual:self.fiveText]) {
        self.sixText.text = string;
        [self.sixText becomeFirstResponder];
    }
    return NO;
}

#pragma mark - UIResponder Action
// 系统自带方法取消第一响应者
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.oneText resignFirstResponder];
    [self.twoText resignFirstResponder];
    [self.threeText resignFirstResponder];
    [self.fourText resignFirstResponder];
    [self.fiveText resignFirstResponder];
    [self.sixText resignFirstResponder];
}

#pragma mark - Action

- (void)confirmPassword {
    NSString *passwordString = [self.passwordArray componentsJoinedByString:@""];
    if (!passwordString.length) {
        NSLog(@"请输入验证码");
        return;
    }
    if (passwordString.length < 6) {
        NSLog(@"请输入六位验证码");
        return;
    }
    NSLog(@"输入验证码/密码为：%@", passwordString);
}

@end