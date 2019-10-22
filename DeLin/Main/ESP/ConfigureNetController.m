//
//  ConfigureNetController.m
//  steamRoom
//
//  Created by 安建伟 on 2019/7/18.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "ConfigureNetController.h"
//#import "AAProgressCircleView.h"
//#import "MyDeviceViewController.h"

@interface ConfigureNetController () <GizWifiSDKDelegate>

//@property (nonatomic, strong) UIView *backgroundView;
//@property (nonatomic, strong) UIButton *connectButton;
//
//@property (nonatomic, strong) AAProgressCircleView *circleView;

@end

@implementation ConfigureNetController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1].CGColor;
    self.navigationItem.title = LocalString(@"连接设备中");
//    self.backgroundView = [self backgroundView];
//    self.connectButton = [self connectButton];
    
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [GizWifiSDK sharedInstance].delegate = self;
//    
//    GizManage *manager = [GizManage shareInstance];
//    NSLog(@"ssid---%@",manager.ssid);
//    NSLog(@"key---%@",manager.key);
//    //airlink配网模式
//    [[GizWifiSDK sharedInstance] setDeviceOnboardingDeploy:manager.ssid key:manager.key configMode:GizWifiAirLink softAPSSIDPrefix:nil timeout:60 wifiGAgentType:[NSArray arrayWithObjects:@(GizGAgentESP), nil] bind:NO];
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    
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
////        UITextView *textView = [[UITextView alloc] init];
////        textView.backgroundColor = [UIColor clearColor];
////        textView.text = LocalString(@"1.请将手机连接到如下热点: ESP-XXXX 密码是:123456789\n2.返回本应用，继续添加设备");
////        textView.font = [UIFont systemFontOfSize:17.f];
////        textView.textAlignment = NSTextAlignmentLeft;
////        textView.textColor = [UIColor blackColor];
////        textView.editable = NO;
////        [_backgroundView addSubview:textView];
////        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.size.mas_equalTo(CGSizeMake(yAutoFit(290.f), 350.f));
////            make.top.equalTo(titleLabel.mas_bottom).offset(20.f);
////            make.centerX.equalTo(self.backgroundView.mas_centerX);
////        }];
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
//- (UIButton *)connectButton{
//    if (!_connectButton) {
//        _connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_connectButton setTitleColor:[UIColor colorWithHexString:@"639DF8"] forState:UIControlStateNormal];
//        [_connectButton setTitle:LocalString(@"取消") forState:UIControlStateNormal];
//        [_connectButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:20]];
//        [_connectButton addTarget:self action:@selector(Cancel) forControlEvents:UIControlEventTouchUpInside];
//        [self.backgroundView addSubview:_connectButton];
//        [_connectButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(yAutoFit(280.f), 50.f));
//            make.bottom.equalTo(self.backgroundView.mas_bottom).offset(-30.f);
//            make.centerX.equalTo(self.backgroundView.mas_centerX);
//        }];
//        
//        _connectButton.layer.borderColor = [UIColor colorWithRed:57/255.0 green:135/255.0 blue:248/255.0 alpha:1.0].CGColor;
//        _connectButton.layer.borderWidth = 1.f;
//        _connectButton.layer.cornerRadius = 25.f;
//    }
//    return _connectButton;
//}
//
//#pragma mark - Actions
//
//-(void)Cancel{
//    //返回上一级页面 取消配网功能
//    [[GizWifiSDK sharedInstance] stopDeviceOnboarding];//停止配网
//    
//    UIViewController *viewCtl =self.navigationController.viewControllers[2];
//    [self.navigationController popToViewController:viewCtl animated:YES];
//}
//
//// 实现回调  远程设备绑定
//- (void)wifiSDK:(GizWifiSDK *)wifiSDK didBindDevice:(NSError *)result did:(NSString *)did {
//    if(result.code == GIZ_SDK_SUCCESS) {
//        // 绑定成功
//        NSLog(@"绑定成功");
//        NSLog(@"%@",result);
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
//    }
//    
//}
//
//#pragma mark - Giz delegate
//-(void)wifiSDK:(GizWifiSDK *)wifiSDK didSetDeviceOnboarding:(NSError * _Nonnull)result mac:(NSString * _Nullable)mac did:(NSString * _Nullable)did productKey:(NSString * _Nullable)productKey{
//    
//    if (result.code == GIZ_SDK_SUCCESS) {
//        
//        self.circleView.percent = 1;
//        [self.circleView deleteTimer];
//        [self.circleView configSecondAnimate];
//        //设备信息保存
//        [GizManage shareInstance].did = did;
//        //设备绑定
//        [[GizWifiSDK sharedInstance] bindRemoteDevice:[GizManage shareInstance].uid token:[GizManage shareInstance].token mac:mac productKey:productKey productSecret:GizAppproductSecret beOwner:NO];
//        //延时2秒
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"Configue Result") message:LocalString(@"SUCCESSFUL!") preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"I know") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                NSLog(@"action = %@",action);
//                
//                MyDeviceViewController *myDeviceVC = [[MyDeviceViewController alloc] init];
//                [self.navigationController pushViewController:myDeviceVC animated:YES];
//                
//            }];
//            [alert addAction:cancelAction];
//            [self presentViewController:alert animated:YES completion:nil];
//        });
//        
//    }else{
//        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"Configue Result") message:LocalString(@"FAILED!") preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"I know") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            NSLog(@"action = %@",action);
//        }];
//        [alert addAction:cancelAction];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//}

@end
