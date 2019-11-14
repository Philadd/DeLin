//
//  RegisterViewController.m
//  MOWOX
//
//  Created by 安建伟 on 2018/12/14.
//  Copyright © 2018 yusz. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import <GizWifiSDK/GizWifiSDK.h>

@interface RegisterViewController () <UITextFieldDelegate,GizWifiSDKDelegate>

@property (nonatomic, strong) UITextField *emailTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UITextField *repeatpasswordTF;
@property (nonatomic, strong) UISwitch *agreeSwitch;
@property (nonatomic, strong) UIButton *RegisterBtn;

@property (nonatomic, strong) UILabel *agreeLabel;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0].CGColor;
    
    [self setNavItem];
    _emailTF = [self emailTF];
    _passwordTF = [self passwordTF];
    _repeatpasswordTF = [self repeatpasswordTF];
    _RegisterBtn = [self RegisterBtn];
    //_agreeSwitch = [self agreeSwitch];
    //_agreeLabel = [self agreeLabel];
    [GizWifiSDK sharedInstance].delegate = self;
    
}

- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Register");
}

- (UITextField *)emailTF{
    if (!_emailTF) {
        _emailTF = [[UITextField alloc] init];
        _emailTF.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _emailTF.font = [UIFont systemFontOfSize:16.f];
        _emailTF.tintColor = [UIColor colorWithHexString:@"333333"];
        _emailTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _emailTF.delegate = self;
        _emailTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _emailTF.borderStyle = UITextBorderStyleRoundedRect;
        [_emailTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_emailTF];
        [_emailTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(40)));
            make.top.equalTo(self.view.mas_top).offset(yAutoFit(200));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _emailTF.layer.borderWidth = 0.5;
        _emailTF.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _emailTF.layer.cornerRadius = 2.5f;
        _emailTF.placeholder = LocalString(@"e-mail");
    }
    return _emailTF;
}

- (UITextField *)passwordTF{
    if (!_passwordTF) {
        _passwordTF = [[UITextField alloc] init];
        _passwordTF.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _passwordTF.font = [UIFont systemFontOfSize:16.f];
        _passwordTF.tintColor = [UIColor colorWithHexString:@"333333"];
        _passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _passwordTF.delegate = self;
        _passwordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _passwordTF.borderStyle = UITextBorderStyleRoundedRect;
        [_passwordTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_passwordTF];
        [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(40)));
            make.top.equalTo(self.emailTF.mas_bottom).offset(yAutoFit(30));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _passwordTF.layer.borderWidth = 0.5;
        _passwordTF.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _passwordTF.layer.cornerRadius = 2.5f;
        _passwordTF.placeholder = LocalString(@"password");
        
    }
    return _passwordTF;
}

- (UITextField *)repeatpasswordTF{
    if (!_repeatpasswordTF) {
        _repeatpasswordTF = [[UITextField alloc] init];
        _repeatpasswordTF.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _repeatpasswordTF.font = [UIFont systemFontOfSize:16.f];
        _repeatpasswordTF.tintColor = [UIColor colorWithHexString:@"333333"];
        _repeatpasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _repeatpasswordTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _repeatpasswordTF.delegate = self;
        _repeatpasswordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _repeatpasswordTF.borderStyle = UITextBorderStyleRoundedRect;
        [_repeatpasswordTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_repeatpasswordTF];
        [_repeatpasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(40)));
            make.top.equalTo(self.passwordTF.mas_bottom).offset(yAutoFit(30));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _repeatpasswordTF.layer.borderWidth = 0.5;
        _repeatpasswordTF.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _repeatpasswordTF.layer.cornerRadius = 2.5f;
        _repeatpasswordTF.placeholder = LocalString(@"repeat password");
    }
    return _repeatpasswordTF;
}

- (UISwitch *)agreeSwitch{
    if (!_agreeSwitch) {
        _agreeSwitch = [[UISwitch alloc]init];
        [_agreeSwitch setThumbTintColor:[UIColor whiteColor]];
        _agreeSwitch.layer.cornerRadius = 15.5f;
        _agreeSwitch.layer.masksToBounds = YES;
        [_agreeSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_agreeSwitch];
        [_agreeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(60), yAutoFit(30)));
            make.top.equalTo(self.repeatpasswordTF.mas_bottom).offset(yAutoFit(30));
            make.leftMargin.mas_equalTo(self.repeatpasswordTF.mas_leftMargin);
        }];
    }
    return _agreeSwitch;
}

- (UILabel *)agreeLabel{
    if (!_agreeLabel) {
        _agreeLabel = [[UILabel alloc] init];
        _agreeLabel.font = [UIFont systemFontOfSize:15.f];
        _agreeLabel.backgroundColor = [UIColor clearColor];
        _agreeLabel.textColor = [UIColor whiteColor];
        _agreeLabel.textAlignment = NSTextAlignmentLeft;
        _agreeLabel.text = LocalString(@"I agree to the Terms of Use");
        [self.view addSubview:_agreeLabel];
        [_agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(300), yAutoFit(20)));
            make.left.equalTo(self.agreeSwitch.mas_right).offset(yAutoFit(15));
            make.top.equalTo(self.repeatpasswordTF.mas_bottom).offset(yAutoFit(30));
        }];
    }
    return _agreeLabel;
}

- (UIButton *)RegisterBtn{
    if (!_RegisterBtn) {
        _RegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_RegisterBtn setTitle:LocalString(@"Register") forState:UIControlStateNormal];
        [_RegisterBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_RegisterBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_RegisterBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.6f]];
        [_RegisterBtn addTarget:self action:@selector(registerLogin) forControlEvents:UIControlEventTouchUpInside];
        _RegisterBtn.enabled = YES;
        [self.view addSubview:_RegisterBtn];
        [_RegisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(50)));
            make.top.equalTo(self.repeatpasswordTF.mas_bottom).offset(yAutoFit(45));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        _RegisterBtn.layer.borderWidth = 0.5;
        _RegisterBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _RegisterBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _RegisterBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _RegisterBtn.layer.shadowRadius = 3;
        _RegisterBtn.layer.shadowOpacity = 1;
        _RegisterBtn.layer.cornerRadius = 2.5;
    }
    return _RegisterBtn;
}

//监听文本框事件
- (void)textFieldTextChange:(UITextField *)textField{
    if ( _repeatpasswordTF.text.length > 0 && _passwordTF.text.length > 0){
        [_RegisterBtn setBackgroundColor:[UIColor colorWithRed:71/255.0 green:120/255.0 blue:204/255.0 alpha:1]];
        _RegisterBtn.enabled = YES;
    }else{
        [_RegisterBtn setBackgroundColor:[UIColor colorWithRed:71/255.0 green:120/255.0 blue:204/255.0 alpha:0.4]];
        _RegisterBtn.enabled = NO;
    }
}

#pragma mark - resign keyboard control

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.emailTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.repeatpasswordTF resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// 实现回调
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didRegisterUser:(NSError *)result uid:(NSString *)uid token:(NSString *)token {
    if(result.code == GIZ_SDK_SUCCESS) {
        // 注册成功
        NSLog(@"注册成功");
        [NSObject showHudTipStr:LocalString(@"Registration successful")];
        //返回上一级视图
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        // 注册失败
        NSLog(@"注册失败");
        [NSObject showHudTipStr:LocalString(@"Registration failed")];
        NSLog(@"注册失败%@",result);
        //[NSObject showHudTipStr3:[NSString stringWithFormat:@"%@",result]];
        
    }
    
}

-(void)switchAction{
    
    NSLog(@"tt");
    
}

-(void)registerLogin{
    NSLog(@"注册");
    if (!(_passwordTF.text == _repeatpasswordTF.text)) {
        [NSObject showHudTipStr:LocalString(@"Two input is inconsistent")];
    }else{
        [[GizWifiSDK sharedInstance] registerUser:_emailTF.text password:_passwordTF.text verifyCode:nil accountType:GizUserEmail];
    }
    
}

@end
