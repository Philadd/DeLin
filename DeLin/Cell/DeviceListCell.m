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
        //设置cell的样式
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        self.layer.shadowColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.35].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,2.5);
        self.layer.shadowRadius = 10;
        self.layer.shadowOpacity = 1;
        if (!_deviceImage) {
            _deviceImage = [[UIImageView alloc] init];
            [self.contentView addSubview:_deviceImage];
            [_deviceImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(100.f), yAutoFit(50.f)));
                make.left.equalTo(self.contentView.mas_left).offset(yAutoFit(50.f));
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
        }
        if (!_deviceListLabel) {
            _deviceListLabel = [[UILabel alloc] init];
            _deviceListLabel.font = [UIFont systemFontOfSize:16.f];
            _deviceListLabel.backgroundColor = [UIColor clearColor];
            _deviceListLabel.textColor = [UIColor blackColor];
            _deviceListLabel.adjustsFontSizeToFitWidth = YES;
            _deviceListLabel.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_deviceListLabel];
            [_deviceListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(200), yAutoFit(30)));
                make.left.equalTo(self.deviceImage.mas_right).offset(yAutoFit(50));
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
        }
    }
    return self;
}

@end
