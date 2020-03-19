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

@property (strong, nonatomic) UITableView *workTimeTable;
@property (strong, nonatomic) UIPickerView *workDatePickview;
@property (strong, nonatomic) UIButton *oKButton;

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
    //初始化数组 要提前
    [self initDataArray];
    [self setNavItem];
    self.workTimeTable = [self workTimeTable];
    self.workDatePickview = [self workDatePickview];
    self.oKButton = [self oKButton];
    
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

#pragma mark - Lazy load
- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Set the time");
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
    for (int i = 0; i < 21; i++) {
        [_selectrowArray addObject:[NSNumber numberWithInt:0]];
    }
    
}

- (UITableView *)workTimeTable{
    if (!_workTimeTable) {
        _workTimeTable = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight + yAutoFit(80), ScreenWidth, cellHeight * 7) style:UITableViewStylePlain];
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

- (UIButton *)oKButton{
    if (!_oKButton) {
        _oKButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oKButton setTitle:LocalString(@"SET DONE") forState:UIControlStateNormal];
        [_oKButton.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_oKButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_oKButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.f]];
        [_oKButton addTarget:self action:@selector(setMowerTime) forControlEvents:UIControlEventTouchUpInside];
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
    if ([_selectrowArray[indexPath.row] intValue] <= 24) {
        cell.worksHoursTF.text = [_workingHoursArray objectAtIndex:[_selectrowArray[indexPath.row] intValue]];
    }
    if ([_selectrowArray[indexPath.row + 7] intValue] <= 60) {
        cell.worksMinutesTF.text = [NSString stringWithFormat:@"%@%@",LocalString(@":"),[_workingMinuteArray objectAtIndex:[_selectrowArray[indexPath.row + 7] intValue]]];
    }
    cell.block = ^(BOOL isOn) {
        
        if (isOn) {
            [self.selectrowArray replaceObjectAtIndex:indexPath.row + 14 withObject:[NSNumber numberWithBool:isOn]];
        }else{
            [self.selectrowArray replaceObjectAtIndex:indexPath.row + 14 withObject:[NSNumber numberWithBool:isOn]];
        }
        
        [self.workTimeTable reloadData];
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
            [_selectrowArray replaceObjectAtIndex:selectIndexPath.row withObject:[NSNumber numberWithLong:row % _workingHoursArray.count]];
        }
            break;
        case 1:
        {
            NSUInteger base2 = (max / 2) - (max / 2) % _workingMinuteArray.count;
            [self.workDatePickview selectRow:[_workDatePickview selectedRowInComponent:component] % _workingMinuteArray.count + base2 inComponent:component animated:NO];
            selectMinutesTF.text = [NSString stringWithFormat:@"%@%@",LocalString(@":"),_workingMinuteArray[row % _workingMinuteArray.count]];
            [_selectrowArray replaceObjectAtIndex:selectIndexPath.row + 7 withObject:[NSNumber numberWithLong:row % _workingMinuteArray.count]];
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
    [_workDatePickview selectRow:[_selectrowArray[selectIndexPath.row] intValue] inComponent:0 animated:YES];
    [_workDatePickview selectRow:[_selectrowArray[selectIndexPath.row + 7] intValue] inComponent:1 animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    selectHoursTF.textColor = [UIColor whiteColor];
    selectMinutesTF.textColor = [UIColor whiteColor];
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

- (void)inquireWorktimeSetting{
    [SVProgressHUD show];
    //子线程延时1s
    double delayInSeconds = 1.0;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, mainQueue, ^{
        NSLog(@"延时执行的1秒");
    });
    
    UInt8 controlCode = 0x01;
    NSArray *data = @[@0x00,@0x01,@0x04,@0x00];
    [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:data failuer:nil];
    
}

//- (void)recieveWorkingTime:(NSNotification *)notification{
//    _flag = 1;
//    [SVProgressHUD dismiss];
//    //停掉重发机制
//    [_timer setFireDate:[NSDate distantFuture]];
//    if ([notification.name isEqualToString:@"recieveWorkingTime"]) {
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
//        [self.workTimeTable reloadData];
//    });
//
//}

#pragma mark - set mower work time

- (void)setMowerTime{
    /*
     前七位：周一至周日的时间的 小时位;
     中七位：周一至周日的时间的 分钟位;
     后七位：周一至周日的进行工作状态是否开启;
     */
    [NSObject showHudTipStr:LocalString(@"Data sent successfully")];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UInt8 controlCode = 0x01;
        NSArray *data = @[@0x00,@0x01,@0x04,@0x01];
        NSArray *workData = [data arrayByAddingObjectsFromArray:self.selectrowArray];
        [[NetWorkManager shareNetWorkManager] sendData68With:controlCode data:workData failuer:nil];
        
    });
}

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
