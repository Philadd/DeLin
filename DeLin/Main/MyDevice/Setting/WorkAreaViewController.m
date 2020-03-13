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

@property (strong, nonatomic) UIPickerView *workAeraPicker;
@property (strong, nonatomic) UIButton *oKButton;

@property (nonatomic, strong) NSMutableArray  *workAeraArray;

@end

@implementation WorkAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
    self.workAeraPicker = [self workAeraPicker];
    self.oKButton = [self oKButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self inquireworkAera];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveWorkAera:) name:@"recieveWorkAera" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"recieveWorkAera" object:nil];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy load
- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Set the area");
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
            make.size.mas_equalTo(CGSizeMake(ScreenWidth,yAutoFit(400)));
            make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHight + yAutoFit(30.f));
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
        [_oKButton setTitle:LocalString(@"SET DONE") forState:UIControlStateNormal];
        [_oKButton.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_oKButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_oKButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        [_oKButton addTarget:self action:@selector(setWorkAera) forControlEvents:UIControlEventTouchUpInside];
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


#pragma mark - inquire Mower workAera

- (void)inquireworkAera{

    UInt8 controlCode = 0x01;
    NSArray *data = @[@0x00,@0x01,@0x05,@0x00];
    [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:data failuer:nil];

}

- (void)recieveWorkAera:(NSNotification *)notification{
    NSDictionary *dict = [notification userInfo];
    NSNumber *workAera = dict[@"workAera"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.workAeraPicker selectRow:[workAera intValue] inComponent:0 animated:YES];
    });}

#pragma mark - Action
- (void)setWorkAera
{
    NSInteger row = [self.workAeraPicker selectedRowInComponent:0];
    
    NSNumber *aera = [NSNumber numberWithUnsignedInteger:[self.workAeraArray[row % _workAeraArray.count] integerValue]];
    
    UInt8 controlCode = 0x01;
    NSArray *data = @[@0x00,@0x01,@0x05,@0x01,aera];
    [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:data failuer:nil];

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
    
    return [NSString stringWithFormat:@"%@%@",self.workAeraArray[row % _workAeraArray.count],LocalString(@"m²")];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSUInteger max = 16384;
    
    NSUInteger base0 = (max / 2) - (max / 2) % _workAeraArray.count;
    [self.workAeraPicker selectRow:[_workAeraPicker selectedRowInComponent:component] % _workAeraArray.count + base0 inComponent:component animated:NO];

}

@end
