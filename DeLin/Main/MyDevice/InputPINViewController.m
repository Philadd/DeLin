//
//  InputPINViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/20.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "InputPINViewController.h"
#import "MainViewController.h"
#import "AAPInPasswordTF.h"

@interface InputPINViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *labelBgView;
@property (nonatomic, strong) UIButton *continueBtn;
@property (nonatomic, strong) UIButton *agreementBtn;

@property (nonatomic, strong) AAPInPasswordTF *passwordModelTF;
@end

@implementation InputPINViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
    _labelBgView = [self labelBgView];
    _agreementBtn = [self agreementBtn];
    _continueBtn = [self continueBtn];
    
    [self setNavItem];
    [self setUItextField];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputPINCodeMain) name:@"inputPINCode" object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"inputPINCode" object:nil];
    
}

#pragma mark - setters and getters

- (void)setNavItem{
    self.navigationItem.title = LocalString(@"A NEW USER");
}

- (UIView *)labelBgView{
    if (!_labelBgView) {
        _labelBgView = [[UIView alloc] initWithFrame:CGRectMake( 0 , getRectNavAndStatusHight + yAutoFit(20), ScreenWidth,yAutoFit(150))];
        _labelBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_labelBgView];
        
        UILabel *welcomelabel = [[UILabel alloc] init];
        welcomelabel.text = LocalString(@"Please input PIN Code");
        welcomelabel.font = [UIFont systemFontOfSize:25.f];
        welcomelabel.textColor = [UIColor whiteColor];
        welcomelabel.textAlignment = NSTextAlignmentCenter;
        welcomelabel.adjustsFontSizeToFitWidth = YES;
        [self.labelBgView addSubview:welcomelabel];
        [welcomelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth , yAutoFit(25.f)));
            make.centerX.equalTo(self.labelBgView.mas_centerX);
            make.top.equalTo(self.labelBgView.mas_top);
        }];
        
        UILabel *tiplabel = [[UILabel alloc] init];
        tiplabel.text = LocalString(@"Passwords should be 4 characters");
        tiplabel.font = [UIFont systemFontOfSize:16.f];
        tiplabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        tiplabel.numberOfLines = 0;
        tiplabel.textAlignment = NSTextAlignmentCenter;
        tiplabel.adjustsFontSizeToFitWidth = YES;
        [self.labelBgView addSubview:tiplabel];
        [tiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(100)));
            make.centerX.equalTo(self.labelBgView.mas_centerX);
            make.top.equalTo(welcomelabel.mas_bottom).offset(yAutoFit(5.f));
        }];
        
    }
    return _labelBgView;
}

- (UIButton *)agreementBtn{
    if (!_agreementBtn) {
        _agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreementBtn.tag = aUnselect;
        [_agreementBtn setImage:[UIImage imageNamed:@"img_unselect"] forState:UIControlStateNormal];
        [_agreementBtn setBackgroundColor:[UIColor clearColor]];
        [_agreementBtn.widthAnchor constraintEqualToConstant:25].active = YES;
        [_agreementBtn.heightAnchor constraintEqualToConstant:25].active = YES;
        _agreementBtn.tag = aUnselect;
        [_agreementBtn addTarget:self action:@selector(checkAgreement) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_agreementBtn];
        [_agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(20.f), yAutoFit(20.f)));
            make.left.equalTo(self.view.mas_left).offset(yAutoFit(40.f));
            make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHight + yAutoFit(250));
        }];
        
        UILabel *agreementLabel = [[UILabel alloc] init];
        agreementLabel.text = LocalString(@"keep me loggged in");
        agreementLabel.font = [UIFont systemFontOfSize:14.f];
        agreementLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        agreementLabel.numberOfLines = 0;
        agreementLabel.textAlignment = NSTextAlignmentLeft;
        agreementLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:agreementLabel];
        [agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(300), yAutoFit(100)));
            make.centerY.equalTo(self.agreementBtn.mas_centerY);
            make.left.equalTo(self.agreementBtn.mas_right).offset(yAutoFit(5.f));
        }];
    }
    return _agreementBtn;
}

- (UIButton *)continueBtn{
    if (!_continueBtn) {
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_continueBtn setTitle:LocalString(@"Submit") forState:UIControlStateNormal];
        [_continueBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_continueBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        [_continueBtn addTarget:self action:@selector(goContinue) forControlEvents:UIControlEventTouchUpInside];
        _continueBtn.enabled = YES;
        [self.view addSubview:_continueBtn];
        [_continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(45)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _continueBtn.layer.borderWidth = 0.5;
        _continueBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _continueBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _continueBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _continueBtn.layer.shadowRadius = 3;
        _continueBtn.layer.shadowOpacity = 1;
        _continueBtn.layer.cornerRadius = 2.5;
    }
    return _continueBtn;
}

#pragma mark - UITextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length <= 0) {
        [self.passwordModelTF passwordTFBeginEditing];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length <= 0) {
        [self.passwordModelTF passwordTFEndEditing];
    }
}

#pragma mark - notification

- (void)inputPINCodeMain{
    
    MainViewController *mainVC = [[MainViewController alloc] init];
    [self.navigationController pushViewController:mainVC animated:YES];
}

#pragma mark - Actions

- (void)setUItextField{
    
    CGRect accountF = CGRectMake(yAutoFit(15), getRectNavAndStatusHight + yAutoFit(170), yAutoFit(320), yAutoFit(60));
    
    self.passwordModelTF = [[AAPInPasswordTF alloc]initWithFrame:accountF withPlaceholderText:LocalString(@"Password")];
    self.passwordModelTF.inputText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordModelTF.inputText.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordModelTF.inputText.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordModelTF.frame = accountF;
    self.passwordModelTF.inputText.delegate = self;
    [self.view addSubview:self.passwordModelTF];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    
    [self.passwordModelTF.labelView addGestureRecognizer:tapGr];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.passwordModelTF.inputText resignFirstResponder];
}

- (void)goContinue{
    
    if (self.passwordModelTF.inputText.text.length != 4) {
        [NSObject showHudTipStr:LocalString(@"PinCode restrictions 4 digits")];
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray *dataContent = [[NSMutableArray alloc] init];
            [dataContent addObject:[NSNumber numberWithUnsignedInteger:[self.passwordModelTF.inputText.text characterAtIndex:0] - 48]];
            [dataContent addObject:[NSNumber numberWithUnsignedInteger:[self.passwordModelTF.inputText.text characterAtIndex:1] - 48]];
            [dataContent addObject:[NSNumber numberWithUnsignedInteger:[self.passwordModelTF.inputText.text characterAtIndex:2] - 48]];
            [dataContent addObject:[NSNumber numberWithUnsignedInteger:[self.passwordModelTF.inputText.text characterAtIndex:3] - 48]];

            UInt8 controlCode = 0x00;
            //可变插入
            [dataContent insertObject:@0x01 atIndex:0];
            [dataContent insertObject:@0x06 atIndex:0];
            [dataContent insertObject:@0x01 atIndex:0];
            [dataContent insertObject:@0x00 atIndex:0];
            
            [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:dataContent failuer:nil];
            
        });
        
    }
    
}

-(void)checkAgreement{
    if (_agreementBtn.tag == aUnselect) {
        _agreementBtn.tag = aSelect;
        [_agreementBtn setImage:[UIImage imageNamed:@"img_unselect"] forState:UIControlStateNormal];
    }else if (_agreementBtn.tag == aSelect) {
        _agreementBtn.tag = aUnselect;
        [_agreementBtn setImage:[UIImage imageNamed:@"img_select"] forState:UIControlStateNormal];
    }
    
}

@end
