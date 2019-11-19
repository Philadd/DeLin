//
//  finishViewController.m
//  MOWOX
//
//  Created by 安建伟 on 2018/12/17.
//  Copyright © 2018 yusz. All rights reserved.
//

#import "FinishNetworkViewController.h"
#import "AAProgressCircleView.h"

@interface FinishNetworkViewController () <GizWifiSDKDelegate>

@property (nonatomic, strong) UILabel *connectingLabel;
@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) AAProgressCircleView *networkProgressView;

@end

@implementation FinishNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *image = [UIImage imageNamed:@"返回1"];
    [self addLeftBarButtonWithImage:image action:@selector(finishBackAction)];
    
    [self setNavItem];
    _connectingLabel = [self connectingLabel];
    _finishBtn = [self finishBtn];
    self.networkProgressView = [self networkProgressView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [GizWifiSDK sharedInstance].delegate = self;
    
    GizManager *manager = [GizManager shareInstance];
    NSLog(@"ssid---%@",manager.ssid);
    NSLog(@"key---%@",manager.key);
    //开始配网状态
    //ap配网模式
    [[GizWifiSDK sharedInstance] setDeviceOnboardingDeploy:manager.ssid key:manager.key configMode:GizWifiSoftAP softAPSSIDPrefix:@"XPG-GAgent-" timeout:60 wifiGAgentType:nil bind:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

#pragma mark - Lazy load
- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Add Robot");

}

- (UILabel *)connectingLabel{
    if (!_connectingLabel) {
        _connectingLabel = [[UILabel alloc] init];
        _connectingLabel.font = [UIFont systemFontOfSize:24.f];
        _connectingLabel.backgroundColor = [UIColor clearColor];
        _connectingLabel.textColor = [UIColor blackColor];
        _connectingLabel.textAlignment = NSTextAlignmentLeft;
        _connectingLabel.text = LocalString(@"Connecting...");
        [self.view addSubview:_connectingLabel];
        [_connectingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(50)));
            make.left.equalTo(self.view.mas_left).offset(yAutoFit(40));
            make.top.equalTo(self.view.mas_top).offset(yAutoFit(80));
        }];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.text = LocalString(@"Place your router,mobile phone,and device as close as possible.");
        tipLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        tipLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [tipLabel setLineBreakMode:NSLineBreakByWordWrapping];
        tipLabel.numberOfLines = 0;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:tipLabel];
        
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320.f), 80.f));
            make.left.equalTo(self.view.mas_left).offset(yAutoFit(40.f));
            make.top.equalTo(self.connectingLabel.mas_bottom).offset(yAutoFit(20.f));
        }];
        
    }
    return _connectingLabel;
}

- (AAProgressCircleView *)networkProgressView{
    if (!_networkProgressView) {
        //圆形进度图
        _networkProgressView = [[AAProgressCircleView alloc]init];
        [_networkProgressView didCircleProgressAction];
        [self.view addSubview:_networkProgressView];
        
        [_networkProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(217.f), yAutoFit(300)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.connectingLabel.mas_bottom).offset(yAutoFit(100.f));
        }];
        
    }
    return _networkProgressView;
}

//- (UIButton *)finishBtn{
//    if (!_finishBtn) {
//        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_finishBtn setTitle:LocalString(@"Finish") forState:UIControlStateNormal];
//        [_finishBtn.titleconnectingLabel setFont:[UIFont systemFontOfSize:18.f]];
//        [_finishBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
//        [_finishBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0f]];
//        [_finishBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
//        _finishBtn.enabled = YES;
//        [self.view addSubview:_finishBtn];
//        [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(50)));
//            make.top.equalTo(self.deviceImage.mas_bottom).offset(yAutoFit(130));
//            make.centerX.mas_equalTo(self.view.mas_centerX);
//        }];
//
//        _finishBtn.layer.borderWidth = 0.5;
//        _finishBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
//        _finishBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
//        _finishBtn.layer.shadowOffset = CGSizeMake(0,2.5);
//        _finishBtn.layer.shadowRadius = 3;
//        _finishBtn.layer.shadowOpacity = 1;
//        _finishBtn.layer.cornerRadius = 2.5;
//
//    }
//    return _finishBtn;
//}

#pragma mark - Actions

-(void)finish{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 实现回调  远程设备绑定
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didBindDevice:(NSError *)result did:(NSString *)did {
    if(result.code == GIZ_SDK_SUCCESS) {
        // 绑定成功
        NSLog(@"绑定成功");
        NSLog(@"远程设备绑定结果%@",result);
    } else {
        // 绑定失败
        NSLog(@"绑定失败");
    }
    
}

// 实现回调  配网终止
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didSetDeviceOnboarding:(NSError *)result device:(GizWifiDevice *)device {
    if(result.code == GIZ_SDK_ONBOARDING_STOPPED) {
        // 配网终止
        NSLog(@"配网终止");
    }
    
}

#pragma mark - Giz delegate
-(void)wifiSDK:(GizWifiSDK *)wifiSDK didSetDeviceOnboarding:(NSError * _Nonnull)result mac:(NSString * _Nullable)mac did:(NSString * _Nullable)did productKey:(NSString * _Nullable)productKey{
    
    if (result.code == GIZ_SDK_SUCCESS) {
        self.networkProgressView.percent = 1;
        [self.networkProgressView deleteTimer];
        [self.networkProgressView configSecondAnimate];
        //设备信息
        [GizManager shareInstance].did = did;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"Configue Result") message:LocalString(@"SUCCESSFUL!") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"I know") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"action = %@",action);
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        [[GizWifiSDK sharedInstance] bindRemoteDevice:[GizManager shareInstance].uid token:[GizManager shareInstance].token mac:mac productKey:productKey productSecret:GizAppproductSecret beOwner:NO];
        
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"Configue Result") message:LocalString(@"FAILED!") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"I know") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            NSLog(@"action = %@",action);
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)finishBackAction{
    //返回上一级页面 取消配网功能
    [[GizWifiSDK sharedInstance] stopDeviceOnboarding];//停止配网
    UIViewController *viewCtl =self.navigationController.viewControllers[2];
    [self.navigationController popToViewController:viewCtl animated:YES];
}

@end
