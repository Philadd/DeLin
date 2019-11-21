//
//  WorkAreaViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/21.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "WorkAreaViewController.h"

@interface WorkAreaViewController () <UIPickerViewDataSource,UIPickerViewDelegate>

///@brife 帧数据控制单例
@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) UIPickerView *workAeraPicker;
@property (strong, nonatomic) UIButton *OKButton;

@property (nonatomic, strong) NSMutableArray  *workAeraArray;

@end

@implementation WorkAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.headerView = [self headerView];
    self.workAeraPicker = [self workAeraPicker];
    self.OKButton = [self OKButton];
    //[self inquireLanguage];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveWorkAera:) name:@"recieveWorkAera" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"recieveWorkAera" object:nil];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(60)));
            make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHight + yAutoFit(50));
            make.centerX.equalTo(self.view.mas_centerX);
        }];
        
        UIImageView *areaImg = [[UIImageView alloc] init];
        [areaImg setImage:[UIImage imageNamed:@"area_img"]];
        [_headerView addSubview:areaImg];
        [areaImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(30), yAutoFit(30)));
            make.left.equalTo(self.headerView.mas_left).offset(yAutoFit(40));
            make.centerY.equalTo(self.headerView.mas_centerY);
        }];
        UILabel *arealabel = [[UILabel alloc] init];
        arealabel.text = LocalString(@"Mowing Area Setting");
        arealabel.font = [UIFont systemFontOfSize:16.f];
        arealabel.textColor = [UIColor colorWithRed:33/255.0 green:36/255.0 blue:55/255.0 alpha:1];
        arealabel.textAlignment = NSTextAlignmentCenter;
        arealabel.adjustsFontSizeToFitWidth = YES;
        [_headerView addSubview:arealabel];
        [arealabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(180), yAutoFit(60)));
            make.centerY.equalTo(self.headerView.mas_centerY);
            make.left.equalTo(areaImg.mas_right).offset(20);
        }];
        
    }
    return _headerView;
}

-(UIPickerView *)workAeraPicker{
    if (!_workAeraPicker) {
        _workAeraPicker = [[UIPickerView alloc] init];
        _workAeraPicker.backgroundColor = [UIColor clearColor];
        self.workAeraArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 550; i = i+50) {
            [self.workAeraArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        self.workAeraPicker.dataSource = self;
        self.workAeraPicker.delegate = self;
        //在当前选择上显示一个透明窗口
        self.workAeraPicker.showsSelectionIndicator = YES;
        //初始化，自动转一圈，避免第一次是数组第一个值造成留白
        [self.workAeraPicker selectRow:[self.workAeraArray count] inComponent:0 animated:YES];
        [self.view addSubview:_workAeraPicker];
        
        [_workAeraPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth,yAutoFit(300)));
            make.top.equalTo(self.headerView.mas_bottom).offset(yAutoFit(30.f));
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }
    return _workAeraPicker;
}

//自定义pick view的字体和颜色
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
        pickerLabel.textColor = [UIColor blackColor];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (UIButton *)OKButton{
    if (!_OKButton) {
        _OKButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_OKButton setTitle:LocalString(@"SET DONE") forState:UIControlStateNormal];
        [_OKButton.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_OKButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_OKButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.f]];
        [_OKButton addTarget:self action:@selector(setWorkAera) forControlEvents:UIControlEventTouchUpInside];
        _OKButton.enabled = YES;
        [self.view addSubview:_OKButton];
        [_OKButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(50)));
            make.top.equalTo(self.workAeraPicker.mas_bottom).offset(yAutoFit(30));
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _OKButton.layer.borderWidth = 0.5;
        _OKButton.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _OKButton.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _OKButton.layer.shadowOffset = CGSizeMake(0,2.5);
        _OKButton.layer.shadowRadius = 3;
        _OKButton.layer.shadowOpacity = 1;
        _OKButton.layer.cornerRadius = 2.5;
    }
    return _OKButton;
}


#pragma mark - inquire Mower Language

//- (void)inquireLanguage{
//
//    NSMutableArray *dataContent = [[NSMutableArray alloc] init];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
//
//    [self.bluetoothDataManage setDataType:0x13];
//    [self.bluetoothDataManage setDataContent: dataContent];
//    [self.bluetoothDataManage sendBluetoothFrame];
//}

- (void)recieveWorkAera:(NSNotification *)notification{
    NSDictionary *dict = [notification userInfo];
    NSNumber *Language = dict[@"workAera"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.workAeraPicker selectRow:[Language intValue] inComponent:0 animated:YES];
    });}

#pragma mark - Action
- (void)setWorkAera
{
//    NSInteger row = [self.workAeraPicker selectedRowInComponent:0];
//    if (row == 1) {
//        row = 2;
//    }
//
//    NSMutableArray *dataContent = [[NSMutableArray alloc] init];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:row]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
//    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
//
//    [self.bluetoothDataManage setDataType:0x03];
//    [self.bluetoothDataManage setDataContent: dataContent];
//    [self.bluetoothDataManage sendBluetoothFrame];
    

}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED {
    
    return 40;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.workAeraArray.count;
    
}

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.workAeraArray[row];
    
}


@end
