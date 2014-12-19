//
//  BTFAppDelegate.m
//  BTFLeakDetect
//
//  Created by CocoaPods on 12/19/2014.
//  Copyright (c) 2014 Mikkel Gravgaard. All rights reserved.
//

#import <BTFLeakDetect/BTFLeakDetect.h>
#import "BTFAppDelegate.h"
#import "BTFViewController.h"

@implementation BTFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    UIViewController *vc = [BTFViewController new];
    vc.view.frame = [[UIScreen mainScreen] applicationFrame];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];

    self.window.rootViewController = navigationController;

#if DEBUG
    [BTFLeakDetect enableWithLogging];
#endif

    return YES;
}


@end
