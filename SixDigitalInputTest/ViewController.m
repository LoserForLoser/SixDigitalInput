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

@property (nonatomic, strong) NSMutableArray *textFieldArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self customView];
}

#pragma mark - UIView

- (void)customView {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 100, 100, 20)];
    titleLabel.text = @"输入验证码";
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [self.view addSubview:titleLabel];
    
    CertificatePasswordTextField *oneText = [self passwordTextField];
    oneText.frame = CGRectMake(24, 150, 20, 30);
    
    CertificatePasswordTextField *twoText = [self passwordTextField];
    twoText.frame = CGRectMake(54, 150, 20, 30);
    
    CertificatePasswordTextField *threeText = [self passwordTextField];
    threeText.frame = CGRectMake(84, 150, 20, 30);
    
    CertificatePasswordTextField *fourText = [self passwordTextField];
    fourText.frame = CGRectMake(114, 150, 20, 30);
    
    CertificatePasswordTextField *fiveText = [self passwordTextField];
    fiveText.frame = CGRectMake(144, 150, 20, 30);
    
    CertificatePasswordTextField *sixText = [self passwordTextField];
    sixText.frame = CGRectMake(174, 150, 20, 30);
    
    self.textFieldArray = [NSMutableArray arrayWithObjects:oneText, twoText, threeText, fourText, fiveText, sixText, nil];
    
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
    // 使 shouldChangeCharactersInRange 为当前第一响应者 textfield，否则输入判断获取的是当前响应者的前一位
    for (NSInteger count = 0; count < self.textFieldArray.count - 1; count++) {
        UITextField *nowTextField = self.textFieldArray[count];
        UITextField *afterTextField = self.textFieldArray[count + 1];
        if ([textField isEqual:nowTextField]) {
            [afterTextField becomeFirstResponder];
            break;
        }
    }
}

#pragma mark - CP Text Field Delegate

- (void)cpTextFieldDeleteBackward:(CertificatePasswordTextField *)textField {
    // 若输入中断再次输入时可以立即定位并唤起正确第一响应者
    if (!textField.text.length) {
        for (NSInteger count = self.textFieldArray.count - 1; count > 0; count--) {
            UITextField *nowTextField = self.textFieldArray[count];
            UITextField *beforeTextField = self.textFieldArray[count - 1];
            if ([textField isEqual:nowTextField]) {
                [beforeTextField becomeFirstResponder];
                break;
            }
        }
    }
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // 点击任意 textfield 确保唤起最前无内容 textfield
    for (NSInteger count = self.textFieldArray.count - 1; count > 0; count--) {
        UITextField *nowTextField = self.textFieldArray[count];
        UITextField *beforeTextField = self.textFieldArray[count - 1];
        if ([textField isEqual:nowTextField] && !beforeTextField.text.length) {
            [beforeTextField becomeFirstResponder];
            break;
        }
    }
    // 若当前 textfield 有输入内容则变色
    for (NSInteger count = 0; count < self.textFieldArray.count; count++) {
        UITextField *beforeTextField = (count == 0) ? nil : self.textFieldArray[count - 1];
        UITextField *nowTextField = self.textFieldArray[count];
        UITextField *afterTextField = (count == self.textFieldArray.count - 1) ? nil : self.textFieldArray[count + 1];
        if ([textField isEqual:nowTextField] && !afterTextField.text.length) {
            if (!beforeTextField || beforeTextField.text.length) {
                textField.alpha = 1;
                return YES;
            }
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
    // 此处判断配合 textFieldShouldBeginEditing 点击任意 textfield 确保唤起最前无内容 textfield
    if (textField.text.length < 1 || [string isEqualToString:@""]) {
        return YES;
    }
    // 若输入中断再次输入时可以立即定位并唤起正确第一响应者
    for (NSInteger count = 0; count < self.textFieldArray.count - 1; count++) {
        UITextField *nowTextField = self.textFieldArray[count];
        UITextField *afterTextField = self.textFieldArray[count + 1];
        if ([textField isEqual:nowTextField]) {
            afterTextField.text = string;
            [afterTextField becomeFirstResponder];
            break;
        }
    }
    return NO;
}

#pragma mark - UIResponder Action
// 系统自带方法取消第一响应者
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITextField *textField in self.textFieldArray) {
        [textField resignFirstResponder];
    }
}

#pragma mark - Action

- (void)confirmPassword {
    NSMutableArray *passwordArray = [NSMutableArray array];
    for (UITextField *textField in self.textFieldArray) {
        [passwordArray addObject:textField.text];
    }
    NSString *passwordString = [passwordArray componentsJoinedByString:@""];
    NSString *messageStr;
    if (!passwordString.length) {
        messageStr = @"请输入验证码";
    } else if (passwordString.length < 6) {
        messageStr = @"请输入六位验证码";
    } else {
        messageStr = [NSString stringWithFormat:@"输入验证码/密码为：%@", passwordString];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示⚠️" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:confirm];
}

@end
