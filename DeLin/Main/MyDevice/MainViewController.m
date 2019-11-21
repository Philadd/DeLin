//
//  MainViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/14.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "MainViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface MainViewController ()<GizWifiSDKDelegate>

@property(nonatomic,strong) MMDrawerController * drawerController;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *msgCenterView;
@property (nonatomic, strong) UILabel *areaDatalabel;
@property (nonatomic, strong) UILabel *timeDatalabel;

@property (nonatomic, strong) UIView *bgTipView;
@property (nonatomic, strong) UILabel *warningLabel;//故障信息
@property (nonatomic, strong) UIButton *homeBtn;//回家充电
@property (nonatomic, strong) UIButton *stopedBtn;//停止工作

@property (nonatomic, strong) UIView *bgSetWorkView;

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
    _bgSetWorkView = [self bgSetWorkView];
    
    //设置打开/关闭抽屉的手势
    self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [GizWifiSDK sharedInstance].delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - Lazy load
- (void)setNavItem{
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 30, 30);
    [leftButton setImage:[UIImage imageNamed:@"userInfo_Btn"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftDrawer) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,350.f)];
        _headerView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:_headerView];
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:_headerView.bounds];
        [bgImg setImage:[UIImage imageNamed:@"img_mine_headerBG"]];
        [_headerView addSubview:bgImg];
        [_headerView sendSubviewToBack:bgImg];
        
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
        arealabel.textColor = [UIColor colorWithRed:33/255.0 green:36/255.0 blue:55/255.0 alpha:1];
        arealabel.textAlignment = NSTextAlignmentCenter;
        arealabel.adjustsFontSizeToFitWidth = YES;
        [_msgCenterView addSubview:arealabel];
        [arealabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.centerY.equalTo(self.msgCenterView.mas_centerY).offset(-10);
            make.left.equalTo(areaImg.mas_right).offset(10);
        }];
        _areaDatalabel = [[UILabel alloc] init];
        _areaDatalabel.text = @"9:30";
        _areaDatalabel.font = [UIFont systemFontOfSize:14.f];
        _areaDatalabel.textColor = [UIColor colorWithRed:33/255.0 green:36/255.0 blue:55/255.0 alpha:1];
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
        timelabel.textColor = [UIColor colorWithRed:33/255.0 green:36/255.0 blue:55/255.0 alpha:1];
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
        _timeDatalabel.textColor = [UIColor colorWithRed:33/255.0 green:36/255.0 blue:55/255.0 alpha:1];
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

- (UIView *)bgSetWorkView{
    if (!_bgSetWorkView) {
        _bgSetWorkView = [[UIView alloc] init];
        _bgSetWorkView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_bgSetWorkView];
        [_bgSetWorkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(60)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.stopedBtn.mas_bottom).offset(yAutoFit(30));
        }];
        
        UIImageView *timeImg = [[UIImageView alloc] init];
        [timeImg setImage:[UIImage imageNamed:@"setWorkTime_img"]];
        [_bgSetWorkView addSubview:timeImg];
        [timeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.equalTo(self.msgCenterView.mas_left).offset(yAutoFit(30));
            make.centerY.equalTo(self.bgSetWorkView.mas_centerY);
        }];
        
        UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [timeButton setTitle:LocalString(@"Timer") forState:UIControlStateNormal];
        [timeButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [timeButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        timeButton.backgroundColor = [UIColor clearColor];
        [timeButton addTarget:self action:@selector(setWorkTime) forControlEvents:UIControlEventTouchUpInside];
        [self.bgSetWorkView addSubview:timeButton];
        [timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.centerY.equalTo(self.bgSetWorkView.mas_centerY);
            make.left.equalTo(timeImg.mas_right).offset(10);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor blackColor];
        [self.bgSetWorkView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(1, yAutoFit(30)));
            make.centerX.equalTo(self.bgSetWorkView.mas_centerX);
            make.centerY.equalTo(self.bgSetWorkView.mas_centerY);
        }];
        
        
        UIImageView *areaImg = [[UIImageView alloc] init];
        [areaImg setImage:[UIImage imageNamed:@"area_img"]];
        [_bgSetWorkView addSubview:areaImg];
        [areaImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.right.equalTo(self.msgCenterView.mas_right).offset(yAutoFit(-120));
            make.centerY.equalTo(self.bgSetWorkView.mas_centerY);
        }];
        
        UIButton *areaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [areaButton setTitle:LocalString(@"Area set") forState:UIControlStateNormal];
        [areaButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [areaButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        areaButton.backgroundColor = [UIColor clearColor];
        [areaButton addTarget:self action:@selector(setArea) forControlEvents:UIControlEventTouchUpInside];
        [_bgSetWorkView addSubview:areaButton];
        [areaButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.centerY.equalTo(self.bgSetWorkView.mas_centerY);
            make.left.equalTo(areaImg.mas_right).offset(10);
        }];
        
        
    }
    return _bgSetWorkView;
}

#pragma mark - 左侧抽屉
- (void)leftDrawer{
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - Actions

- (void)stoped{
    
    
}
- (void)goHome{
    
    
}
- (void)setWorkTime{
    
    
}
- (void)setArea{
    
    
}

@end
