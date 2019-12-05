//
//  LoginViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/10/22.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetpasswordViewController.h"
#import "DeviceListViewController.h"
#import "AAEmailTextField.h"
#import "AAPasswordTF.h"

@interface LoginViewController ()<UITextFieldDelegate,GizWifiSDKDelegate>

@property (nonatomic, strong) UIView *labelBgView;
@property (nonatomic, strong) AAEmailTextField *emailModelTF;
@property (nonatomic, strong) AAPasswordTF *passwordModelTF;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *forgetPWBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
    
    _labelBgView = [self labelBgView];
    [self setNavItem];
    [self setUItextField];
    _loginBtn = [self loginBtn];
    _forgetPWBtn = [self forgetPWBtn];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [GizWifiSDK sharedInstance].delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - setters and getters

- (void)setNavItem{
    self.navigationItem.title = LocalString(@"LOGIN");
}

- (UIView *)labelBgView{
    if (!_labelBgView) {
        _labelBgView = [[UIView alloc] initWithFrame:CGRectMake( 0 , getRectNavAndStatusHight + yAutoFit(20), ScreenWidth,yAutoFit(180))];
        _labelBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_labelBgView];
        
        UILabel *welcomelabel = [[UILabel alloc] init];
        welcomelabel.text = LocalString(@"Your personal information");
        welcomelabel.font = [UIFont systemFontOfSize:25.f];
        welcomelabel.textColor = [UIColor whiteColor];
        welcomelabel.textAlignment = NSTextAlignmentCenter;
        welcomelabel.adjustsFontSizeToFitWidth = YES;
        [self.labelBgView addSubview:welcomelabel];
        [welcomelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth , yAutoFit(30)));
            make.centerX.equalTo(self.labelBgView.mas_centerX);
            make.top.equalTo(self.labelBgView.mas_top);
        }];
        
        UILabel *tiplabel = [[UILabel alloc] init];
        tiplabel.text = LocalString(@"Please enter your email address and password");
        tiplabel.font = [UIFont systemFontOfSize:16.f];
        tiplabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];;
        tiplabel.numberOfLines = 0;
        tiplabel.textAlignment = NSTextAlignmentCenter;
        tiplabel.adjustsFontSizeToFitWidth = YES;
        [self.labelBgView addSubview:tiplabel];
        [tiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(100)));
            make.centerX.equalTo(self.labelBgView.mas_centerX);
            make.top.equalTo(welcomelabel.mas_bottom).offset(yAutoFit(10.f));
        }];
        
    }
    return _labelBgView;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:LocalString(@"Submit") forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:[UIColor colorWithRed:220/255.0 green:168/255.0 blue:11/255.0 alpha:1.f]];
        [_loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.enabled = YES;
        [self.view addSubview:_loginBtn];
        [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(45)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _loginBtn.layer.borderWidth = 0.5;
        _loginBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _loginBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _loginBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _loginBtn.layer.shadowRadius = 3;
        _loginBtn.layer.shadowOpacity = 1;
        _loginBtn.layer.cornerRadius = 2.5;
    }
    return _loginBtn;
}

- (UIButton *)forgetPWBtn{
    if (!_forgetPWBtn) {
        _forgetPWBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPWBtn setTitle:LocalString(@"Forgot password？") forState:UIControlStateNormal];
        [_forgetPWBtn setTitleColor:[UIColor colorWithHexString:@"FDA31A"] forState:UIControlStateNormal];
        [_forgetPWBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [_forgetPWBtn addTarget:self action:@selector(forgetPW) forControlEvents:UIControlEventTouchUpInside];
        //_forgetPWBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:_forgetPWBtn];
        [_forgetPWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(150), yAutoFit(20)));
            make.top.equalTo(self.loginBtn.mas_bottom).offset(yAutoFit(400));
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }
    return _forgetPWBtn;
}

#pragma mark - UITextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.emailModelTF.inputText && textField.text.length <= 0) {
        [self.emailModelTF emailTFBeginEditing];
    }
    if (textField == self.passwordModelTF.inputText && textField.text.length <= 0) {
        [self.passwordModelTF passwordTFBeginEditing];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.emailModelTF.inputText && textField.text.length <= 0) {
        [self.emailModelTF emailTFEndEditing];
    }
    if (textField == self.passwordModelTF.inputText && textField.text.length <= 0) {
        [self.passwordModelTF passwordTFEndEditing];
    }
}

#pragma mark - Actions

- (void)setUItextField{
    
    CGRect emailF = CGRectMake(yAutoFit(15), getRectNavAndStatusHight + yAutoFit(200), yAutoFit(320), yAutoFit(60));
    
    self.emailModelTF = [[AAEmailTextField alloc]initWithFrame:emailF withPlaceholderText:LocalString(@"Address e-mail")];
    self.emailModelTF.inputText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailModelTF.inputText.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailModelTF.inputText.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailModelTF.frame = emailF;
    self.emailModelTF.inputText.delegate = self;
    [self.view addSubview:self.emailModelTF];
    
    CGRect passwordF = CGRectMake(yAutoFit(15), getRectNavAndStatusHight + yAutoFit(280), yAutoFit(320), yAutoFit(60));
    
    self.passwordModelTF = [[AAPasswordTF alloc]initWithFrame:passwordF withPlaceholderText:LocalString(@"Password")];
    self.passwordModelTF.inputText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordModelTF.inputText.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordModelTF.inputText.secureTextEntry = YES;
    self.passwordModelTF.frame = passwordF;
    self.passwordModelTF.inputText.delegate = self;
    [self.view addSubview:self.passwordModelTF];
    
    UITapGestureRecognizer *tapGrEmail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTappedEmail:)];
    tapGrEmail.cancelsTouchesInView = NO;
    
    UITapGestureRecognizer *tapGrPassword = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTappedPassword:)];
    tapGrPassword.cancelsTouchesInView = NO;
    
    [self.emailModelTF.labelView addGestureRecognizer:tapGrEmail];
    [self.passwordModelTF.labelView addGestureRecognizer:tapGrPassword];
}

-(void)viewTappedEmail:(UITapGestureRecognizer*)tapGr
{
    [self.emailModelTF.inputText resignFirstResponder];
}

-(void)viewTappedPassword:(UITapGestureRecognizer*)tapGr
{
    [self.passwordModelTF.inputText resignFirstResponder];
}

#pragma mark - GizWifiSDK delegate
// 实现回调
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didUserLogin:(NSError *)result uid:(NSString *)uid token:(NSString *)token {
    if(result.code == GIZ_SDK_SUCCESS) {
        //登录成功
        NSLog(@"登录成功,%@", result);
        
        [GizManager shareInstance].uid = uid;
        [GizManager shareInstance].token = token;
        
        //保存Wi-Fi名称
        NSUserDefaults *wifinameDefaults = [NSUserDefaults standardUserDefaults];
        [wifinameDefaults setObject: [GizManager getCurrentWifi] forKey:@"wifiname"];
        NSLog(@"Wi-Fi名称%@",[GizManager getCurrentWifi]);

        DeviceListViewController *WelcomeVC = [[DeviceListViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:WelcomeVC];
        [self presentViewController:nav animated:YES completion:nil];
        
    } else {
        // 登录失败
        NSLog(@"登录失败,%@", result);
        [NSObject showHudTipStr:LocalString(@"Login failed")];
        //[NSObject showHudTipStr3:[NSString stringWithFormat:@"%@",result]];
        
    }
    
}

#pragma mark - Actions
- (void)goLogin{
    
    [[GizWifiSDK sharedInstance] userLogin:self.emailModelTF.inputText.text password:self.passwordModelTF.inputText.text];
    
}

- (void)forgetPW{
    ForgetpasswordViewController *ForgetVC = [[ForgetpasswordViewController alloc] init];
    [self.navigationController pushViewController:ForgetVC animated:YES];
    
}

@end
