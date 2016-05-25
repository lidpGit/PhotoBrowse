//
//  AppDelegate.m
//  PhotoBrowse
//
//  Created by lidp on 16/5/24.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] initWithStyle:UITableViewStylePlain]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
