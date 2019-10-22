//
//  APConnectNetController.m
//  myapp
//
//  Created by 安建伟 on 2019/7/31.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "APConnectNetController.h"
#import "APConfigureNetController.h"

@interface APConnectNetController () <UITextFieldDelegate>

@property (strong, nonatomic) UIView *wifiView;
@property (nonatomic, strong) UILabel *wifiLabel;

@property (nonatomic, strong) UITextField *wifiNameTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *eyespasswordBtn;

@property (strong, nonatomic)  UIImageView *deviceImage;

@end

@implementation APConnectNetController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.view.layer.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1].CGColor;
//    [self setNavItem];
//    _deviceImage = [self deviceImage];
//    _wifiLabel = [self wifiLabel];
//    _wifiView = [self wifiView];
//    _nextBtn = [self nextBtn];
//    _eyespasswordBtn = [self eyespasswordBtn];
//    [_eyespasswordBtn setImage:[UIImage imageNamed:@"ic_eyesclosed"] forState:UIControlStateNormal];
//    
//}
//
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
//    self.navigationController.navigationBar.hidden = NO;
//}
//
//- (void)setNavItem{
//    self.navigationItem.title = LocalString(@"选择设备工作Wi-Fi");
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//    
//    backItem.title = @"Back";
//    self.navigationItem.backBarButtonItem = backItem;
//}
//
//- (UIImageView *)deviceImage{
//    if (!_deviceImage) {
//        _deviceImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"net_device"]];
//        [self.view addSubview:_deviceImage];
//        
//        [_deviceImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(yAutoFit(120.f), yAutoFit(100.f)));
//            make.top.equalTo(self.view.mas_top).offset(yAutoFit(120.f));
//            make.centerX.equalTo(self.view.mas_centerX);
//        }];
//    }
//    return _deviceImage;
//}
//
//- (UILabel *)wifiLabel{
//    if (!_wifiLabel) {
//        _wifiLabel = [[UILabel alloc] init];
//        _wifiLabel.font = [UIFont systemFontOfSize:17.f];
//        _wifiLabel.backgroundColor = [UIColor clearColor];
//        _wifiLabel.textColor = [UIColor blackColor];
//        _wifiLabel.textAlignment = NSTextAlignmentCenter;
//        _wifiLabel.text = LocalString(@"请输入wifi密码，连接您的智能设备");
//        //自动折行设置
//        [_wifiLabel setLineBreakMode:NSLineBreakByWordWrapping];
//        _wifiLabel.numberOfLines = 0;
//        _wifiLabel.textAlignment = NSTextAlignmentCenter;
//        [self.view addSubview:_wifiLabel];
//        [_wifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(yAutoFit(284.f), 40));
//            make.centerX.mas_equalTo(self.view.mas_centerX);
//            make.top.equalTo(self.deviceImage.mas_bottom).offset(yAutoFit(20.f));
//        }];
//    }
//    return _wifiLabel;
//}
//
//-(UIView *)wifiView{
//    if (!_wifiView) {
//        _wifiView = [[UIView alloc] initWithFrame:CGRectMake(0, 280, ScreenWidth, yAutoFit(200.f))];
//        _wifiView.backgroundColor = [UIColor clearColor];
//        [self.view insertSubview:_wifiView atIndex:0];
//        /*........手机号输入........*/
//        UIView *wifiNameView = [[UIView alloc] initWithFrame:CGRectMake(yAutoFit(45.f),yAutoFit(300.f),yAutoFit(286.f),yAutoFit(36.f))];
//        wifiNameView.backgroundColor = [UIColor clearColor];
//        //添加输入框下划线
//        UIView * underLine = [[UIView alloc]initWithFrame:CGRectMake(0,wifiNameView.frame.size.height-1,wifiNameView.frame.size.width,1)];
//        underLine.backgroundColor = [UIColor colorWithHexString:@"E6E6E6"];
//        [_wifiView addSubview:wifiNameView];
//        [wifiNameView addSubview:underLine];
//        
//        [wifiNameView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(yAutoFit(284.f), 44.f));
//            make.top.equalTo(self.view.mas_top).offset(yAutoFit(300.f));
//            make.centerX.equalTo(self.view.mas_centerX);
//        }];
//        
//        _wifiNameTF = [[UITextField alloc] init];
//        _wifiNameTF.backgroundColor = [UIColor clearColor];
//        _wifiNameTF.textColor = [UIColor blackColor];
//        _wifiNameTF.font = [UIFont systemFontOfSize:15];
//        _wifiNameTF.placeholder = LocalString(@"wifi名称");
//        _wifiNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _wifiNameTF.autocorrectionType = UITextAutocorrectionTypeNo;
//        _wifiNameTF.keyboardType = UIKeyboardTypePhonePad;
//        _wifiNameTF.delegate = self;
//        _wifiNameTF.borderStyle = UITextBorderStyleNone;
//        [wifiNameView addSubview:_wifiNameTF];
//        [_wifiNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(yAutoFit(200.f),yAutoFit(30.f)));
//            make.left.equalTo(wifiNameView.mas_left).offset(yAutoFit(55.f));
//            make.centerY.equalTo(wifiNameView.mas_centerY);
//        }];
//        _wifiNameTF.text = [GizManage getCurrentWifi];
//        
//        UIImageView *phoneleftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone_image"]];
//        phoneleftImage.contentMode = UIViewContentModeScaleAspectFit;
//        [wifiNameView addSubview:phoneleftImage];
//        [phoneleftImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(yAutoFit(20.f), yAutoFit(20.f)));
//            make.left.equalTo(wifiNameView.mas_left).offset(yAutoFit(18.f));
//            make.centerY.equalTo(wifiNameView.mas_centerY);
//        }];
//        
//        /*........密码输入........*/
//        UIView *_passwordTFView = [[UIView alloc] initWithFrame:CGRectMake(yAutoFit(45.f),yAutoFit(345.f),yAutoFit(284.f),yAutoFit(36.f))];
//        _passwordTFView.backgroundColor = [UIColor clearColor];
//        //添加输入框下划线
//        UIView * underLine2 = [[UIView alloc]initWithFrame:CGRectMake(0,_passwordTFView.frame.size.height-1,_passwordTFView.frame.size.width,1)];
//        underLine2.backgroundColor = [UIColor colorWithHexString:@"E6E6E6"];
//        [_wifiView addSubview:_passwordTFView];
//        [_passwordTFView addSubview:underLine2];
//        
//        [_passwordTFView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(yAutoFit(280.f), 44.f));
//            make.top.equalTo(self.view.mas_top).offset(yAutoFit(345.f));
//            make.centerX.equalTo(self.view.mas_centerX);
//        }];
//        
//        _passwordTF = [[UITextField alloc] init];
//        _passwordTF.backgroundColor = [UIColor clearColor];
//        _passwordTF.font = [UIFont systemFontOfSize:15];
//        _passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _passwordTF.autocorrectionType = UITextAutocorrectionTypeNo;
//        _passwordTF.delegate = self;
//        _passwordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
//        _passwordTF.borderStyle = UITextBorderStyleNone;
//        _passwordTF.placeholder = LocalString(@"请输入wifi密码");
//        _passwordTF.secureTextEntry = YES;
//        [_passwordTFView addSubview:_passwordTF];
//        [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(yAutoFit(130.f),yAutoFit(30.f)));
//            make.left.equalTo(_passwordTFView.mas_left).offset(yAutoFit(55.f));
//            make.centerY.equalTo(_passwordTFView.mas_centerY);
//        }];
//        
//        UIImageView *passwordleftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_image"]];
//        passwordleftImage.contentMode = UIViewContentModeScaleAspectFit;
//        [_passwordTFView addSubview:passwordleftImage];
//        [passwordleftImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(yAutoFit(20.f), yAutoFit(20.f)));
//            make.left.equalTo(_passwordTFView.mas_left).offset(yAutoFit(18.f));
//            make.centerY.equalTo(_passwordTFView.mas_centerY);
//        }];
//        
//    }
//    return _wifiView;
//}
//
//
//- (UIButton *)eyespasswordBtn{
//    if (!_eyespasswordBtn) {
//        _eyespasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_eyespasswordBtn addTarget:self action:@selector(eyespassword) forControlEvents:UIControlEventTouchUpInside];
//        [_eyespasswordBtn.widthAnchor constraintEqualToConstant:30].active = YES;
//        [_eyespasswordBtn.heightAnchor constraintEqualToConstant:30].active = YES;
//        [self.view addSubview:_eyespasswordBtn];
//        [_eyespasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(30, 30));
//            make.right.equalTo(self.view.mas_right).offset(-50);
//            make.centerY.equalTo(self.passwordTF.mas_centerY);
//        }];
//    }
//    return _eyespasswordBtn;
//}
//
//- (UIButton *)nextBtn{
//    if (!_nextBtn) {
//        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_nextBtn setTitle:LocalString(@"下一步") forState:UIControlStateNormal];
//        [_nextBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
//        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"background_Btn_login"] forState:UIControlStateNormal];
//        [_nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
//        _nextBtn.enabled = YES;
//        [self.view addSubview:_nextBtn];
//        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(yAutoFit(280.f), 60.f));
//            make.top.equalTo(self.passwordTF.mas_bottom).offset(yAutoFit(30.f));
//            make.centerX.mas_equalTo(self.view.mas_centerX);
//        }];
//        
//    }
//    return _nextBtn;
//}
//
//
//#pragma mark - UITextFieldDelegate
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    
//}
//
//#pragma mark - UIUITextField action
//
//-(void)textFieldTextChange{
//    
//}
//
//#pragma mark - resign keyboard control
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self.wifiNameTF resignFirstResponder];
//    [self.passwordTF resignFirstResponder];
//    
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [self.wifiNameTF resignFirstResponder];
//    [self.passwordTF resignFirstResponder];
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
//    return YES;
//}
//
//- (void)eyespassword{
//    if (_passwordTF.secureTextEntry == YES) {
//        [_eyespasswordBtn setImage:[UIImage imageNamed:@"ic_eyespassword"] forState:UIControlStateNormal];
//        _passwordTF.secureTextEntry = NO;
//    }else{
//        _passwordTF.secureTextEntry = YES;
//        [_eyespasswordBtn setImage:[UIImage imageNamed:@"ic_eyesclosed"] forState:UIControlStateNormal];
//    }
//    
//}
//
//-(void)next{
//    GizManage *manager = [GizManage shareInstance];
//    manager.ssid = _wifiNameTF.text;
//    manager.key = _passwordTF.text;
//    
//    if (_passwordTF.text.length > 0) {
//        APConfigureNetController *apConfigureVC = [[APConfigureNetController alloc] init];
//        [self.navigationController pushViewController:apConfigureVC animated:YES];
//    }
//}

@end
