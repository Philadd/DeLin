//
//  APFinishNetController.m
//  myapp
//
//  Created by 安建伟 on 2019/7/31.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "APFinishNetController.h"
#import "AAProgressCircleView.h"

@interface APFinishNetController () <GizWifiSDKDelegate>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *finishBtn;

@property (nonatomic, strong) AAProgressCircleView *circleView;

@end

@implementation APFinishNetController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.view.layer.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1].CGColor;
//    
//    [self setNavItem];
//    _finishBtn = [self finishBtn];
//    self.backgroundView = [self backgroundView];
//}
//
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [GizWifiSDK sharedInstance].delegate = self;
//    
//    GizManage *manager = [GizManage shareInstance];
//    NSLog(@"ssid---%@",manager.ssid);
//    NSLog(@"key---%@",manager.key);
//    //ap配网模式
//    [[GizWifiSDK sharedInstance] setDeviceOnboardingDeploy:manager.ssid key:manager.key configMode:GizWifiSoftAP softAPSSIDPrefix:@"XPG-GAgent-" timeout:60 wifiGAgentType:nil bind:NO];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//}
//
//#pragma mark - Lazy load
//- (void)setNavItem{
//    self.navigationItem.title = LocalString(@"设备配网中");
//    
//    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
//    [leftButton setImage:[UIImage imageNamed:@"ic_nav_addDevice"] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(finishBackAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem= leftBarButton;
//}
//
//#pragma mark - setters and getters
//- (UIView *)backgroundView{
//    if (!_backgroundView) {
//        _backgroundView = [[UIView alloc] init];
//        _backgroundView.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:_backgroundView];
//        [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(yAutoFit(320.f), ScreenHeight - getRectNavAndStatusHight - 150.f));
//            make.top.equalTo(self.view.mas_top).offset(80.f);
//            make.centerX.equalTo(self.view.mas_centerX);
//        }];
//        
//        _backgroundView.layer.cornerRadius = 10.f;
//        
//        UILabel *titleLabel = [[UILabel alloc] init];
//        titleLabel.text = LocalString(@"正在连接...");
//        titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.adjustsFontSizeToFitWidth = YES;
//        titleLabel.numberOfLines = 0;
//        [_backgroundView addSubview:titleLabel];
//        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(yAutoFit(290.f), 50.f));
//            make.top.equalTo(self.backgroundView.mas_top).offset(20.f);
//            make.centerX.equalTo(self.backgroundView.mas_centerX);
//        }];
//        
//        //        UITextView *textView = [[UITextView alloc] init];
//        //        textView.backgroundColor = [UIColor clearColor];
//        //        textView.text = LocalString(@"1.请将手机连接到如下热点: ESP-XXXX 密码是:123456789\n2.返回本应用，继续添加设备");
//        //        textView.font = [UIFont systemFontOfSize:17.f];
//        //        textView.textAlignment = NSTextAlignmentLeft;
//        //        textView.textColor = [UIColor blackColor];
//        //        textView.editable = NO;
//        //        [_backgroundView addSubview:textView];
//        //        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        //            make.size.mas_equalTo(CGSizeMake(yAutoFit(290.f), 350.f));
//        //            make.top.equalTo(titleLabel.mas_bottom).offset(20.f);
//        //            make.centerX.equalTo(self.backgroundView.mas_centerX);
//        //        }];
//        
//        //圆形进度图
//        _circleView = [[AAProgressCircleView alloc]init];
//        [_circleView didCircleProgressAction];
//        [self.backgroundView addSubview:_circleView];
//        
//        [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(217.f, 300.f));
//            make.centerX.equalTo(self.view.mas_centerX);
//            make.top.equalTo(self.view.mas_top).offset(yAutoFit(82.f));
//        }];
//    }
//    return _backgroundView;
//}
//
//- (UIButton *)finishBtn{
//    if (!_finishBtn) {
//        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_finishBtn setTitle:LocalString(@"Finish") forState:UIControlStateNormal];
//        [_finishBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
//        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_finishBtn setBackgroundImage:[UIImage imageNamed:@"background_Btn_login"] forState:UIControlStateNormal];
//        [_finishBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
//        _finishBtn.enabled = YES;
//        [self.view addSubview:_finishBtn];
//        [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(yAutoFit(300.f), 60.f));
//            make.bottom.equalTo(self.backgroundView.mas_bottom).offset(-30.f);
//            make.centerX.mas_equalTo(self.view.mas_centerX);
//        }];
//    }
//    return _finishBtn;
//}
//
//#pragma mark - Actions
//
//-(void)finish{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
//
//// 实现回调  远程设备绑定
//- (void)wifiSDK:(GizWifiSDK *)wifiSDK didBindDevice:(NSError *)result did:(NSString *)did {
//    if(result.code == GIZ_SDK_SUCCESS) {
//        // 绑定成功
//        NSLog(@"绑定成功");
//        self.circleView.percent = 1;
//        [self.circleView deleteTimer];
//        [self.circleView configSecondAnimate];
//    } else {
//        // 绑定失败
//        NSLog(@"绑定失败");
//    }
//    
//}
//
//// 实现回调  配网终止
//- (void)wifiSDK:(GizWifiSDK *)wifiSDK didSetDeviceOnboarding:(NSError *)result device:(GizWifiDevice *)device {
//    if(result.code == GIZ_SDK_ONBOARDING_STOPPED) {
//        // 配网终止
//        NSLog(@"配网终止");
//        [self.circleView deleteTimer];
//    }
//    
//}
//
//#pragma mark - Giz delegate
//-(void)wifiSDK:(GizWifiSDK *)wifiSDK didSetDeviceOnboarding:(NSError * _Nonnull)result mac:(NSString * _Nullable)mac did:(NSString * _Nullable)did productKey:(NSString * _Nullable)productKey{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    if (result.code == GIZ_SDK_SUCCESS) {
//        //设备信息
//        [GizManage shareInstance].did = did;
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"Configue Result") message:LocalString(@"SUCCESSFUL!") preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"I know") style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:cancelAction];
//        [self presentViewController:alert animated:YES completion:nil];
//        
//        [[GizWifiSDK sharedInstance] bindRemoteDevice:[GizManage shareInstance].uid token:[GizManage shareInstance].token mac:mac productKey:productKey productSecret:GizAppproductSecret beOwner:NO];
//    }else{
//        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"Configue Result") message:LocalString(@"FAILED!") preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"I know") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }];
//        [alert addAction:cancelAction];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//}
//
//- (void)finishBackAction{
//    //返回上一级页面 取消配网功能
//    [[GizWifiSDK sharedInstance] stopDeviceOnboarding];//停止配网
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    UIViewController *viewCtl =self.navigationController.viewControllers[2];
//    [self.navigationController popToViewController:viewCtl animated:YES];
//}

@end
