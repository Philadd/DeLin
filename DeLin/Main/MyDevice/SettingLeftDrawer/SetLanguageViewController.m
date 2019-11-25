//
//  SetLanguageViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/25.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "SetLanguageViewController.h"

@interface SetLanguageViewController () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) UIPickerView *languagePicker;
@property (strong, nonatomic) UIButton *OKButton;

@property (nonatomic, strong) NSMutableArray  *languageChooseArray;

@end

@implementation SetLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerView = [self headerView];
    self.languagePicker = [self languagePicker];
    self.OKButton = [self OKButton];
    //[self inquireLanguage];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveLanguage:) name:@"recieveLanguage" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"recieveLanguage" object:nil];
    
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
        arealabel.text = LocalString(@"Language Setting");
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

-(UIPickerView *)languagePicker{
    if (!_languagePicker) {
        _languagePicker = [[UIPickerView alloc] init];
        _languagePicker.backgroundColor = [UIColor clearColor];
        self.languageChooseArray = [NSMutableArray arrayWithArray:@[LocalString(@"English"),LocalString(@"Danish"),LocalString(@"Dutch"),LocalString(@"Finnish"),LocalString(@"French"),LocalString(@"German"),LocalString(@"Italian"),LocalString(@"Norwegian"),LocalString(@"Russian"),LocalString(@"Portuguese"),LocalString(@"Spanish")]];
        self.languagePicker.dataSource = self;
        self.languagePicker.delegate = self;
        //在当前选择上显示一个透明窗口
        self.languagePicker.showsSelectionIndicator = YES;
        //初始化，自动转一圈，避免第一次是数组第一个值造成留白
        [self.languagePicker selectRow:[self.languageChooseArray count] inComponent:0 animated:YES];
        [self.view addSubview:_languagePicker];
        
        [_languagePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth,yAutoFit(300)));
            make.top.equalTo(self.headerView.mas_bottom).offset(yAutoFit(30.f));
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }
    return _languagePicker;
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
        [_OKButton setTitle:LocalString(@"Choose your language") forState:UIControlStateNormal];
        [_OKButton.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_OKButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_OKButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.f]];
        [_OKButton addTarget:self action:@selector(setLanguageChoose) forControlEvents:UIControlEventTouchUpInside];
        _OKButton.enabled = YES;
        [self.view addSubview:_OKButton];
        [_OKButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(50)));
            make.top.equalTo(self.languagePicker.mas_bottom).offset(yAutoFit(30));
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

- (void)recieveLanguage:(NSNotification *)notification{
    NSDictionary *dict = [notification userInfo];
    NSNumber *Language = dict[@"chooseLanguage"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.languagePicker selectRow:[Language intValue] inComponent:0 animated:YES];
    });}

#pragma mark - Action
- (void)setLanguageChoose
{
    //    NSInteger row = [self.languagePicker selectedRowInComponent:0];
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

// 返回多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView  numberOfRowsInComponent:(NSInteger)component
{
    return 16384;
}

// 返回的是component列的行显示的内容

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [NSString stringWithFormat:@"%@",self.languageChooseArray[row % _languageChooseArray.count]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSUInteger max = 16384;
    
    NSUInteger base0 = (max / 2) - (max / 2) % _languageChooseArray.count;
    [self.languagePicker selectRow:[_languagePicker selectedRowInComponent:component] % _languageChooseArray.count + base0 inComponent:component animated:NO];
    
}

@end
