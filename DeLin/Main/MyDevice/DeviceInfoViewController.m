//
//  DeviceInfoViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/12/7.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "LogoutViewController.h"
#import "PersonSettingViewController.h"
#import "SelectDeviceViewController.h"

@interface DeviceInfoViewController ()

@property (nonatomic, strong) UIView *msgCenterView;
@property (nonatomic, strong) UIButton *AddEquipmentBtn;

@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
    
    _msgCenterView = [self msgCenterView];
    _AddEquipmentBtn = [self AddEquipmentBtn];
    
    [self setNavItem];
    //开启自动登录
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isAutoLogin"] == NO) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isAutoLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

#pragma mark - Lazy load
- (void)setNavItem{
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 30, 30);
    [leftButton.widthAnchor constraintEqualToConstant:30].active = YES;
    [leftButton.heightAnchor constraintEqualToConstant:30].active = YES;
    [leftButton setImage:[UIImage imageNamed:@"img_setting_Btn"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    [rightButton.widthAnchor constraintEqualToConstant:30].active = YES;
    [rightButton.heightAnchor constraintEqualToConstant:30].active = YES;
    [rightButton setImage:[UIImage imageNamed:@"img_person_Btn"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(goPerson) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

- (UIView *)msgCenterView{
    if (!_msgCenterView) {
        _msgCenterView = [[UIView alloc] initWithFrame:CGRectMake(0,yAutoFit(70), ScreenWidth,ScreenHeight - yAutoFit(45))];
        _msgCenterView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_msgCenterView];
        
        UIImageView *areaImg = [[UIImageView alloc] init];
        [areaImg setImage:[UIImage imageNamed:@"img_deviceInfo"]];
        [_msgCenterView addSubview:areaImg];
        [areaImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(350)));
            make.top.equalTo(self.msgCenterView.mas_top).offset(yAutoFit(40));
            make.right.equalTo(self.msgCenterView.mas_right).offset(yAutoFit(-5.f));
        }];
        
        UIView *labelBgView = [[UIView alloc] initWithFrame:CGRectMake( 0 , yAutoFit(40) + yAutoFit(370), ScreenWidth,yAutoFit(200) )];
        labelBgView.backgroundColor = [UIColor clearColor];
        [_msgCenterView addSubview:labelBgView];
        
        UILabel *msglabel = [[UILabel alloc] init];
        msglabel.text = LocalString(@"control,Arrange the schedule,monitoring");
        msglabel.font = [UIFont systemFontOfSize:15.f];
        msglabel.textColor = [UIColor whiteColor];
        msglabel.textAlignment = NSTextAlignmentCenter;
        msglabel.adjustsFontSizeToFitWidth = YES;
        msglabel.numberOfLines = 0;
        [labelBgView addSubview:msglabel];
        [msglabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(300), yAutoFit(50)));
            make.centerX.equalTo(labelBgView.mas_centerX);
            make.top.equalTo(labelBgView.mas_top);
        }];
        
        UILabel *tiplabel = [[UILabel alloc] init];
        tiplabel.text = LocalString(@"Through APP take advantage of your equipment");
        tiplabel.font = [UIFont systemFontOfSize:13.f];
        tiplabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7];
        tiplabel.numberOfLines = 0;
        tiplabel.textAlignment = NSTextAlignmentCenter;
        tiplabel.adjustsFontSizeToFitWidth = YES;
        [labelBgView addSubview:tiplabel];
        [tiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(300), yAutoFit(80)));
            make.centerX.equalTo(labelBgView.mas_centerX);
            make.top.equalTo(msglabel.mas_bottom);
        }];
        
    }
    return _msgCenterView;
}


- (UIButton *)AddEquipmentBtn{
    if (!_AddEquipmentBtn) {
        _AddEquipmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_AddEquipmentBtn setTitle:LocalString(@"Add equipment") forState:UIControlStateNormal];
        [_AddEquipmentBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_AddEquipmentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_AddEquipmentBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        [_AddEquipmentBtn addTarget:self action:@selector(addEquipment) forControlEvents:UIControlEventTouchUpInside];
        _AddEquipmentBtn.enabled = YES;
        [self.view addSubview:_AddEquipmentBtn];
        [_AddEquipmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(45)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _AddEquipmentBtn.layer.borderWidth = 0.5;
        _AddEquipmentBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _AddEquipmentBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _AddEquipmentBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _AddEquipmentBtn.layer.shadowRadius = 3;
        _AddEquipmentBtn.layer.shadowOpacity = 1;
        _AddEquipmentBtn.layer.cornerRadius = 2.5;
    }
    return _AddEquipmentBtn;
}


#pragma mark - Giz回调

-(void)goSetting{
    
    PersonSettingViewController *PersonSettingVC = [[PersonSettingViewController alloc] init];
    PersonSettingVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    PersonSettingVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:PersonSettingVC animated:YES completion:nil];
}

- (void)goPerson{
    
    LogoutViewController *LogoutVC = [[LogoutViewController alloc] init];
    LogoutVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    LogoutVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:LogoutVC animated:YES completion:nil];
    
}

-(void)addEquipment{
    SelectDeviceViewController *VC = [[SelectDeviceViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
