//
//  TabBarController.m
//  Ticket
//
//  Created by Артем Б on 11.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "TabBarController.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "TicketCollectionViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.viewControllers = [self createViewController];
        self.tabBar.tintColor = [UIColor blackColor];
    }
    return self;
}

- (NSArray<UIViewController*>*)createViewController {
    NSMutableArray<UIViewController*>* controllers = [NSMutableArray new];
    
    MainViewController* mainViewController = [MainViewController new];
    mainViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Поиск"
                                                                  image: [UIImage imageNamed: @"search"]
                                                          selectedImage: [UIImage imageNamed: @"search_selected"]];
    UINavigationController* mainNacController = [[UINavigationController alloc]
                                                 initWithRootViewController:mainViewController];
    [controllers addObject: mainNacController];
    
    MapViewController* mapVC = [MapViewController new];
    mapVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Карта цен" image:[UIImage imageNamed:@"map"] selectedImage:[UIImage imageNamed:@"map_selected"]];
    UINavigationController* mapNavController = [[UINavigationController alloc] initWithRootViewController: mapVC];
    [controllers addObject: mapNavController];
    

    
    return controllers;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
