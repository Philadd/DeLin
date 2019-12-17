//
//  WelcomeViewController.m
//  MOWOX
//
//  Created by 安建伟 on 2018/12/19.
//  Copyright © 2018 yusz. All rights reserved.
//

#import "DeviceListViewController.h"
#import "LoginViewController.h"
#import "DeviceNetworkViewController.h"
#import "ConnectNetworkViewController.h"

#import "InputPINViewController.h"

static float HEIGHT_CELL = 80.f;

@interface DeviceListViewController () <UITableViewDelegate, UITableViewDataSource, GizWifiSDKDelegate>

///@brife ui和功能各模块
@property (strong, nonatomic)  UILabel *deviceLabel;
@property (strong, nonatomic)  UIButton *addButton;

@property (nonatomic, strong) UITableView *deviceTable;
@property (nonatomic, strong) NSArray *deviceArray;

@property (strong, nonatomic)  UILabel *resultLabel;
//@property (strong, nonatomic)  LMPopInputPasswordView *popView;

//@property (strong, nonatomic)  BluetoothDataManage *bluetoothDataManage;

@end

@implementation DeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavItem];
    
    self.deviceLabel = [self deviceLabel];
    self.addButton = [self addButton];
    self.deviceTable = [self deviceTable];
    //[self setMowerTime];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.bluetoothDataManage = [BluetoothDataManage shareInstance];
    GizManager *manager = [GizManager shareInstance];
    [GizWifiSDK sharedInstance].delegate = self;
    [[GizWifiSDK sharedInstance] getBoundDevices:manager.uid token:manager.token];
    //退出设备 需要取消所有 设备订阅
    [manager.device setSubscribe:GizAppproductSecret subscribed:NO]; //解除订阅
  
}

#pragma mark - Lazy load
- (void)setNavItem{
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    [rightButton.widthAnchor constraintEqualToConstant:30].active = YES;
    [rightButton.heightAnchor constraintEqualToConstant:30].active = YES;
    [rightButton setImage:[UIImage imageNamed:@"ic_nav_more_white"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;

}

- (UILabel *)deviceLabel{
    if (!_deviceLabel) {
        _deviceLabel = [[UILabel alloc] init];
        _deviceLabel.font = [UIFont systemFontOfSize:15.f];
        _deviceLabel.backgroundColor = [UIColor clearColor];
        _deviceLabel.textColor = [UIColor blackColor];
        _deviceLabel.textAlignment = NSTextAlignmentCenter;
        _deviceLabel.text = LocalString(@"Please select a device or add a new one");
        //自动折行设置
        [_deviceLabel setLineBreakMode:NSLineBreakByWordWrapping];
        _deviceLabel.numberOfLines = 0;
        _deviceLabel.textAlignment = NSTextAlignmentLeft;
        _deviceLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:_deviceLabel];
        [_deviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(280), yAutoFit(50)));
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHight + yAutoFit(10));
        }];
    }
    return _deviceLabel;
}

- (UITableView *)deviceTable{
    if (!_deviceTable) {
        _deviceTable = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight + yAutoFit(50), ScreenWidth, ScreenHeight - getRectNavAndStatusHight - yAutoFit(40) - yAutoFit(60) - yAutoFit(60)) style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.separatorColor = [UIColor clearColor];
            [tableView registerClass:[DeviceListCell class] forCellReuseIdentifier:CellIdentifier_DeviceList];
            [self.view addSubview:tableView];
            
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(320), ScreenHeight - getRectNavAndStatusHight - yAutoFit(40) - yAutoFit(60) - yAutoFit(60)));
                make.centerX.mas_equalTo(self.view.mas_centerX);
                make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHight + yAutoFit(50));
            }];
            
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            
            tableView.tableFooterView = [[UIView alloc] init];
            
            tableView;
        });
    }
    return _deviceTable;
}

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"add_Btn"] forState:UIControlStateNormal];
        [_addButton.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
        [_addButton addTarget:self action:@selector(goNetwork) forControlEvents:UIControlEventTouchUpInside];
        _addButton.enabled = YES;
        [self.view addSubview:_addButton];
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(50)));
            make.bottom.equalTo(self.view.mas_bottom).offset(yAutoFit(-50));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _addButton.layer.borderWidth = 0.5;
        _addButton.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _addButton.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _addButton.layer.shadowOffset = CGSizeMake(0,2.5);
        _addButton.layer.shadowRadius = 3;
        _addButton.layer.shadowOpacity = 1;
        _addButton.layer.cornerRadius = 2.5;
    }
    return _addButton;
}

#pragma mark - uitableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_CELL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_DeviceList];
    if (cell == nil) {
        cell = [[DeviceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_DeviceList];
    }
    GizWifiDevice *device = _deviceArray[indexPath.row];
    cell.deviceImage.image = [UIImage imageNamed:@"robot_icon_imag"];
    cell.deviceListLabel.text = device.productName;

    return cell;
}
//左滑删除 设备绑定
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:LocalString(@"delete") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了删除");
         GizWifiDevice *device = self.deviceArray[indexPath.row];
            //提示框
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:LocalString(@"Are you sure to delete ?")preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:LocalString(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                  NSLog(@"action = %@",action);
                  GizManager *manager = [GizManager shareInstance];
                  [[GizWifiSDK sharedInstance] unbindDevice:manager.uid token:manager.token did:device.did];
    
                }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    NSLog(@"action = %@",action);
                }];
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
           }];
//    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        NSLog(@"点击了编辑");
//    }];
//    editAction.backgroundColor = [UIColor grayColor];
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GizWifiDevice *device = _deviceArray[indexPath.row];
    [[GizManager shareInstance] setGizDevice:device];
    
    InputPINViewController *inputVC = [[InputPINViewController alloc] init];
    [self.navigationController pushViewController:inputVC animated:YES];
    
}

#pragma mark - Giz delegate

// 设备解绑实现回调
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didUnbindDevice:(NSError *)result did:(NSString *)did {
    if(result.code == GIZ_SDK_SUCCESS) {
        // 解绑成功
        NSLog(@"解绑成功");
    } else {
        // 解绑失败
         NSLog(@"解绑失败");
    }
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didDiscovered:(NSError *)result deviceList:(NSArray<GizWifiDevice *> *)deviceList{
    // 提示错误原因
    if(result.code != GIZ_SDK_SUCCESS) {
        NSLog(@"result--- %@", result.localizedDescription);
    }
   
    [self refreshTableView:deviceList];
}

#pragma mark - Actions
- (void)refreshTableView:(NSArray *)listArray{
    NSLog(@"设备数量%lu",(unsigned long)listArray.count);
    NSMutableArray *deviceArray = [[NSMutableArray alloc] init];
    for (GizWifiDevice *device in listArray) {
        if (device.isBind) {
            NSLog(@"绑定设备%@",device.productName);
        }
        if (device.netStatus == GizDeviceOnline && device.isBind) {
            [deviceArray addObject:device];
        }
    }
    self.deviceArray = deviceArray;
    [self.deviceTable reloadData];
}

- (void)goNetwork {
    DeviceNetworkViewController *VC = [[DeviceNetworkViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}


//校准机器时间
//- (void)setMowerTime{
//    NSDate *date = [NSDate date];
//    NSCalendar *currentCalendar = [NSCalendar currentCalendar];    //IOS 8 之后
//    NSUInteger integer = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
//    NSDateComponents *dataCom = [currentCalendar components:integer fromDate:date];
//
//    NSMutableArray *dataContent = [[NSMutableArray alloc] init];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:[dataCom year] / 100]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:[dataCom year] % 100]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:[dataCom month]]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:[dataCom day]]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:[dataCom hour]]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:[dataCom minute]]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
//
//    [self.bluetoothDataManage setDataType:0x02];
//    [self.bluetoothDataManage setDataContent: dataContent];
//    [self.bluetoothDataManage sendBluetoothFrame];
//}

- (void)logout{
    NSLog(@"注销登录");
//    //提示框
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"Alerts")message:LocalString(@"Are you sure to log out?")preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:LocalString(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//          [self dismissViewControllerAnimated:YES completion:nil];
//          NSLog(@"action = %@",action);
//        }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            NSLog(@"action = %@",action);
//        }];
//    [alert addAction:okAction];
//    [alert addAction:cancelAction];
//    [self presentViewController:alert animated:YES completion:nil];
//
        //显示弹出框列表选择
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:LocalString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            //响应事件
            [self.navigationController popToRootViewControllerAnimated:YES];
            NSLog(@"action = %@", action);
        }];
        UIAlertAction* sureAction = [UIAlertAction actionWithTitle:LocalString(@"log out") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            //响应事件
            [self dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"action = %@", action);
        }];
    
        [alert addAction:cancelAction];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];

}

@end
