//
//  AppDelegate.m
//  Ticket
//
//  Created by Артем Б on 01.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "AppDelegate.h"
#import "RootNavigatorController.h"
#import "MainViewController.h"
#import "MapViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate{
    RootNavigatorController* rootNavigator;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame: windowFrame];
    
    MapViewController* mapVC = [MapViewController new];
    
//    MainViewController* mainVC = [MainViewController new];
    
    rootNavigator = [[RootNavigatorController alloc] initWithRootViewController:mapVC];
    
    
    
    self.window.rootViewController = rootNavigator;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}




@end
