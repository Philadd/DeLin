//
//  APConfigureNetController.m
//  myapp
//
//  Created by 安建伟 on 2019/7/31.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "APConfigureNetController.h"
#import "APFinishNetController.h"

@interface APConfigureNetController () <UITextViewDelegate>

@property (strong, nonatomic) UIImageView *deviceImage;
@property (strong, nonatomic) UITextView *wifiTextView;

@property (nonatomic, strong) UIButton *connectBtn;

@end

@implementation APConfigureNetController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.view.layer.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1].CGColor;
//    [self setNavItem];
//    
//    _connectBtn = [self connectBtn];
//    _wifiTextView = [self wifiTextView];
//    _deviceImage = [self deviceImage];
//}
//
//- (void)setNavItem{
//    self.navigationItem.title = LocalString(@"选择设备热点");
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
//- (UITextView *)wifiTextView{
//    
//    if (!_wifiTextView) {
//        _wifiTextView = [[UITextView alloc] init];
//        _wifiTextView.backgroundColor = [UIColor clearColor];
//        _wifiTextView.text = LocalString(@"1.Turn on your device.\n2.Move the cursor to\"WIFI Setting\",then press OK;the text Network Configuration……will appear.\n3.Press the connection buttton and wait for the process to complete.");
//        _wifiTextView.textAlignment = NSTextAlignmentLeft;
//        _wifiTextView.textColor = [UIColor blackColor];
//        _wifiTextView.font = [UIFont boldSystemFontOfSize:15];
//        //_wifiTextView.dataDetectorTypes = UIDataDetectorTypeAll;
//        // 禁止编辑.设置为只读，不再能输入内容
//        _wifiTextView.editable = NO;
//        //禁止选择.禁止选中文本，此时文本也禁止编辑
//        _wifiTextView.selectable = NO;
//        // 禁止滚动
//        _wifiTextView.scrollEnabled = NO;
//        // 设置可以对选中的文字加粗。选中文字时可以对选中的文字加粗
//        _wifiTextView.allowsEditingTextAttributes = YES;
//        _wifiTextView.delegate = self;
//        
//        [self.view addSubview:_wifiTextView];
//        [_wifiTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(yAutoFit(300.f),yAutoFit(200.f)));
//            make.centerX.mas_equalTo(self.view.mas_centerX);
//            make.top.equalTo(self.view.mas_top).offset(yAutoFit(250.f));
//        }];
//    }
//    return _wifiTextView;
//}
//
//- (UIButton *)connectBtn{
//    if (!_connectBtn) {
//        _connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_connectBtn setTitle:LocalString(@"Connect") forState:UIControlStateNormal];
//        [_connectBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
//        [_connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_connectBtn setBackgroundImage:[UIImage imageNamed:@"background_Btn_login"] forState:UIControlStateNormal];
//        [_connectBtn addTarget:self action:@selector(ConnectWifi) forControlEvents:UIControlEventTouchUpInside];
//        _connectBtn.enabled = YES;
//        [self.view addSubview:_connectBtn];
//        [_connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(yAutoFit(300.f), 60.f));
//            make.top.equalTo(self.wifiTextView.mas_bottom).offset(yAutoFit(20.f));
//            make.centerX.mas_equalTo(self.view.mas_centerX);
//        }];
//    }
//    return _connectBtn;
//}
//
//-(void)ConnectWifi{
//    
//    NSString *wifiName = @"XPG-GAgent";
//    if ([[GizManage getCurrentWifi] hasPrefix:wifiName]) {
//        APFinishNetController *VC = [[APFinishNetController alloc] init];
//        [self.navigationController pushViewController:VC animated:YES];
//    }else{
//        [self showAlert];
//    }
//}
//
//- (void)showAlert{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"去连接设备热点") message:LocalString(@"请到手机设置页面连接 “XPG-GAgent”的热点 ,密码:123456789") preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:LocalString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if (@available(iOS 10.0, *)) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        }else{
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        }
//    }];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"取消") style:UIAlertActionStyleCancel handler:nil];
//    [alert addAction:okAction];
//    [alert addAction:cancelAction];
//    [self presentViewController:alert animated:YES completion:nil];
//    
//}


@end
