//
//  SetPinCodeViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/25.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "SetPinCodeViewController.h"

@interface SetPinCodeViewController () <UITextFieldDelegate>

@property (strong,nonatomic) UIView *bgTipView;
@property (nonatomic, strong) UITextField *oldPinCodeTF;
@property (nonatomic, strong) UITextField *pinCodeTF;
@property (nonatomic, strong) UITextField *repeatpinCodeTF;
@property (strong, nonatomic) UIButton *sureBtn;

@end

@implementation SetPinCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
    _bgTipView = [self bgTipView];
    _oldPinCodeTF = [self oldPinCodeTF];
    _pinCodeTF = [self pinCodeTF];
    _repeatpinCodeTF = [self repeatpinCodeTF];
    _sureBtn = [self sureBtn];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - Lazy load
- (void)setNavItem{
    self.navigationItem.title = LocalString(@"PIN Code Setting");
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
        tipLabel.text = LocalString(@"PIN Code Setting:");
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

- (UITextField *)oldPinCodeTF{
    if (!_oldPinCodeTF) {
        _oldPinCodeTF = [[UITextField alloc] init];
        _oldPinCodeTF.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _oldPinCodeTF.font = [UIFont systemFontOfSize:16.f];
        _oldPinCodeTF.tintColor = [UIColor whiteColor];
        _oldPinCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _oldPinCodeTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _oldPinCodeTF.delegate = self;
        _oldPinCodeTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _oldPinCodeTF.borderStyle = UITextBorderStyleRoundedRect;
        [_oldPinCodeTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_oldPinCodeTF];
        [_oldPinCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(40)));
            make.top.equalTo(self.view.mas_top).offset(yAutoFit(200));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _oldPinCodeTF.layer.borderWidth = 0.5;
        _oldPinCodeTF.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _oldPinCodeTF.layer.cornerRadius = 2.5f;
        _oldPinCodeTF.placeholder = LocalString(@"Old PIN Code");
    }
    return _oldPinCodeTF;
}

- (UITextField *)pinCodeTF{
    if (!_pinCodeTF) {
        _pinCodeTF = [[UITextField alloc] init];
        _pinCodeTF.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _pinCodeTF.font = [UIFont systemFontOfSize:16.f];
        _pinCodeTF.tintColor = [UIColor whiteColor];
        _pinCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pinCodeTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _pinCodeTF.delegate = self;
        _pinCodeTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _pinCodeTF.borderStyle = UITextBorderStyleRoundedRect;
        [_pinCodeTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_pinCodeTF];
        [_pinCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(40)));
            make.top.equalTo(self.oldPinCodeTF.mas_bottom).offset(yAutoFit(30));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _pinCodeTF.layer.borderWidth = 0.5;
        _pinCodeTF.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _pinCodeTF.layer.cornerRadius = 2.5f;
        _pinCodeTF.placeholder = LocalString(@"New PIN Code");
        
    }
    return _pinCodeTF;
}

- (UITextField *)repeatpinCodeTF{
    if (!_repeatpinCodeTF) {
        _repeatpinCodeTF = [[UITextField alloc] init];
        _repeatpinCodeTF.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _repeatpinCodeTF.font = [UIFont systemFontOfSize:16.f];
        _repeatpinCodeTF.tintColor = [UIColor whiteColor];
        _repeatpinCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _repeatpinCodeTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _repeatpinCodeTF.delegate = self;
        _repeatpinCodeTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _repeatpinCodeTF.borderStyle = UITextBorderStyleRoundedRect;
        [_repeatpinCodeTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_repeatpinCodeTF];
        [_repeatpinCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(40)));
            make.top.equalTo(self.pinCodeTF.mas_bottom).offset(yAutoFit(30));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _repeatpinCodeTF.layer.borderWidth = 0.5;
        _repeatpinCodeTF.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _repeatpinCodeTF.layer.cornerRadius = 2.5f;
        _repeatpinCodeTF.placeholder = LocalString(@"Repeat New PIN Code");
    }
    return _repeatpinCodeTF;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:LocalString(@"Sure") forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        [_sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.enabled = YES;
        [self.view addSubview:_sureBtn];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(45)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _sureBtn.layer.borderWidth = 0.5;
        _sureBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _sureBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _sureBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _sureBtn.layer.shadowRadius = 3;
        _sureBtn.layer.shadowOpacity = 1;
        _sureBtn.layer.cornerRadius = 2.5;
    }
    return _sureBtn;
}

@end
