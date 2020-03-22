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

@interface MainViewController ()<GizWifiSDKDelegate>

//@property(nonatomic,strong) MMDrawerController * drawerController;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *msgCenterView;
@property (nonatomic, strong) UILabel *areaDatalabel;//下一次割草面积
@property (nonatomic, strong) UILabel *timeDatalabel;//下一次工作时间

@property (nonatomic, strong) UIView *bgTipView;
@property (nonatomic, strong) UILabel *warningLabel;//故障信息
@property (nonatomic, strong) UIButton *homeBtn;//回家充电
@property (nonatomic, strong) UIButton *stopedBtn;//停止工作

@property (nonatomic, strong) UIButton *areaSetBtn;
@property (nonatomic, strong) UIButton *timerSetBtn;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavItem];
    _headerView = [self headerView];
    _msgCenterView = [self msgCenterView];
    _warningLabel = [self warningLabel];
    _homeBtn = [self homeBtn];
    _stopedBtn = [self stopedBtn];
    _areaSetBtn = [self areaSetBtn];
    _timerSetBtn = [self timerSetBtn];
    
    //设置打开/关闭抽屉的手势
//    self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
//    self.drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    //校准时间
    [self setMowerTime];
    //连上设备立马获取主页面信息
    //[[NetWorkManager shareNetWorkManager] getMainDeviceMsg];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [GizWifiSDK sharedInstance].delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMainDeviceMsg:) name:@"getMainDeviceMsg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goHomeSuccess) name:@"getHome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goStopSuccess) name:@"getStop" object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
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

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,350.f)];
        _headerView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_headerView];
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:_headerView.bounds];
        [bgImg setImage:[UIImage imageNamed:@"img_mine_headerBG"]];
        [_headerView addSubview:bgImg];
        [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(208), yAutoFit(197)));
            make.centerX.equalTo(self.headerView.mas_centerX);
            make.centerY.equalTo(self.headerView.mas_centerY);
        }];
        
//        _areaDatalabel = [[UILabel alloc] init];
//        _areaDatalabel.text = @"5555";
//        _areaDatalabel.font = [UIFont systemFontOfSize:17.f];
//        _areaDatalabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
//        _areaDatalabel.textAlignment = NSTextAlignmentCenter;
//        _areaDatalabel.adjustsFontSizeToFitWidth = YES;
//        [_headerView addSubview:_areaDatalabel];
//        [_areaDatalabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(300, 24));
//            make.centerX.equalTo(self.headerView.mas_centerX);
//            make.top.equalTo(headButton.mas_bottom).offset(12);
//        }];
    }
    return _headerView;
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

- (UILabel *)warningLabel{
    if (!_warningLabel) {
        _bgTipView = [[UIView alloc] init];
        _bgTipView.backgroundColor = [UIColor colorWithHexString:@"C9C9C9"];
        [self.view addSubview:_bgTipView];
        [_bgTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(40)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.msgCenterView.mas_bottom).offset(yAutoFit(30));
        }];
        
        _warningLabel = [[UILabel alloc] init];
        _warningLabel.font = [UIFont systemFontOfSize:15.f];
        _warningLabel.backgroundColor = [UIColor clearColor];
        _warningLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _warningLabel.textAlignment = NSTextAlignmentCenter;
        _warningLabel.text = LocalString(@"Connect your robot mower:");
        _warningLabel.adjustsFontSizeToFitWidth = YES;
        [_bgTipView addSubview:_warningLabel];
        [self.warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(40)));
            make.centerX.mas_equalTo(self.bgTipView.mas_centerX);
            make.centerY.mas_equalTo(self.bgTipView.mas_centerY);
        }];
        
    }
    return _warningLabel;
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
    NSDictionary *dict = [notification userInfo];
    NSNumber *robotPower = dict[@"robotPower"];
    NSNumber *robotState = dict[@"robotState"];
    NSNumber *robotError = dict[@"robotError"];
    NSNumber *nextWorktime = dict[@"nextWorktime"];
    NSNumber *nextWorkarea = dict[@"nextWorkarea"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.warningLabel.text = [NSString stringWithFormat:@"%d",[robotError intValue]];
        self.timeDatalabel.text = [NSString stringWithFormat:@"%d",[nextWorktime intValue]];
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
