//
//  RegionViewController.h
//  DeLin
//
//  Created by 安建伟 on 2019/11/29.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^myblcok)(NSString *);

@interface RegionViewController : UIViewController

@property (nonatomic) myblcok myblcok;
@property (strong, nonatomic) NSString *addressStr;

@end

NS_ASSUME_NONNULL_END
