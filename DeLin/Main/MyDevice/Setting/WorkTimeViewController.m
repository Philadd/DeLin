//
//  WorkTimeViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/21.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "WorkTimeViewController.h"
#import "WorktimeCell.h"

NSString *const CellIdentifier_WorkTime = @"CellID_WorkTime";

@interface WorkTimeViewController () <UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

///@brife 帧数据控制单例

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UITableView *workTimeTable;
@property (strong, nonatomic) UIPickerView *workDatePickview;
@property (strong, nonatomic) UIButton *OKButton;

///@brife 工作时间设置
@property (nonatomic, strong) NSMutableArray  *dayArray;
@property (nonatomic, strong) NSMutableArray  *workingHoursArray;
@property (nonatomic, strong) NSMutableArray  *workingMinuteArray;

@property (nonatomic, strong) NSMutableArray  *selectrowArray;
@property (nonatomic) int flag;//0:不发送,1:可以发送

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WorkTimeViewController

{
    NSIndexPath *selectIndexPath;
    UITextField *selectHoursTF;
    UITextField *selectMinutesTF;
}

static CGFloat cellHeight = 45.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerView = [self headerView];
    self.workTimeTable = [self workTimeTable];
    self.workDatePickview = [self workDatePickview];
    self.OKButton = [self OKButton];
    [self initDataArray];
    
    _flag = 0;//默认不发送数据
    //_timer = [self timer];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:NO];
}

- (NSTimer *)timer{
    if(!_timer){
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(inquireWorktimeSetting) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate date]];
    }
    return _timer;
}

- (void)initDataArray{
    
    self.dayArray = [NSMutableArray arrayWithArray:@[NSLocalizedString(@"Mon", nil),NSLocalizedString(@"Tue", nil),NSLocalizedString(@"Wed", nil),NSLocalizedString(@"Thu", nil),NSLocalizedString(@"Fri", nil),NSLocalizedString(@"Sat", nil),NSLocalizedString(@"Sun", nil)]];
    
    self.workingHoursArray = [[NSMutableArray alloc] init];
    self.workingMinuteArray = [[NSMutableArray alloc] init];
    
    //设置开始时间与工作时间的PickerView
    for (int i = 0; i < 24; i++) {
        [self.workingHoursArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    for (int i = 0; i < 60; i++) {
        [self.workingMinuteArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    self.selectrowArray = [NSMutableArray array];
    for (int i = 0; i < 30; i++) {
        [_selectrowArray addObject:[NSNumber numberWithInt:0]];
    }
    
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
        [areaImg setImage:[UIImage imageNamed:@"setWorkTime_img"]];
        [_headerView addSubview:areaImg];
        [areaImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(30), yAutoFit(30)));
            make.left.equalTo(self.headerView.mas_left).offset(yAutoFit(40));
            make.centerY.equalTo(self.headerView.mas_centerY);
        }];
        UILabel *arealabel = [[UILabel alloc] init];
        arealabel.text = LocalString(@"Working Time Setting");
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

- (UITableView *)workTimeTable{
    if (!_workTimeTable) {
        _workTimeTable = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight + yAutoFit(120), ScreenWidth, cellHeight * 7) style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.separatorColor = [UIColor clearColor];
            [tableView registerClass:[WorktimeCell class] forCellReuseIdentifier:CellIdentifier_WorkTime];
            [self.view addSubview:tableView];
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.scrollEnabled = NO;
            tableView;
        });
    }
    return _workTimeTable;
}

-(UIPickerView *)workDatePickview{
    if (!_workDatePickview) {
        _workDatePickview = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 216, ScreenWidth, 216)];
        self.workDatePickview.dataSource = self;
        self.workDatePickview.delegate = self;
        //在当前选择上显示一个透明窗口
        self.workDatePickview.showsSelectionIndicator = YES;
        //初始化，自动转一圈，避免第一次是数组第一个值造成留白
        [self.workDatePickview selectRow:[self.workingHoursArray count] inComponent:0 animated:YES];
        [self.workDatePickview selectRow:[self.workingMinuteArray count] inComponent:1 animated:YES];

    }
    return _workDatePickview;
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
        [_OKButton addTarget:self action:@selector(goMowerTime) forControlEvents:UIControlEventTouchUpInside];
        _OKButton.enabled = YES;
        [self.view addSubview:_OKButton];
        [_OKButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(320), yAutoFit(50)));
            make.top.equalTo(self.workTimeTable.mas_bottom).offset(yAutoFit(50));
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

#pragma tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 7;
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WorktimeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_WorkTime];
    if (cell == nil) {
        cell = [[WorktimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_WorkTime];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.userInteractionEnabled = YES;
    cell.weekLabel.text = _dayArray[indexPath.row];
    cell.worksHoursTF.delegate = self;
    cell.worksMinutesTF.delegate = self;
    //将键盘替换成pickView
    cell.worksHoursTF.inputView = _workDatePickview;
    cell.worksMinutesTF.inputView = _workDatePickview;
    if ([_selectrowArray[indexPath.row * 2] intValue] <= 24) {
        cell.worksHoursTF.text = [_workingHoursArray objectAtIndex:[_selectrowArray[indexPath.row * 2] intValue]];
    }
    if ([_selectrowArray[indexPath.row * 2 + 1] intValue] <= 60) {
        cell.worksMinutesTF.text = [NSString stringWithFormat:@"%@%@",LocalString(@":"),[_workingMinuteArray objectAtIndex:[_selectrowArray[indexPath.row * 2 + 1] intValue]]];
    }
    
    //cell.workTimeSwitch.on = isWorkTimeOn;
    cell.block = ^(BOOL isOn) {
        
    };
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UIPickerViewDataSource

// 返回多少列

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED {
    
    return 40;
}

// 返回多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView  numberOfRowsInComponent:(NSInteger)component
{
    return 16384;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSUInteger max = 16384;
    
    switch (component) {
        case 0:
        {
            NSUInteger base1 = (max / 2) - (max / 2) % _workingHoursArray.count;
            [self.workDatePickview selectRow:[_workDatePickview selectedRowInComponent:component] % _workingHoursArray.count + base1 inComponent:component animated:NO];
            selectHoursTF.text = _workingHoursArray[row % _workingHoursArray.count];
            [_selectrowArray replaceObjectAtIndex:selectIndexPath.row * 2 withObject:[NSNumber numberWithLong:row % _workingHoursArray.count]];
        }
            break;
        case 1:
        {
            NSUInteger base2 = (max / 2) - (max / 2) % _workingMinuteArray.count;
            [self.workDatePickview selectRow:[_workDatePickview selectedRowInComponent:component] % _workingMinuteArray.count + base2 inComponent:component animated:NO];
            selectMinutesTF.text = [NSString stringWithFormat:@"%@%@",LocalString(@":"),_workingMinuteArray[row % _workingMinuteArray.count]];
            [_selectrowArray replaceObjectAtIndex:selectIndexPath.row * 2 + 1 withObject:[NSNumber numberWithLong:row % _workingMinuteArray.count]];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - UIPickerViewDelegate

// 返回的是component列的行显示的内容

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return self.workingHoursArray[row % _workingHoursArray.count];
            break;
            
        default:
            return self.workingMinuteArray[row % _workingMinuteArray.count];
            break;
    }
    
}

#pragma mark - textFiled delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    selectIndexPath = [self.workTimeTable indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
    selectHoursTF = [self.workTimeTable cellForRowAtIndexPath:selectIndexPath].contentView.subviews[1];
    selectMinutesTF = [self.workTimeTable cellForRowAtIndexPath:selectIndexPath].contentView.subviews[2];
    selectHoursTF.textColor = [UIColor colorWithHexString:@"FF9700"];
    selectMinutesTF.textColor = [UIColor colorWithHexString:@"FF9700"];
    selectHoursTF.tintColor = [UIColor colorWithHexString:@"FF9700"];//传达色彩
    selectMinutesTF.tintColor = [UIColor colorWithHexString:@"FF9700"];
    [_workDatePickview selectRow:[_selectrowArray[selectIndexPath.row * 2] intValue] inComponent:0 animated:YES];
    [_workDatePickview selectRow:[_selectrowArray[selectIndexPath.row * 2 + 1] intValue] inComponent:1 animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    selectHoursTF.textColor = [UIColor blackColor];
    selectMinutesTF.textColor = [UIColor blackColor];
    [selectHoursTF resignFirstResponder];
    [selectMinutesTF resignFirstResponder];
}

#pragma mark - resign keyboard control

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"done" object:nil userInfo:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - inquire WorkingtimeSetting

//- (void)inquireWorktimeSetting{
//    [SVProgressHUD show];
//    //子线程延时1s
//    double delayInSeconds = 1.0;
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, mainQueue, ^{
//        NSLog(@"延时执行的1秒");
//    });
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
//    [self.bluetoothDataManage setDataType:0x14];
//    [self.bluetoothDataManage setDataContent: dataContent];
//    [self.bluetoothDataManage sendBluetoothFrame];
//}

//- (void)recieveWorkingTime:(NSNotification *)notification{
//    _flag = 1;
//    [SVProgressHUD dismiss];
//    //停掉重发机制
//    [_timer setFireDate:[NSDate distantFuture]];
//    if ([notification.name isEqualToString:@"recieveWorkingTime1"]) {
//        NSDictionary *dict = [notification userInfo];
//        NSNumber *monHour = 0;
//        NSNumber *tueHour = 0;
//        NSNumber *wedHour = 0;
//        NSNumber *thuHour = 0;
//        NSNumber *friHour = 0;
//        NSNumber *satHour = 0;
//        NSNumber *sunHour = 0;
//        NSNumber *monMinute = 0;
//        NSNumber *tueMinute = 0;
//        NSNumber *wedMinute = 0;
//        NSNumber *thuMinute = 0;
//        NSNumber *friMinute = 0;
//        NSNumber *satMinute = 0;
//        NSNumber *sunMinute = 0;
//        if (dict[@"monHour"]) {
//            monHour = dict[@"monHour"];
//        }
//        if (dict[@"tueHour"]) {
//            tueHour = dict[@"tueHour"];
//        }
//        if (dict[@"wedHour"]) {
//            wedHour = dict[@"wedHour"];
//        }
//        if (dict[@"thuHour"]) {
//            thuHour = dict[@"thuHour"];
//        }
//        if (dict[@"friHour"]) {
//            friHour = dict[@"friHour"];
//        }
//        if (dict[@"satHour"]) {
//            satHour = dict[@"satHour"];
//        }
//        if (dict[@"sunHour"]) {
//            sunHour = dict[@"sunHour"];
//        }
//        if (dict[@"monMinute"]) {
//            monMinute = dict[@"monMinute"];
//        }
//        if (dict[@"tueMinute"]) {
//            tueMinute = dict[@"tueMinute"];
//        }
//        if (dict[@"wedMinute"]) {
//            wedMinute = dict[@"wedMinute"];
//        }
//        if (dict[@"thuMinute"]) {
//            thuMinute = dict[@"thuMinute"];
//        }
//        if (dict[@"friMinute"]) {
//            friMinute = dict[@"friMinute"];
//        }
//        if (dict[@"satMinute"]) {
//            satMinute = dict[@"satMinute"];
//        }
//        if (dict[@"sunMinute"]) {
//            sunMinute = dict[@"sunMinute"];
//        }
//        [_selectrowArray replaceObjectAtIndex:0 withObject:monHour];
//        [_selectrowArray replaceObjectAtIndex:4 withObject:tueHour];
//        [_selectrowArray replaceObjectAtIndex:8 withObject:wedHour];
//        [_selectrowArray replaceObjectAtIndex:12 withObject:thuHour];
//        [_selectrowArray replaceObjectAtIndex:16 withObject:friHour];
//        [_selectrowArray replaceObjectAtIndex:20 withObject:satHour];
//        [_selectrowArray replaceObjectAtIndex:24 withObject:sunHour];
//
//        [_selectrowArray replaceObjectAtIndex:1 withObject:monMinute];
//        [_selectrowArray replaceObjectAtIndex:5 withObject:tueMinute];
//        [_selectrowArray replaceObjectAtIndex:9 withObject:wedMinute];
//        [_selectrowArray replaceObjectAtIndex:13 withObject:thuMinute];
//        [_selectrowArray replaceObjectAtIndex:17 withObject:friMinute];
//        [_selectrowArray replaceObjectAtIndex:21 withObject:satMinute];
//        [_selectrowArray replaceObjectAtIndex:25 withObject:sunMinute];
//
//    }else{
//        NSDictionary *dict = [notification userInfo];
//        NSNumber *monWorkHour = 0;
//        NSNumber *tueWorkHour = 0;
//        NSNumber *wedWorkHour = 0;
//        NSNumber *thuWorkHour = 0;
//        NSNumber *friWorkHour = 0;
//        NSNumber *satWorkHour = 0;
//        NSNumber *sunWorkHour = 0;
//        NSNumber *monWorkMinute = 0;
//        NSNumber *tueWorkMinute = 0;
//        NSNumber *wedWorkMinute = 0;
//        NSNumber *thuWorkMinute = 0;
//        NSNumber *friWorkMinute = 0;
//        NSNumber *satWorkMinute = 0;
//        NSNumber *sunWorkMinute = 0;
//
//
//        if (dict[@"monWorkHour"]) {
//            monWorkHour = dict[@"monWorkHour"];
//        }
//        if (dict[@"tueWorkHour"]) {
//            tueWorkHour = dict[@"tueWorkHour"];
//        }
//        if (dict[@"wedWorkHour"]) {
//            wedWorkHour = dict[@"wedWorkHour"];
//        }
//        if (dict[@"thuWorkHour"]) {
//            thuWorkHour = dict[@"thuWorkHour"];
//        }
//        if (dict[@"friWorkHour"]) {
//            friWorkHour = dict[@"friWorkHour"];
//        }
//        if (dict[@"satWorkHour"]) {
//            satWorkHour = dict[@"satWorkHour"];
//        }
//        if (dict[@"sunWorkHour"]) {
//            sunWorkHour = dict[@"sunWorkHour"];
//        }
//
//        if (dict[@"monWorkMinute"]) {
//            monWorkMinute = dict[@"monWorkMinute"];
//        }
//        if (dict[@"tueWorkMinute"]) {
//            tueWorkMinute = dict[@"tueWorkMinute"];
//        }
//        if (dict[@"wedWorkMinute"]) {
//            wedWorkMinute = dict[@"wedWorkMinute"];
//        }
//        if (dict[@"thuWorkMinute"]) {
//            thuWorkMinute = dict[@"thuWorkMinute"];
//        }
//        if (dict[@"friWorkMinute"]) {
//            friWorkMinute = dict[@"friWorkMinute"];
//        }
//        if (dict[@"satWorkMinute"]) {
//            satWorkMinute = dict[@"satWorkMinute"];
//        }
//        if (dict[@"sunWorkMinute"]) {
//            sunWorkMinute = dict[@"sunWorkMinute"];
//        }
//        [_selectrowArray replaceObjectAtIndex:2 withObject:monWorkHour];
//        [_selectrowArray replaceObjectAtIndex:6 withObject:tueWorkHour];
//        [_selectrowArray replaceObjectAtIndex:10 withObject:wedWorkHour];
//        [_selectrowArray replaceObjectAtIndex:14 withObject:thuWorkHour];
//        [_selectrowArray replaceObjectAtIndex:18 withObject:friWorkHour];
//        [_selectrowArray replaceObjectAtIndex:22 withObject:satWorkHour];
//        [_selectrowArray replaceObjectAtIndex:26 withObject:sunWorkHour];
//
//        [_selectrowArray replaceObjectAtIndex:3 withObject:monWorkMinute];
//        [_selectrowArray replaceObjectAtIndex:7 withObject:tueWorkMinute];
//        [_selectrowArray replaceObjectAtIndex:11 withObject:wedWorkMinute];
//        [_selectrowArray replaceObjectAtIndex:15 withObject:thuWorkMinute];
//        [_selectrowArray replaceObjectAtIndex:19 withObject:friWorkMinute];
//        [_selectrowArray replaceObjectAtIndex:23 withObject:satWorkMinute];
//        [_selectrowArray replaceObjectAtIndex:27 withObject:sunWorkMinute];
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.myTableView reloadData];
//    });
//
//}

#pragma mark - set mower work time

//- (void)sentMowerTime{
//    /*
//     第一帧数据位：前七位为周一至周日的时间的小时位;
//     后七位为周一至周日的时间的分钟位;
//     第二帧数据位：
//     数据内容共7个字节：
//     表示周一至周日的进行工作时间;
//     注：此帧将时间戳取消
//     */
//    NSMutableArray *dataStartTime1 = [[NSMutableArray alloc] init];
//    NSMutableArray *dataStartTime2 = [[NSMutableArray alloc] init];
//    NSMutableArray *dataWorkTime1 = [[NSMutableArray alloc] init];
//    NSMutableArray *dataWorkTime2 = [[NSMutableArray alloc] init];
//    if (dataStartTime1.count != 8) {
//        for (int i = 0; i < 28; i= i+4) {
//            [dataStartTime1 addObject:_selectrowArray[i]];
//        }
//    }
//    if (dataStartTime2.count != 8) {
//        for (int i = 1; i < 28; i= i+4) {
//            [dataStartTime2 addObject:_selectrowArray[i]];
//        }
//    }
//    NSArray *dataStartTime = [dataStartTime1 arrayByAddingObjectsFromArray:dataStartTime2];
//    if (dataWorkTime1.count != 8) {
//        for (int i = 2; i < 30; i= i+4) {
//            [dataWorkTime1 addObject:_selectrowArray[i]];
//        }
//    }
//    if (dataWorkTime2.count != 8) {
//        for (int i = 3; i < 30; i= i+4) {
//            [dataWorkTime2 addObject:_selectrowArray[i]];
//        }
//    }
//    NSArray *dataWorkTime = [dataWorkTime1 arrayByAddingObjectsFromArray:dataWorkTime2];
//    
//    if ([_selectrowArray[0] intValue] *60 + [_selectrowArray[2] intValue] * 60 + [_selectrowArray[1] intValue] + [_selectrowArray[3] intValue] > 1440){
//        [NSObject showHudTipStr:LocalString(@"Monday's time set wrong")];
//    }else if ([_selectrowArray[4] intValue] *60 + [_selectrowArray[6] intValue] * 60 + [_selectrowArray[5] intValue] + [_selectrowArray[7] intValue] > 1440){
//        [NSObject showHudTipStr:LocalString(@"Tuesday's time set wrong")];
//    }else if ([_selectrowArray[8] intValue] *60 + [_selectrowArray[10] intValue] * 60 + [_selectrowArray[9] intValue] + [_selectrowArray[11] intValue] > 1440){
//        [NSObject showHudTipStr:LocalString(@"Wednesday's time set wrong")];
//    }else if ([_selectrowArray[12] intValue] *60 + [_selectrowArray[14] intValue] * 60 + [_selectrowArray[13] intValue] + [_selectrowArray[15] intValue] > 1440){
//        [NSObject showHudTipStr:LocalString(@"Thursday's time set wrong")];
//    }else if ([_selectrowArray[16] intValue] *60 + [_selectrowArray[18] intValue] * 60 + [_selectrowArray[17] intValue] + [_selectrowArray[19] intValue] > 1440){
//        [NSObject showHudTipStr:LocalString(@"Friday's time set wrong")];
//    }else if ([_selectrowArray[20] intValue] *60 + [_selectrowArray[22] intValue] * 60 + [_selectrowArray[21] intValue] + [_selectrowArray[23] intValue] > 1440){
//        [NSObject showHudTipStr:LocalString(@"Saturday's time set wrong")];
//    }else if ([_selectrowArray[24] intValue] *60 + [_selectrowArray[26] intValue] * 60 + [_selectrowArray[25] intValue] + [_selectrowArray[27] intValue] > 1440){
//        [NSObject showHudTipStr:LocalString(@"Sunday's time set wrong")];
//    }else{
//        [NSObject showHudTipStr:LocalString(@"Data sent successfully")];
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [self.bluetoothDataManage setDataType:0x04];
//            [self.bluetoothDataManage setDataContent: dataStartTime];
//            [self.bluetoothDataManage sendWorktimeBluetoothFrame];
//            usleep(1000 * 1000);
//            [self.bluetoothDataManage setDataType:0x05];
//            [self.bluetoothDataManage setDataContent: dataWorkTime];
//            [self.bluetoothDataManage sendWorktimeBluetoothFrame];
//        });
//    }
//}
//
//- (void)refresh{
//    sleep(1.0f);
//    [self inquireWorktimeSetting];
//}
//
//- (void)goMowerTime
//{
//    if (_flag == 1) {
//        [self sentMowerTime];
//    }else{
//        //[NSObject showHudTipStr:LocalString(@"Data transmission failed")];
//        //显示弹出框列表选择
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:LocalString(@"Working hours are all 0") preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"NO") style:UIAlertActionStyleCancel handler:nil];
//        UIAlertAction* sureAction = [UIAlertAction actionWithTitle:LocalString(@"Yes") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
//            //响应事件
//            self.flag = 1;
//            [self sentMowerTime];
//        }];
//        
//        [alert addAction:cancelAction];
//        [alert addAction:sureAction];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//    
//}


@end
