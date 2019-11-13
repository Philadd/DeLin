//
//  LandroidListCell.m
//  MOWOX
//
//  Created by 杭州轨物科技有限公司 on 2018/12/19.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "DeviceListCell.h"

@implementation DeviceListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        if (!_deviceListLabel) {
            _deviceListLabel = [[UILabel alloc] init];
            _deviceListLabel.font = [UIFont systemFontOfSize:14.f];
            [_deviceListLabel setBackgroundColor:[UIColor colorWithRed:108/255.0 green:113/255.0 blue:118/255.0 alpha:1.f]];
            _deviceListLabel.textColor = [UIColor blackColor];
            _deviceListLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:_deviceListLabel];
            [_deviceListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(280), yAutoFit(40)));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.centerX.equalTo(self.contentView.mas_centerX);
            }];
            _deviceListLabel.layer.cornerRadius = 10.f;
            _deviceListLabel.layer.masksToBounds = YES;
        }
    }
    return self;
}

@end
