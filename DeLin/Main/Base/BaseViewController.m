//
//  BaseViewController.m
//  steamRoom
//
//  Created by 安建伟 on 2019/7/1.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *delegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    
    delegate.navigationBarAppearance.translucent = NO;
    /** 设置导航栏背景图片 */
    [delegate.navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"background_navItem"] forBarMetrics:UIBarMetricsDefault];
    
    [delegate.navigationBarAppearance setTintColor:[UIColor whiteColor]];//返回按钮的箭头颜色
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: [UIFont systemFontOfSize:17.f],
                                     NSForegroundColorAttributeName: [UIColor whiteColor],
                                     };
    [delegate.navigationBarAppearance setTitleTextAttributes:textAttributes];
    
}

@end
