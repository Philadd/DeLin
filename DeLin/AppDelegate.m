//
//  AppDelegate.m
//  DeLin
//
//  Created by 安建伟 on 2019/10/22.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>
#import <GizWifiSDK/GizWifiSDK.h>
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //错误日志上报
    [Bugly startWithAppId:@"d01e9040cb"];
    
    [self customizeInterface];
    [self initGiz];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    //loginVC.isAutoLogin = YES;
    _navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = _navController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)initGiz{
    //NSDictionary *parameters =@{@"appId":GizAppId,@"appSecret": GizAppSecret};
    //[GizWifiSDK startWithAppInfo:parameters productInfo:nil cloudServiceInfo: nil autoSetDeviceDomain:YES];
}

- (void)customizeInterface {
    _navigationBarAppearance = [UINavigationBar appearance];
    //navigationBarAppearance.barTintColor = [UIColor clearColor];
    _navigationBarAppearance.translucent = YES;
    
    //设置导航栏背景图片为一个空的image，这样就透明了
    [_navigationBarAppearance setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [_navigationBarAppearance setShadowImage:[[UIImage alloc] init]];
    
}

@end
