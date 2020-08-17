//
//  AppDelegate.m
//  SixDigitalInputTest
//
//  Created by 宋朝阳 on 2020/8/16.
//  Copyright © 2020 宋朝阳. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    self.window.rootViewController = [[ViewController alloc] init];;
    
    [self.window makeKeyAndVisible];
    return YES;
}


@end
