//
//  RegionViewController.m
//  DeLin
//
//  Created by 安建伟 on 2019/11/29.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "RegionViewController.h"
#import "RegionCell.h"

static float HEIGHT_CELL = 50.f;
NSString *const CellIdentifier_RegionCell = @"RegionCell";

@interface RegionViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *regionTable;
@property (nonatomic, strong) UIButton *continueBtn;
@property (nonatomic, strong) NSMutableArray  *regionChooseArray;
@property (nonatomic, assign)BOOL ifSelected;//是否选中
@property (nonatomic, strong)NSIndexPath * lastSelected;//上一次选中的索引


@end

@implementation RegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0].CGColor;
    
    _regionTable = [self regionTable];
    _continueBtn = [self continueBtn];
    [self setNavItem];
    self.ifSelected = NO;//是否被选中 默认为NO
    
    self.regionChooseArray = [NSMutableArray arrayWithArray:@[LocalString(@"United Kingdom"),LocalString(@"Denmark"),LocalString(@"Netherlands"),LocalString(@"Finland"),LocalString(@"France"),LocalString(@"Germany"),LocalString(@"Italy"),LocalString(@"Norway"),LocalString(@"Russia"),LocalString(@"Portugal"),LocalString(@"Spain")]];
}

#pragma mark - setters and getters

- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Region");
}

- (UITableView *)regionTable{
    if (!_regionTable) {
        _regionTable = ({
            TouchTableView *tableView = [[TouchTableView alloc] initWithFrame:CGRectMake(0.f, getRectNavAndStatusHight + yAutoFit(20), ScreenWidth, ScreenHeight - yAutoFit(45)) style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.separatorColor = [UIColor grayColor];
            tableView.scrollEnabled = YES;
            [tableView registerClass:[RegionCell class] forCellReuseIdentifier:CellIdentifier_RegionCell];
            [self.view addSubview:tableView];
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.tableFooterView = [[UIView alloc] init];
            
            tableView;
        });
    }
    return _regionTable;
}

- (UIButton *)continueBtn{
    if (!_continueBtn) {
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_continueBtn setTitle:LocalString(@"Submit") forState:UIControlStateNormal];
        [_continueBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_continueBtn setBackgroundColor:[UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1.f]];
        [_continueBtn addTarget:self action:@selector(goToSubmit) forControlEvents:UIControlEventTouchUpInside];
        _continueBtn.enabled = NO;
        [self.view addSubview:_continueBtn];
        [_continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, yAutoFit(45)));
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        _continueBtn.layer.borderWidth = 0.5;
        _continueBtn.layer.borderColor = [UIColor colorWithRed:226/255.0 green:230/255.0 blue:234/255.0 alpha:1.0].CGColor;
        _continueBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _continueBtn.layer.shadowOffset = CGSizeMake(0,2.5);
        _continueBtn.layer.shadowRadius = 3;
        _continueBtn.layer.shadowOpacity = 1;
        _continueBtn.layer.cornerRadius = 2.5;
    }
    return _continueBtn;
}

#pragma mark - UITableView delegate&datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.regionChooseArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RegionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_RegionCell];
    if (cell == nil) {
        cell = [[RegionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_RegionCell];
    }
    cell.regionLabel.text = self.regionChooseArray[indexPath.row];
    //如果是之前选择的地区被标记
    if ([self.addressStr isEqualToString:[NSString stringWithFormat:@"%@", self.regionChooseArray[indexPath.row]]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if (self.ifSelected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        [_continueBtn setBackgroundColor:[UIColor colorWithRed:220/255.0 green:168/255.0 blue:11/255.0 alpha:1.f]];
        _continueBtn.enabled = YES;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        [_continueBtn setBackgroundColor:[UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1.f]];
        _continueBtn.enabled = NO;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath * temp = self.lastSelected;//暂存上一次选中的行
    if (temp && temp != indexPath)//如果上一次的选中的行存在,并且不是当前选中的这一行,则让上一行不选中
    {
        self.ifSelected = NO;//修改之前选中的cell的数据为不选中
        [tableView reloadRowsAtIndexPaths:@[temp] withRowAnimation:UITableViewRowAnimationAutomatic];//刷新该行
    }
    self.lastSelected = indexPath;//选中的修改为当前行
    self.ifSelected = YES;//修改这个被选中的一行
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];//重新刷新
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_CELL;
}

- (void)goToSubmit{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSString *regionStr = [NSString stringWithFormat:@"%@", self.regionChooseArray[_lastSelected.row]];
    if (self.myblcok) {
        self.myblcok(regionStr);
    }
    
}


@end
