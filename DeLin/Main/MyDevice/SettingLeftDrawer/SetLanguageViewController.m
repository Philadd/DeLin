//
//  SetLanguageViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/25.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "SetLanguageViewController.h"

@interface SetLanguageViewController () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView *languagePicker;
@property (strong, nonatomic) UIButton *oKButton;

@property (nonatomic, strong) NSMutableArray  *languageChooseArray;

@end

@implementation SetLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
    self.languagePicker = [self languagePicker];
    self.oKButton = [self oKButton];
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

#pragma mark - Lazy load
- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Set the language");
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
            make.size.mas_equalTo(CGSizeMake(ScreenWidth,yAutoFit(400)));
            make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHight + yAutoFit(30.f));
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
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:25]];
        pickerLabel.textColor = [UIColor whiteColor];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (UIButton *)oKButton{
    if (!_oKButton) {
        _oKButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oKButton setTitle:LocalString(@"Choose your language") forState:UIControlStateNormal];
        [_oKButton.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_oKButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_oKButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        [_oKButton addTarget:self action:@selector(setLanguageChoose) forControlEvents:UIControlEventTouchUpInside];
        _oKButton.enabled = YES;
        [self.view addSubview:_oKButton];
        [_oKButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(45)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _oKButton.layer.borderWidth = 0.5;
        _oKButton.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _oKButton.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _oKButton.layer.shadowOffset = CGSizeMake(0,2.5);
        _oKButton.layer.shadowRadius = 3;
        _oKButton.layer.shadowOpacity = 1;
        _oKButton.layer.cornerRadius = 2.5;
    }
    return _oKButton;
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
