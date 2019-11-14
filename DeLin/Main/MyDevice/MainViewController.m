//
//  MainViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/14.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()<GizWifiSDKDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *msgCenterView;
@property (nonatomic, strong) UILabel *powerLabel;
@property (nonatomic, strong) UIButton *homeBtn;
@property (nonatomic, strong) UIButton *stopedBtn;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _headerView = [self headerView];
    _msgCenterView = [self msgCenterView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [GizWifiSDK sharedInstance].delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - Lazyload
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 220.f)];
        [self.view addSubview:_headerView];
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:_headerView.bounds];
        [bgImg setImage:[UIImage imageNamed:@"img_mine_headerBG"]];
        [_headerView addSubview:bgImg];
        [_headerView sendSubviewToBack:bgImg];
        
        UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [headButton setImage:[UIImage imageNamed:@"img_mine_header"] forState:UIControlStateNormal];
        [headButton addTarget:self action:@selector(accountSetAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:headButton];
        [headButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 70));
            make.centerX.equalTo(self.headerView.mas_centerX);
            make.top.equalTo(self.headerView.mas_top).offset(64);
        }];
        
        _powerLabel = [[UILabel alloc] init];
        _powerLabel.text = @"5555";
        _powerLabel.font = [UIFont systemFontOfSize:17.f];
        _powerLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        _powerLabel.textAlignment = NSTextAlignmentCenter;
        _powerLabel.adjustsFontSizeToFitWidth = YES;
        [_headerView addSubview:_powerLabel];
        [_powerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300, 24));
            make.centerX.equalTo(self.headerView.mas_centerX);
            make.top.equalTo(headButton.mas_bottom).offset(12);
        }];
    }
    return _headerView;
}

-(UIView *)msgCenterView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 230, ScreenWidth, 220.f)];
        [self.view addSubview:_headerView];
        UIImageView *timeImg = [[UIImageView alloc] initWithFrame:_headerView.bounds];
        [timeImg setImage:[UIImage imageNamed:@"img_mine_headerBG"]];
        [_headerView addSubview:timeImg];
        [_headerView sendSubviewToBack:timeImg];
        
        _powerLabel = [[UILabel alloc] init];
        _powerLabel.text = @"5555";
        _powerLabel.font = [UIFont systemFontOfSize:17.f];
        _powerLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        _powerLabel.textAlignment = NSTextAlignmentCenter;
        _powerLabel.adjustsFontSizeToFitWidth = YES;
        [_headerView addSubview:_powerLabel];
        [_powerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300, 24));
            make.centerX.equalTo(self.headerView.mas_centerX);
            make.top.equalTo(self.view.mas_bottom).offset(12);
        }];
    }
    return _msgCenterView;
}

@end
