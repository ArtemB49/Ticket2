//
//  ViewController.m
//  Ticket
//
//  Created by Артем Б on 01.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "MainViewController.h"
#import "DataManager.h"
#import "PlaceViewController.h"
#import "SearchRequestStruct.h"
#import "TicketsViewController.h"
#import "TicketCollectionViewController.h"
#import "ProgressView.h"
#import "FirstViewController.h"
#import "APIManager.h"

@interface MainViewController ()<PlaceViewControllerDelegate>

@property (nonatomic, strong) UIView* placeContainerView;
@property (nonatomic, strong) UIButton* departureButton;
@property (nonatomic, strong) UIButton* arrivalButton;
@property (nonatomic, strong) UIButton* searchButton;
@property (nonatomic) SearchRequest searchRequest;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DataManager sharedInstance] loadData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.prefersLargeTitles = true;
    self.title = @"Поиск";
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.placeContainerView = [[UIView alloc] initWithFrame:CGRectMake(20.0, 140.0, screenWidth - 40.0, 170.0)];
    self.placeContainerView.backgroundColor = [UIColor whiteColor];
    self.placeContainerView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
    self.placeContainerView.layer.shadowOffset = CGSizeZero;
    self.placeContainerView.layer.shadowRadius = 20.0;
    self.placeContainerView.layer.shadowOpacity = 1.0;
    self.placeContainerView.layer.cornerRadius = 6.0;
    
    self.departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.departureButton setTitle:@"Откуда" forState:UIControlStateNormal];
    self.departureButton.tintColor = [UIColor blackColor];
    self.departureButton.frame = CGRectMake(
                                            10.0,
                                            20.0,
                                            self.placeContainerView.frame.size.width - 20.0,
                                            60.0
                                        );
    self.departureButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    self.departureButton.layer.cornerRadius = 4.0;
    [self.departureButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.placeContainerView addSubview:self.departureButton];
    
    self.arrivalButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.arrivalButton setTitle:@"Куда" forState: UIControlStateNormal];
    self.arrivalButton.tintColor = [UIColor blackColor];
    self.arrivalButton.frame = CGRectMake(
                                          10.0,
                                          CGRectGetMaxY(self.departureButton.frame) + 10.0,
                                          self.placeContainerView.frame.size.width - 20.0,
                                          60.0
                                    );
    self.arrivalButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    self.arrivalButton.layer.cornerRadius = 4.0;
    [self.arrivalButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.placeContainerView addSubview:self.arrivalButton];
    
    [self.view addSubview:self.placeContainerView];
    
    self.searchButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.searchButton setTitle:@"Найти" forState: UIControlStateNormal];
    self.searchButton.tintColor = [UIColor whiteColor];
    self.searchButton.frame = CGRectMake(30.0, CGRectGetMaxY(self.placeContainerView.frame) + 30, screenWidth -60.0, 60.0);
    self.searchButton.backgroundColor = [UIColor blackColor];
    self.searchButton.layer.cornerRadius = 8.0;
    self.searchButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    [self.searchButton addTarget:self action:@selector(searchButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.searchButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadSuccessfully) name:kDataManagerLoadDataDidComplete object: nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self presentFirstViewControllerNeeded];
    
    
}

- (void)searchButtonDidTap:(UIButton*)sender{
    if (_searchRequest.origin && _searchRequest.destionation) {
        [[ProgressView sharedInstance] show:^{
            [[APIManager sharedInstance]
             ticketsWithRequest:self.searchRequest withCompletion:^(NSArray *tickets) {
                 [[ProgressView sharedInstance] dismiss:^{
                     if (tickets.count > 0) {
                         TicketsViewController* ticketsVC = [[TicketsViewController alloc] initWithTickets:tickets];
                         
                         [self.navigationController pushViewController:ticketsVC animated:true];
                     } else {
                         UIAlertController* alertController =
                         [UIAlertController alertControllerWithTitle:@"Увы!"
                                                             message:@"По данному направлению билетов не найдено"
                                                      preferredStyle: UIAlertControllerStyleAlert];
                         [alertController addAction:[UIAlertAction actionWithTitle:@"Закрыть"
                                                                             style:UIAlertActionStyleDefault handler:nil]];
                         [self presentViewController:alertController animated:true completion:nil];
                     }
                 }];
             }];
        }];
    } else {
        UIAlertController* alertController =
        [UIAlertController alertControllerWithTitle:@"Ошибка"
                                            message:@"Необходимо указать место отправления и место прибытия"
                                     preferredStyle: UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Закрыть"
                                                            style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:true completion:nil];
    }
}

- (void)dataLoadSuccessfully {
    [[APIManager sharedInstance] cityForCurrentIP:^(City *city) {
        [self setPlace:city withDataType: DataSourceTypeCity andPlaceType:PlaceTypeDeparture forButton:self.departureButton];
    }];
}

- (void)placeButtonDidTap:(UIButton*)sender{
    PlaceViewController* placeViewController;
    if ([sender isEqual: _departureButton]) {
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeDeparture];
    } else {
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeArrival];
    }
    placeViewController.delegate = self;
    [self.navigationController pushViewController: placeViewController animated: true];
}

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType{
    [self setPlace: place withDataType: dataType andPlaceType: placeType forButton: (placeType == PlaceTypeDeparture)? self.departureButton : self.arrivalButton];
}

- (void)setPlace:(id)place withDataType:(DataSourceType)dataType andPlaceType:(PlaceType)placeType forButton:(UIButton*)button{
    NSString* title;
    NSString* iata;
    if (dataType == DataSourceTypeCity) {
        City* city = (City*)place;
        title = city.name;
        iata = city.code;
    } else if (dataType == DataSourceTypeAiport){
        Airport* airport = (Airport*)place;
        title = airport.name;
        iata = airport.cityCode;
    }
    
    if (placeType == PlaceTypeDeparture) {
        _searchRequest.origin = iata;
    } else {
        _searchRequest.destionation = iata;
    }
    [button setTitle:title forState:UIControlStateNormal];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)loadDataComplete{
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)presentFirstViewControllerNeeded {
    BOOL isFirstStart = [[NSUserDefaults standardUserDefaults] boolForKey:@"first_start"];
    if (!isFirstStart) {
        FirstViewController* firstVC = [[FirstViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                    options:nil];
        [self presentViewController: firstVC animated: true completion: nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
