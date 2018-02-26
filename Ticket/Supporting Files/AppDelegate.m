//
//  AppDelegate.m
//  Ticket
//
//  Created by Артем Б on 01.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "NotificationCenter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame: windowFrame];
    
    TabBarController* tabBarController = [TabBarController new];
    
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    
    [[NotificationCenter sharedInstance] registerService];

    
    return YES;
}




@end
