//
//  InputPINViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/20.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "InputPINViewController.h"
#import "MainViewController.h"

@interface InputPINViewController () <UITextFieldDelegate>

@property (strong,nonatomic) UIView *bgTipView;
@property (strong,nonatomic) UITextField *inputPinTF;
@property (strong,nonatomic) UIButton *enterBtn;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UILabel *pinLabel;

@end

@implementation InputPINViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0].CGColor;
    
    _bgTipView = [self bgTipView];
    _inputPinTF = [self inputPinTF];
    _enterBtn = [self enterBtn];
    _checkBtn = [self checkBtn];
    _pinLabel = [self pinLabel];
    
    //读取上次的 记住密码
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults objectForKey:@"passWord"]){
//        [_checkBtn setImage:[UIImage imageNamed:@"rememberpassword"] forState:UIControlStateNormal];
//        _checkBtn.tag = ySelect;
//        _passwordTF.text = [defaults objectForKey:@"passWord"];
//        NSLog(@"帐号密码%@",_passwordTF.text);
//    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (UIView *)bgTipView{
    if (!_bgTipView) {
        _bgTipView = [[UIView alloc] init];
        _bgTipView.backgroundColor = [UIColor colorWithHexString:@"FF9700"];
        [self.view addSubview:_bgTipView];
        [_bgTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(40)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view.mas_top).offset(yAutoFit(30) + getRectNavAndStatusHight);
        }];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.font = [UIFont systemFontOfSize:15.f];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = [UIColor colorWithHexString:@"333333"];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = LocalString(@"Connect your robot mower:");
        tipLabel.adjustsFontSizeToFitWidth = YES;
        [self.bgTipView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(280), yAutoFit(40)));
            make.centerX.mas_equalTo(self.bgTipView.mas_centerX);
            make.centerY.mas_equalTo(self.bgTipView.mas_centerY);
        }];
        
    }
    return _bgTipView;
}

- (UITextField *)inputPinTF{
    if (!_inputPinTF) {
        _inputPinTF = [[UITextField alloc] init];
        _inputPinTF.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _inputPinTF.font = [UIFont systemFontOfSize:16.f];
        _inputPinTF.tintColor = [UIColor colorWithHexString:@"333333"];
        _inputPinTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputPinTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _inputPinTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _inputPinTF.delegate = self;
        _inputPinTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _inputPinTF.borderStyle = UITextBorderStyleRoundedRect;
        [_inputPinTF addTarget:self action:@selector(textFieldTextChange) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_inputPinTF];
        [_inputPinTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(40)));
            make.top.equalTo(self.bgTipView.mas_bottom).offset(yAutoFit(37.5));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _inputPinTF.layer.borderWidth = 0.5;
        _inputPinTF.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _inputPinTF.layer.cornerRadius = 2.5f;
        _inputPinTF.placeholder = LocalString(@"Please enter PIN Code");
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *pinCode = [userDefaults objectForKey:@"pinCode"];
        if (pinCode != NULL) {
            _inputPinTF.text = pinCode;
        }
        
    }
    return _inputPinTF;
}

- (UIButton *)enterBtn{
    if (!_enterBtn) {
        _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterBtn setTitle:LocalString(@"ENTER") forState:UIControlStateNormal];
        [_enterBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_enterBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_enterBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.f]];
        [_enterBtn addTarget:self action:@selector(enterMain) forControlEvents:UIControlEventTouchUpInside];
        _enterBtn.enabled = YES;
        [self.view addSubview:_enterBtn];
        [_enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(50)));
            make.top.equalTo(self.inputPinTF.mas_bottom).offset(yAutoFit(30));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _enterBtn.layer.borderWidth = 0.5;
        _enterBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _enterBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _enterBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _enterBtn.layer.shadowRadius = 3;
        _enterBtn.layer.shadowOpacity = 1;
        _enterBtn.layer.cornerRadius = 2.5;
    }
    return _enterBtn;
}

- (UIButton *)checkBtn{
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setImage:[UIImage imageNamed:@"not password"] forState:UIControlStateNormal];
        [_checkBtn addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
        [_checkBtn.widthAnchor constraintEqualToConstant:25].active = YES;
        [_checkBtn.heightAnchor constraintEqualToConstant:25].active = YES;
        _checkBtn.tag = yUnselect;
        [self.view addSubview:_checkBtn];
        [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(25), yAutoFit(25)));
            make.left.equalTo(self.view.mas_left).offset(yAutoFit(100));
            make.top.equalTo(self.enterBtn.mas_bottom).offset(20);
        }];
        
    }
    return _checkBtn;
}

- (UILabel *)pinLabel{
    if (!_pinLabel) {
        _pinLabel = [[UILabel alloc] init];
        _pinLabel.font = [UIFont systemFontOfSize:14.f];
        _pinLabel.backgroundColor = [UIColor clearColor];
        _pinLabel.textColor = [UIColor colorWithHexString:@"696969"];
        _pinLabel.textAlignment = NSTextAlignmentCenter;
        _pinLabel.text = LocalString(@"Keep me logged in");
        _pinLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:_pinLabel];
        [_pinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(150), yAutoFit(20)));
            make.left.equalTo(self.checkBtn.mas_right).offset(5);
            make.centerY.equalTo(self.checkBtn.mas_centerY);
        }];
    }
    return _pinLabel;
}

#pragma mark - Actions
- (void)enterMain{
    MainViewController *mainVC = [[MainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    mainVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)check{
    if (_checkBtn.tag == yUnselect) {
        _checkBtn.tag = ySelect;
        [_checkBtn setImage:[UIImage imageNamed:@"rememberpassword"] forState:UIControlStateNormal];
    }else if (_checkBtn.tag == ySelect) {
        _checkBtn.tag = yUnselect;
        [_checkBtn setImage:[UIImage imageNamed:@"not password"] forState:UIControlStateNormal];
    }
    
}

@end
