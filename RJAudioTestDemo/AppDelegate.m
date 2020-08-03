//
//  AppDelegate.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/7/27.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "AppDelegate.h"
#import "RJAudioTestViewController.h"
#import "RJAudioPlayerViewController.h"
#import "RJCMTimeTestViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    RJAudioPlayerViewController *demoVC = [[RJAudioPlayerViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:demoVC];
    navigationController.navigationBar.translucent = NO;
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}





@end
