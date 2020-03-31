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
@property (nonatomic, strong) UIButton *homeBtn;//回家充电
@property (nonatomic, strong) UIButton *stopedBtn;//停止工作

@property (nonatomic, strong) UIButton *areaSetBtn;
@property (nonatomic, strong) UIButton *timerSetBtn;

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
    _homeBtn = [self homeBtn];
    _stopedBtn = [self stopedBtn];
    _areaSetBtn = [self areaSetBtn];
    _timerSetBtn = [self timerSetBtn];
    
    _timer = [self timer];
    
    //设置打开/关闭抽屉的手势
//    self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
//    self.drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    //校准时间
    [self setMowerTime];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [GizWifiSDK sharedInstance].delegate = self;
    
    //连上设备立马获取主页面信息
    [self getMainDeviceMsg];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMainDeviceMsg:) name:@"getMainDeviceMsg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goHomeSuccess) name:@"getHome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goStopSuccess) name:@"getStop" object:nil];
    
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
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getMainDeviceMsg) userInfo:nil repeats:YES];
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
        
        [_batteryCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(217.f), yAutoFit(300)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHight + yAutoFit(20.f));
        }];
        
        self.batteryCircleView.progress = 0.75;
        
        _robotStateLabel = [[UILabel alloc] init];
        _robotStateLabel.text = @"charging";
        _robotStateLabel.font = [UIFont systemFontOfSize:17.f];
        _robotStateLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        _robotStateLabel.textAlignment = NSTextAlignmentCenter;
        _robotStateLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:_robotStateLabel];
        [_robotStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(100.f), yAutoFit(20.f)));
            make.centerX.equalTo(self.batteryCircleView.mas_centerX);
            make.top.equalTo(self.batteryCircleView.centerLabel.mas_bottom).offset(yAutoFit(20.f));
        }];
        
    }
    return _batteryCircleView;
}

- (UIView *)msgCenterView{
    if (!_msgCenterView) {
        _msgCenterView = [[UIView alloc] initWithFrame:CGRectMake(0,350, ScreenWidth, 60.f)];
        _msgCenterView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_msgCenterView];
        
        UIImageView *areaImg = [[UIImageView alloc] init];
        [areaImg setImage:[UIImage imageNamed:@"area_img"]];
        [_msgCenterView addSubview:areaImg];
        [areaImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.equalTo(self.msgCenterView.mas_left).offset(yAutoFit(40));
            make.centerY.equalTo(self.msgCenterView.mas_centerY);
        }];
        UILabel *arealabel = [[UILabel alloc] init];
        arealabel.text = LocalString(@"Mowing area");
        arealabel.font = [UIFont systemFontOfSize:14.f];
        arealabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        arealabel.textAlignment = NSTextAlignmentCenter;
        arealabel.adjustsFontSizeToFitWidth = YES;
        [_msgCenterView addSubview:arealabel];
        [arealabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.centerY.equalTo(self.msgCenterView.mas_centerY).offset(-10);
            make.left.equalTo(areaImg.mas_right).offset(10);
        }];
        _areaDatalabel = [[UILabel alloc] init];
        _areaDatalabel.text = [NSString stringWithFormat:@"%@%@",@"500",LocalString(@"m²")];
        _areaDatalabel.font = [UIFont systemFontOfSize:14.f];
        _areaDatalabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        _areaDatalabel.textAlignment = NSTextAlignmentCenter;
        _areaDatalabel.adjustsFontSizeToFitWidth = YES;
        [_msgCenterView addSubview:_areaDatalabel];
        [_areaDatalabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.centerY.equalTo(self.msgCenterView.mas_centerY).offset(10);
            make.left.equalTo(areaImg.mas_right).offset(10);
        }];
        
        UIImageView *timeImg = [[UIImageView alloc] init];
        [timeImg setImage:[UIImage imageNamed:@"workTime_img"]];
        [_msgCenterView addSubview:timeImg];
        [timeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.right.equalTo(self.msgCenterView.mas_right).offset(yAutoFit(-100));
            make.centerY.equalTo(self.msgCenterView.mas_centerY);
        }];
        
        UILabel *timelabel = [[UILabel alloc] init];
        timelabel.text = LocalString(@"Next Working");
        timelabel.font = [UIFont systemFontOfSize:14.f];
        timelabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        timelabel.textAlignment = NSTextAlignmentCenter;
        timelabel.adjustsFontSizeToFitWidth = YES;
        [_msgCenterView addSubview:timelabel];
        [timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.centerY.equalTo(self.msgCenterView.mas_centerY).offset(-10);
            make.left.equalTo(timeImg.mas_right).offset(10);
        }];
        _timeDatalabel = [[UILabel alloc] init];
        _timeDatalabel.text = @"9:30";
        _timeDatalabel.font = [UIFont systemFontOfSize:14.f];
        _timeDatalabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        _timeDatalabel.textAlignment = NSTextAlignmentCenter;
        _timeDatalabel.adjustsFontSizeToFitWidth = YES;
        [_msgCenterView addSubview:_timeDatalabel];
        [_timeDatalabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.centerY.equalTo(self.msgCenterView.mas_centerY).offset(10);
            make.left.equalTo(timeImg.mas_right).offset(10);
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
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(40)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.msgCenterView.mas_bottom).offset(yAutoFit(30));
        }];
        
        _robotErrorLabel = [[UILabel alloc] init];
        _robotErrorLabel.font = [UIFont systemFontOfSize:15.f];
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

- (UIButton *)stopedBtn{
    if (!_stopedBtn) {
        _stopedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopedBtn setTitle:LocalString(@"Stoped") forState:UIControlStateNormal];
        [_stopedBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_stopedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_stopedBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.f]];
        [_stopedBtn addTarget:self action:@selector(stoped) forControlEvents:UIControlEventTouchUpInside];
        _stopedBtn.enabled = YES;
        [self.view addSubview:_stopedBtn];
        [_stopedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(160), yAutoFit(45)));
            make.left.equalTo(self.bgTipView.mas_left);
            make.top.equalTo(self.bgTipView.mas_bottom).offset(yAutoFit(20));
        }];
        
        _stopedBtn.layer.borderWidth = 0.5;
        _stopedBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _stopedBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _stopedBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _stopedBtn.layer.shadowRadius = 3;
        _stopedBtn.layer.shadowOpacity = 1;
        _stopedBtn.layer.cornerRadius = 2.5;
    }
    return _stopedBtn;
}

- (UIButton *)homeBtn{
    if (!_homeBtn) {
        _homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_homeBtn setTitle:LocalString(@"Home") forState:UIControlStateNormal];
        [_homeBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_homeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_homeBtn setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.f]];
        [_homeBtn addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
        _homeBtn.enabled = YES;
        [self.view addSubview:_homeBtn];
        [_homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(160), yAutoFit(45)));
            make.right.equalTo(self.bgTipView.mas_right);
            make.top.equalTo(self.bgTipView.mas_bottom).offset(yAutoFit(20));
        }];
        
        _homeBtn.layer.borderWidth = 0.5;
        _homeBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _homeBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _homeBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _homeBtn.layer.shadowRadius = 3;
        _homeBtn.layer.shadowOpacity = 1;
        _homeBtn.layer.cornerRadius = 2.5;
    }
    return _homeBtn;
}

- (UIButton *)timerSetBtn{
    if (!_timerSetBtn) {
        _timerSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timerSetBtn setTitle:LocalString(@"Timer") forState:UIControlStateNormal];
        [_timerSetBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_timerSetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_timerSetBtn setBackgroundColor:[UIColor colorWithRed:253/255.0 green:134/255.0 blue:8/255.0 alpha:1.f]];
        [_timerSetBtn addTarget:self action:@selector(setWorkTime) forControlEvents:UIControlEventTouchUpInside];
        _timerSetBtn.enabled = YES;
        [self.view addSubview:_timerSetBtn];
        [_timerSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth/2, yAutoFit(45)));
            make.left.equalTo(self.view.mas_left);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _timerSetBtn.layer.borderWidth = 0.5;
        _timerSetBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _timerSetBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _timerSetBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _timerSetBtn.layer.shadowRadius = 3;
        _timerSetBtn.layer.shadowOpacity = 1;
        _timerSetBtn.layer.cornerRadius = 2.5;
    }
    return _timerSetBtn;
}

- (UIButton *)areaSetBtn{
    if (!_areaSetBtn) {
        _areaSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_areaSetBtn setTitle:LocalString(@"Area set") forState:UIControlStateNormal];
        [_areaSetBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_areaSetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_areaSetBtn setBackgroundColor:[UIColor colorWithRed:220/255.0 green:168/255.0 blue:11/255.0 alpha:1.f]];
        [_areaSetBtn addTarget:self action:@selector(setArea) forControlEvents:UIControlEventTouchUpInside];
        _areaSetBtn.enabled = YES;
        [self.view addSubview:_areaSetBtn];
        [_areaSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth/2, yAutoFit(45)));
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _areaSetBtn.layer.borderWidth = 0.5;
        _areaSetBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _areaSetBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _areaSetBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _areaSetBtn.layer.shadowRadius = 3;
        _areaSetBtn.layer.shadowOpacity = 1;
        _areaSetBtn.layer.cornerRadius = 2.5;
    }
    return _areaSetBtn;
}

#pragma mark - notification

- (void)getMainDeviceMsg:(NSNotification *)notification{
    
    //停掉重发机制
    [_timer setFireDate:[NSDate distantFuture]];
    /*
     robotState机器状态:
     离线（0x00）、工作（0x01）、充电（0x02）、待机（0x03）
     robotError机器故障：
     电量错误（0x00）、信号错误（0x01）、PCB错误（0x02）、割草机倾斜（0x03）、正常（0xFE）。
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
            
            self->robotStateStr = [NSString stringWithFormat:@"%@",LocalString(@"离线")];
            
            break;
        case 1:
            
            self->robotStateStr = [NSString stringWithFormat:@"%@",LocalString(@"工作")];
            
            break;
        case 2:
        {
            self->robotStateStr = [NSString stringWithFormat:@"%@",LocalString(@"充电")];
            //开启查询电量
            [_timer setFireDate:[NSDate date]];
            
        }
            break;
            
        default:
            self->robotStateStr = [NSString stringWithFormat:@"%@",LocalString(@"待机")];
            
            break;
    }
    switch ([robotError integerValue]) {
        case 0x00:
            
            self->robotErrorStr = [NSString stringWithFormat:@"%@",LocalString(@"电量错误")];
            
            break;
        case 0x01:
            
            self->robotErrorStr = [NSString stringWithFormat:@"%@",LocalString(@"信号错误")];
            
            break;
        case 0x02:
            
            self->robotErrorStr = [NSString stringWithFormat:@"%@",LocalString(@"PCB错误")];
            
            break;
            
        case 0x03:
            
            self->robotErrorStr = [NSString stringWithFormat:@"%@",LocalString(@"割草机倾斜")];
            
            break;
        
        default:
            self->robotStateStr = [NSString stringWithFormat:@"%@",LocalString(@"正常")];
            
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.robotErrorLabel.text = self->robotErrorStr;
        self.robotStateLabel.text = self->robotStateStr;
        self.timeDatalabel.text = [NSString stringWithFormat:@"%d:%d",[nextWorkHour intValue],[nextWorkMinute intValue]];
        self.batteryCircleView.progress = [robotPower floatValue]*0.01;
        //电量充满时停止查询
        if ([robotPower intValue] == 100) {
            //停掉查询
            [self.timer setFireDate:[NSDate distantFuture]];
        }
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
