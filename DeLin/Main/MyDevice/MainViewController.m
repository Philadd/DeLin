//
//  MainViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/14.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "MainViewController.h"
//#import "MMDrawerController.h"
//#import "UIViewController+MMDrawerController.h"
#import "WorkAreaViewController.h"
#import "WorkTimeViewController.h"
#import "SetPinCodeViewController.h"
#import "BatteryIconCircleView.h"

@interface MainViewController ()<GizWifiSDKDelegate>

//@property(nonatomic,strong) MMDrawerController * drawerController;
@property(nonatomic,strong) BatteryIconCircleView *batteryCircleView;

@property (nonatomic, strong) UIView *msgCenterView;
@property (nonatomic, strong) UILabel *robotStateLabel;//机器状态
@property (nonatomic, strong) UILabel *areaDatalabel;//下一次割草面积
@property (nonatomic, strong) UILabel *timeDatalabel;//下一次工作时间

@property (nonatomic, strong) UIView *bgTipView;
@property (nonatomic, strong) UILabel *robotErrorLabel;//故障信息

@property (nonatomic, strong) UIButton *stopSetBtn;//停止工作
@property (nonatomic, strong) UIButton *homeSetBtn;//回家充电
@property (nonatomic, strong) UIButton *startSetBtn;//启动设备

@property (nonatomic, strong) UIButton *timerSetBtn;//工作时间设置
@property (nonatomic, strong) UIButton *areaSetBtn;//工作区域设置

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MainViewController
{
    NSString *robotStateStr;
    NSString *robotErrorStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavItem];
    
    _batteryCircleView = [self batteryCircleView];
    _msgCenterView = [self msgCenterView];
    _robotErrorLabel = [self robotErrorLabel];
    _stopSetBtn = [self stopSetBtn];
    _homeSetBtn = [self homeSetBtn];
    _startSetBtn = [self startSetBtn];
    _timerSetBtn = [self timerSetBtn];
    _areaSetBtn = [self areaSetBtn];
    
    _timer = [self timer];
    
    //设置打开/关闭抽屉的手势
    //    self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    //    self.drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    
    //延时1秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //校准时间
        [self setMowerTime];
    });
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [GizWifiSDK sharedInstance].delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMainDeviceMsg:) name:@"getMainDeviceMsg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goHomeSuccess) name:@"getHome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goStopSuccess) name:@"getStop" object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //主页面状态查询
        [self getMainDeviceMsg];
        //查询时钟同步开启
        [self.timer setFireDate:[NSDate date]];
        
    });
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _timer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getMainDeviceMsg" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getHome" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getStop" object:nil];
}

#pragma mark - Lazy load
- (void)setNavItem{
    
    self.navigationItem.title = LocalString(@"Device control");
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    [rightButton setImage:[UIImage imageNamed:@"img_main_pin"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(setPinCode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

- (NSTimer *)timer{
    if(!_timer){
        _timer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(getMainDeviceMsg) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate date]];
    }
    return _timer;
}

- (BatteryIconCircleView *)batteryCircleView{
    if (!_batteryCircleView) {
        //圆形进度图
        _batteryCircleView = [[BatteryIconCircleView alloc]init];
        _batteryCircleView.progressWidth = 10.0;
        _batteryCircleView.bottomCircleColor = [UIColor whiteColor];
        _batteryCircleView.topCircleColor = [UIColor blackColor];
        
        [self.view addSubview:_batteryCircleView];
        
        if (yDevice_Is_iPhoneX_iPhone11Pro || yDevice_Is_iPhoneXR_iPhone11 || yDevice_Is_iPhoneXS_MAX_iPhone11ProMax ) {
            
            [_batteryCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(247.f), yAutoFit(350)));
                make.centerX.equalTo(self.view.mas_centerX);
                make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHight + yAutoFit(50.f));
            }];
            
        }else{
            [_batteryCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(217.f), yAutoFit(300)));
                make.centerX.equalTo(self.view.mas_centerX);
                make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHight + yAutoFit(20.f));
            }];
            
        }
        self.batteryCircleView.progress = 1;
        
        _robotStateLabel = [[UILabel alloc] init];
        _robotStateLabel.text = @"charging";
        _robotStateLabel.font = [UIFont systemFontOfSize:17.f];
        _robotStateLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        _robotStateLabel.textAlignment = NSTextAlignmentCenter;
        _robotStateLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:_robotStateLabel];
        if (yDevice_Is_iPhoneX_iPhone11Pro || yDevice_Is_iPhoneXR_iPhone11 || yDevice_Is_iPhoneXS_MAX_iPhone11ProMax ) {
            
            [_robotStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(150.f), yAutoFit(30.f)));
                make.centerX.equalTo(self.batteryCircleView.mas_centerX);
                make.top.equalTo(self.batteryCircleView.centerLabel.mas_bottom).offset(yAutoFit(20.f));
            }];
            
        }else{
            [_robotStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(100.f), yAutoFit(20.f)));
                make.centerX.equalTo(self.batteryCircleView.mas_centerX);
                make.top.equalTo(self.batteryCircleView.centerLabel.mas_bottom).offset(yAutoFit(20.f));
            }];
            
        }
    }
    return _batteryCircleView;
}

- (UIView *)msgCenterView{
    if (!_msgCenterView) {
        
        if (yDevice_Is_iPhoneX_iPhone11Pro || yDevice_Is_iPhoneXR_iPhone11 || yDevice_Is_iPhoneXS_MAX_iPhone11ProMax ) {
            
            _areaSetBtn = [[UIButton alloc] initWithFrame:CGRectMake (yAutoFit(20), yAutoFit(450), ScreenWidth/2 - 30, yAutoFit(90))];
            _timerSetBtn = [[UIButton alloc] initWithFrame:CGRectMake (ScreenWidth/2 + 30 , yAutoFit(450), ScreenWidth/2 - 30, yAutoFit(90))];
        }else{
        
            _areaSetBtn = [[UIButton alloc] initWithFrame:CGRectMake (yAutoFit(20), yAutoFit(350), ScreenWidth/2 -30, yAutoFit(60.f))];
            _timerSetBtn = [[UIButton alloc] initWithFrame:CGRectMake (ScreenWidth/2 + 30 , yAutoFit(350), ScreenWidth/2 - 30, yAutoFit(60.f))];
        }
        _areaSetBtn.backgroundColor = [UIColor clearColor];
        _timerSetBtn.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_areaSetBtn];
        [self.view addSubview:_timerSetBtn];
        
        [_areaSetBtn addTarget:self action:@selector(setArea) forControlEvents:UIControlEventTouchUpInside];
        _areaSetBtn.enabled = YES;
        [_timerSetBtn addTarget:self action:@selector(setWorkTime) forControlEvents:UIControlEventTouchUpInside];
        _timerSetBtn.enabled = YES;
    
        UIImageView *areaImg = [[UIImageView alloc] init];
        [areaImg setImage:[UIImage imageNamed:@"area_img"]];
        [_areaSetBtn addSubview:areaImg];
        
        [areaImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(40), yAutoFit(40)));
            make.left.equalTo(self.areaSetBtn.mas_left);
            make.centerY.equalTo(self.areaSetBtn.mas_centerY);
        }];
        
        UILabel *arealabel = [[UILabel alloc] init];
        arealabel.text = LocalString(@"Mowing area");
        arealabel.font = [UIFont systemFontOfSize:15.f];
        arealabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        arealabel.textAlignment = NSTextAlignmentCenter;
        arealabel.adjustsFontSizeToFitWidth = YES;
        [_areaSetBtn addSubview:arealabel];

        [arealabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(60), yAutoFit(15)));
            make.centerY.equalTo(self.areaSetBtn.mas_centerY).offset(-yAutoFit(10));
            make.left.equalTo(areaImg.mas_right).offset(yAutoFit(10));
        }];

        _areaDatalabel = [[UILabel alloc] init];
        _areaDatalabel.text = [NSString stringWithFormat:@"%@%@",@"500",LocalString(@"m²")];
        _areaDatalabel.font = [UIFont systemFontOfSize:14.f];
        _areaDatalabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        _areaDatalabel.textAlignment = NSTextAlignmentCenter;
        _areaDatalabel.adjustsFontSizeToFitWidth = YES;
        [_areaSetBtn addSubview:_areaDatalabel];
        [_areaDatalabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(60), yAutoFit(15)));
            make.centerY.equalTo(self.areaSetBtn.mas_centerY).offset(yAutoFit(10));
            make.left.equalTo(areaImg.mas_right).offset(yAutoFit(10));
        }];

        UIImageView *timeImg = [[UIImageView alloc] init];
        [timeImg setImage:[UIImage imageNamed:@"workTime_img"]];
        [_timerSetBtn addSubview:timeImg];
        [timeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(40), yAutoFit(40)));
            make.left.equalTo(self.timerSetBtn.mas_left);
            make.centerY.equalTo(self.timerSetBtn.mas_centerY);
        }];

        UILabel *timelabel = [[UILabel alloc] init];
        timelabel.text = LocalString(@"Next Working");
        timelabel.font = [UIFont systemFontOfSize:14.f];
        timelabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        timelabel.textAlignment = NSTextAlignmentCenter;
        timelabel.adjustsFontSizeToFitWidth = YES;
        [_timerSetBtn addSubview:timelabel];
        [timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(60), yAutoFit(15)));
            make.centerY.equalTo(self.timerSetBtn.mas_centerY).offset(-yAutoFit(10));
            make.left.equalTo(timeImg.mas_right).offset(yAutoFit(10));
        }];
        _timeDatalabel = [[UILabel alloc] init];
        _timeDatalabel.text = @"9:30";
        _timeDatalabel.font = [UIFont systemFontOfSize:14.f];
        _timeDatalabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        _timeDatalabel.textAlignment = NSTextAlignmentCenter;
        _timeDatalabel.adjustsFontSizeToFitWidth = YES;
        [_timerSetBtn addSubview:_timeDatalabel];

        [_timeDatalabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(60), yAutoFit(15)));
            make.centerY.equalTo(self.timerSetBtn.mas_centerY).offset(yAutoFit(10));
            make.left.equalTo(timeImg.mas_right).offset(yAutoFit(10));
        }];
    }
    return _msgCenterView;
}

- (UILabel *)robotErrorLabel{
    if (!_robotErrorLabel) {
        _bgTipView = [[UIView alloc] init];
        _bgTipView.backgroundColor = [UIColor colorWithHexString:@"C9C9C9"];
        [self.view addSubview:_bgTipView];
        [_bgTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(60)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom).offset(yAutoFit(-150));
        }];

        _robotErrorLabel = [[UILabel alloc] init];
        _robotErrorLabel.font = [UIFont systemFontOfSize:18.f];
        _robotErrorLabel.backgroundColor = [UIColor clearColor];
        _robotErrorLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _robotErrorLabel.textAlignment = NSTextAlignmentCenter;
        _robotErrorLabel.text = LocalString(@"WARNING MASSAGE....");
        _robotErrorLabel.adjustsFontSizeToFitWidth = YES;
        [_bgTipView addSubview:_robotErrorLabel];
        [self.robotErrorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(40)));
            make.centerX.mas_equalTo(self.bgTipView.mas_centerX);
            make.centerY.mas_equalTo(self.bgTipView.mas_centerY);
        }];

    }
    return _robotErrorLabel;
}

- (UIButton *)stopSetBtn{
    if (!_stopSetBtn) {
        _stopSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopSetBtn setTitle:LocalString(@"STOP") forState:UIControlStateNormal];
        [_stopSetBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_stopSetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_stopSetBtn setBackgroundColor:[UIColor colorWithRed:220/255.0 green:168/255.0 blue:11/255.0 alpha:1.f]];
        [_stopSetBtn addTarget:self action:@selector(stoped) forControlEvents:UIControlEventTouchUpInside];
        _stopSetBtn.enabled = YES;
        [self.view addSubview:_stopSetBtn];
        [_stopSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth/3, yAutoFit(50)));
            make.left.equalTo(self.view.mas_left);
            make.bottom.equalTo(self.view.mas_bottom).offset(yAutoFit(-5));
        }];
        
        _stopSetBtn.layer.borderWidth = 0.5;
        _stopSetBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _stopSetBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _stopSetBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _stopSetBtn.layer.shadowRadius = 3;
        _stopSetBtn.layer.shadowOpacity = 1;
        _stopSetBtn.layer.cornerRadius = 2.5;
    }
    return _stopSetBtn;
}

- (UIButton *)homeSetBtn{
    if (!_homeSetBtn) {
        _homeSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_homeSetBtn setTitle:LocalString(@"HOME") forState:UIControlStateNormal];
        [_homeSetBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_homeSetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_homeSetBtn setBackgroundColor:[UIColor colorWithRed:253/255.0 green:134/255.0 blue:8/255.0 alpha:1.f]];
        [_homeSetBtn addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
        _homeSetBtn.enabled = YES;
        [self.view addSubview:_homeSetBtn];
        [_homeSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth/3, yAutoFit(50)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom).offset(yAutoFit(-5));
        }];
        
        _homeSetBtn.layer.borderWidth = 0.5;
        _homeSetBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _homeSetBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _homeSetBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _homeSetBtn.layer.shadowRadius = 3;
        _homeSetBtn.layer.shadowOpacity = 1;
        _homeSetBtn.layer.cornerRadius = 2.5;
    }
    return _homeSetBtn;
}

- (UIButton *)startSetBtn{
    if (!_startSetBtn) {
        _startSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startSetBtn setTitle:LocalString(@"START") forState:UIControlStateNormal];
        [_startSetBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_startSetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startSetBtn setBackgroundColor:[UIColor colorWithRed:220/255.0 green:168/255.0 blue:11/255.0 alpha:1.f]];
        [_startSetBtn addTarget:self action:@selector(goStart) forControlEvents:UIControlEventTouchUpInside];
        _startSetBtn.enabled = YES;
        [self.view addSubview:_startSetBtn];
        [_startSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth/3, yAutoFit(50)));
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom).offset(yAutoFit(-5));
        }];
        
        _startSetBtn.layer.borderWidth = 0.5;
        _startSetBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _startSetBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _startSetBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _startSetBtn.layer.shadowRadius = 3;
        _startSetBtn.layer.shadowOpacity = 1;
        _startSetBtn.layer.cornerRadius = 2.5;
    }
    return _startSetBtn;
}

#pragma mark - notification

- (void)getMainDeviceMsg:(NSNotification *)notification{
    
    //停掉重发机制
    //[_timer setFireDate:[NSDate distantFuture]];
    /*
     robotState机器状态:
     离线（0x00）、工作（0x01）、充电（0x02）、待机（0x03）
     robotError机器故障：
     正常（0x00）、急停传感器触发（0x01）、提升传感器触发（0x02）、出边界线（0x03）、边界线断开（0x04）、磁碰传感器触发（0x05）、左侧驱动电机异常（0x06）、右侧侧驱动电机异常（0x07）、割草电机异常（0x08）、充电异常（0x09）、主控板自测异常（0x0a）、倾角传感器触发（0x0b）、驱动轮长时间打滑（0x0c）、电池温度异常（0x0d）。
     */
    NSDictionary *dict = [notification userInfo];
    NSNumber *robotPower = dict[@"robotPower"];
    NSNumber *robotState = dict[@"robotState"];
    NSNumber *robotError = dict[@"robotError"];
    NSNumber *nextWorkHour = dict[@"nextWorkHour"];
    NSNumber *nextWorkMinute = dict[@"nextWorkMinute"];
    NSNumber *nextWorkarea = dict[@"nextWorkarea"];
    
    switch ([robotState integerValue]) {
        case 0:
            
            self->robotStateStr = [NSString stringWithFormat:@"%@",LocalString(@"Offline")];
            
            break;
        case 1:
            
            self->robotStateStr = [NSString stringWithFormat:@"%@",LocalString(@"Working")];
            
            break;
        case 2:
        {
            self->robotStateStr = [NSString stringWithFormat:@"%@",LocalString(@"Charging")];
            
        }
            break;
            
        default:
            self->robotStateStr = [NSString stringWithFormat:@"%@",LocalString(@"Standby")];
            
            break;
    }
    switch ([robotError integerValue]) {
        case 0x00:
            
            self->robotErrorStr = [NSString stringWithFormat:@"%@",LocalString(@"normal")];
            
            break;
        case 0x01:
            
            self->robotErrorStr = [NSString stringWithFormat:@"%@",LocalString(@"E1")];
            
            break;
        case 0x02:
            
            self->robotErrorStr = [NSString stringWithFormat:@"%@",LocalString(@"E2")];
            
            break;
            
        case 0x03:
            
            self->robotErrorStr = [NSString stringWithFormat:@"%@",LocalString(@"E3")];
            
            break;
        case 0x04:
            
            self->robotErrorStr = [NSString stringWithFormat:@"%@",LocalString(@"E4")];
            
            break;
        case 0x05:
            
            self->robotErrorStr = [NSString stringWithFormat:@"%@",LocalString(@"E5")];
            
            break;
        case 0x06:
            
            self->robotErrorStr = [NSString stringWithFormat:@"%@",LocalString(@"E6")];
            
            break;
            
        case 0x07:
            
            self->robotErrorStr = [NSString stringWithFormat:@"%@",LocalString(@"E7")];
            
            break;
            
        case 0x08:
            
            self->robotErrorStr = [NSString stringWithFormat:@"%@",LocalString(@"E8")];
            
            break;
        case 0x09:
            
            self->robotErrorStr = [NSString stringWithFormat:@"%@",LocalString(@"E9")];
            
            break;
        case 0x0a:
            
            self->robotErrorStr = [NSString stringWithFormat:@"%@",LocalString(@"E10")];
            
            break;
            
        case 0x0b:
            
            self->robotErrorStr = [NSString stringWithFormat:@"%@",LocalString(@"E11")];
            
            break;
            
        case 0x0c:
            
            self->robotErrorStr = [NSString stringWithFormat:@"%@",LocalString(@"E12")];
            
            break;
        case 0x0d:
            
            self->robotErrorStr = [NSString stringWithFormat:@"%@",LocalString(@"E13")];
            
            break;
            
        default:
            self->robotStateStr = [NSString stringWithFormat:@"%@",LocalString(@"normal")];
            
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.robotErrorLabel.text = self->robotErrorStr;
        self.robotStateLabel.text = self->robotStateStr;
        self.timeDatalabel.text = [NSString stringWithFormat:@"%02d:%02d",[nextWorkHour intValue],[nextWorkMinute intValue]];
        self.batteryCircleView.progress = [robotPower floatValue]*0.01;
        self.areaDatalabel.text = [NSString stringWithFormat:@"%d%@",[nextWorkarea intValue],LocalString(@"m²")];
    });
    
}

- (void)goHomeSuccess{
    
    NSLog(@"设置home成功");
}

- (void)goStopSuccess{
    
    NSLog(@"设置stop成功");
}

#pragma mark - Actions

- (void)getMainDeviceMsg{
    UInt8 controlCode = 0x01;
    NSArray *data = @[@0x00,@0x01,@0x00,@0x00];
    [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:data failuer:nil];
}
//校准机器时间
- (void)setMowerTime{
    NSDate *date = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];    //IOS 8 之后
    NSUInteger integer = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *dataCom = [currentCalendar components:integer fromDate:date];

    UInt8 controlCode = 0x01;
    NSArray *data = @[@0x00,@0x01,@0x03,@0x01,[NSNumber numberWithUnsignedInteger:[dataCom year] / 100],[NSNumber numberWithUnsignedInteger:[dataCom year] % 100],[NSNumber numberWithUnsignedInteger:[dataCom month]],[NSNumber numberWithUnsignedInteger:[dataCom day]],[NSNumber numberWithUnsignedInteger:[dataCom hour]],[NSNumber numberWithUnsignedInteger:[dataCom minute]]];
    
    [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:data failuer:nil];
}

- (void)stoped{
    
    UInt8 controlCode = 0x01;
    NSArray *data = @[@0x00,@0x01,@0x02,@0x01];
    [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:data failuer:nil];

}

- (void)goHome{
    
    UInt8 controlCode = 0x01;
    NSArray *data = @[@0x00,@0x01,@0x01,@0x01];
    [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:data failuer:nil];
    
}

- (void)goStart{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:LocalString(@"are you sure?") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:LocalString(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UInt8 controlCode = 0x01;
        NSArray *data = @[@0x00,@0x01,@0x09,@0x01];
        [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:data failuer:nil];
        
    }];
    //[okAction setValue:[UIColor ] forKey:@"titleTextColor"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    //[cancelAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)setWorkTime{
    
    WorkTimeViewController *WorkTimeVC = [[WorkTimeViewController alloc] init];
    [self.navigationController pushViewController:WorkTimeVC animated:YES];

}

- (void)setArea{
    WorkAreaViewController *WorkAreaVC = [[WorkAreaViewController alloc] init];
    [self.navigationController pushViewController:WorkAreaVC animated:YES];
    
}

- (void)setPinCode{
    SetPinCodeViewController *SetPinCodeVC = [[SetPinCodeViewController alloc] init];
    [self.navigationController pushViewController:SetPinCodeVC animated:YES];
    
}

@end
