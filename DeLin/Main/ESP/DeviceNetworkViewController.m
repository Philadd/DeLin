//
//  addLandroidDeviceViewController.m
//  MOWOX
//
//  Created by 安建伟 on 2018/12/17.
//  Copyright © 2018 yusz. All rights reserved.
//

#import "DeviceNetworkViewController.h"
#import "FinishNetworkViewController.h"
#import "ConnectNetworkViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface DeviceNetworkViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *Label_1;
@property (nonatomic, strong) UILabel *Label_2;

@property (nonatomic, strong) UITextField *wifiNameTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *eyespasswordBtn;

@property (strong, nonatomic)  UIImageView *deviceImage;


@end

@implementation DeviceNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavItem];
    
    _Label_1 = [self Label_1];
    _Label_2 = [self Label_2];
    _wifiNameTF = [self wifiNameTF];
    _passwordTF = [self passwordTF];
    _nextBtn = [self nextBtn];
    _deviceImage = [self deviceImage];
    _eyespasswordBtn = [self eyespasswordBtn];
    [_eyespasswordBtn setImage:[UIImage imageNamed:@"ic_eyesclosed"] forState:UIControlStateNormal];
    
}

- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Add Robot");
}

- (UIImageView *)deviceImage{
    if (!_deviceImage) {
        _deviceImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"device"]];
        [self.view addSubview:_deviceImage];
        
        [_deviceImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth * 0.9, ScreenHeight * 0.3));
            make.top.equalTo(self.view.mas_top).offset(yAutoFit(80));
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }
    return _deviceImage;
}

- (UILabel *)Label_1{
    if (!_Label_1) {
        _Label_1 = [[UILabel alloc] init];
        _Label_1.font = [UIFont systemFontOfSize:14.f];
        _Label_1.backgroundColor = [UIColor clearColor];
        _Label_1.textColor = [UIColor blackColor];
        _Label_1.text = LocalString(@"Verify connection to your Wi-Fi network,then enter the network name and password.");
        //自动折行设置
        [_Label_1 setLineBreakMode:NSLineBreakByWordWrapping];
        _Label_1.numberOfLines = 0;
        _Label_1.textAlignment = NSTextAlignmentLeft;
        _Label_1.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:_Label_1];
        [_Label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320),yAutoFit(60)));
            make.top.equalTo(self.view.mas_top).offset(yAutoFit(300));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];

    }
    return _Label_1;
}

- (UILabel *)Label_2{
    if (!_Label_2) {
        _Label_2 = [[UILabel alloc] init];
        _Label_2.font = [UIFont systemFontOfSize:14.f];
        _Label_2.backgroundColor = [UIColor clearColor];
        _Label_2.textColor = [UIColor blackColor];
        _Label_2.textAlignment = NSTextAlignmentLeft;
        _Label_2.text = LocalString(@"Make sure to use 2.4GHz Wi-Fi network.");
        //自动折行设置
        [_Label_2 setLineBreakMode:NSLineBreakByWordWrapping];
        _Label_2.numberOfLines = 0;
        _Label_2.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_Label_2];
        [_Label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(40)));
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.equalTo(self.Label_1.mas_bottom).offset(yAutoFit(20));
        }];
    }
    return _Label_2;
}

- (UITextField *)wifiNameTF{
    if (!_wifiNameTF) {
        _wifiNameTF = [[UITextField alloc] init];
        _wifiNameTF.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _wifiNameTF.font = [UIFont systemFontOfSize:15.f];
        _wifiNameTF.tintColor = [UIColor colorWithHexString:@"333333"];
        _wifiNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _wifiNameTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _wifiNameTF.delegate = self;
        _wifiNameTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _wifiNameTF.borderStyle = UITextBorderStyleRoundedRect;
        [_wifiNameTF addTarget:self action:@selector(textFieldTextChange) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_wifiNameTF];
        [_wifiNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(40)));
            make.top.equalTo(self.Label_2.mas_bottom).offset(yAutoFit(30));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        _wifiNameTF.layer.borderWidth = 0.5;
        _wifiNameTF.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _wifiNameTF.layer.cornerRadius = 2.5f;
        //获取当前连接的Wi-FiSSID
        _wifiNameTF.text = [self getDeviceSSID];  
        
    }
    return _wifiNameTF;
}

- (UIButton *)eyespasswordBtn{
    if (!_eyespasswordBtn) {
        _eyespasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_eyespasswordBtn addTarget:self action:@selector(eyespassword) forControlEvents:UIControlEventTouchUpInside];
        [_eyespasswordBtn.widthAnchor constraintEqualToConstant:30].active = YES;
        [_eyespasswordBtn.heightAnchor constraintEqualToConstant:30].active = YES;
        [self.view addSubview:_eyespasswordBtn];
        [_eyespasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(30),yAutoFit(30)));
            make.right.equalTo(self.view.mas_right).offset(-50);
            make.centerY.equalTo(self.passwordTF.mas_centerY);
        }];
    }
    return _eyespasswordBtn;
}

- (UITextField *)passwordTF{
    if (!_passwordTF) {
        _passwordTF = [[UITextField alloc] init];
        _passwordTF.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _passwordTF.font = [UIFont systemFontOfSize:15.f];
        _passwordTF.tintColor = [UIColor colorWithHexString:@"333333"];
        _passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _passwordTF.delegate = self;
        _passwordTF.secureTextEntry = YES;
        _passwordTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _passwordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordTF.borderStyle = UITextBorderStyleRoundedRect;
        
        [_passwordTF addTarget:self action:@selector(textFieldTextChange) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_passwordTF];
        [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(40)));
            make.top.equalTo(self.wifiNameTF.mas_bottom).offset(yAutoFit(30));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        _passwordTF.layer.borderWidth = 0.5;
        _passwordTF.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _passwordTF.layer.cornerRadius = 2.5f;
        _passwordTF.placeholder = LocalString(@"Wi-Fi Password");
    }
    return _passwordTF;
}

- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitle:LocalString(@"Next") forState:UIControlStateNormal];
        [_nextBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_nextBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_nextBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0f]];
        [_nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.enabled = YES;
        [self.view addSubview:_nextBtn];
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(50)));
            make.top.equalTo(self.passwordTF.mas_bottom).offset(yAutoFit(30));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
      
        _nextBtn.layer.borderWidth = 0.5;
        _nextBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _nextBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _nextBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _nextBtn.layer.shadowRadius = 3;
        _nextBtn.layer.shadowOpacity = 1;
        _nextBtn.layer.cornerRadius = 2.5;
    }
    return _nextBtn;
}

#pragma 获取设备当前连接的WIFI的SSID
- (NSString *) getDeviceSSID
{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs)
    {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count])
        {
            break;
        }
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    NSString *ssid = [dctySSID objectForKey:@"SSID"];
    return ssid;
    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

#pragma mark - UIUITextField action

-(void)textFieldTextChange{
    
}

#pragma mark - resign keyboard control

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.wifiNameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.wifiNameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)eyespassword{
    if (_passwordTF.secureTextEntry == YES) {
        [_eyespasswordBtn setImage:[UIImage imageNamed:@"ic_eyespassword"] forState:UIControlStateNormal];
        _passwordTF.secureTextEntry = NO;
    }else{
        _passwordTF.secureTextEntry = YES;
        [_eyespasswordBtn setImage:[UIImage imageNamed:@"ic_eyesclosed"] forState:UIControlStateNormal];
    }
    
}

-(void)next{
    GizManager *manager = [GizManager shareInstance];
    manager.ssid = _wifiNameTF.text;
    manager.key = _passwordTF.text;
    
    if (_passwordTF.text.length > 0) {
        ConnectNetworkViewController *VC = [[ConnectNetworkViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

@end