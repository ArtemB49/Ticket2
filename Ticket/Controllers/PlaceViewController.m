//
//  PlaceViewController.m
//  Ticket
//
//  Created by Артем Б on 01.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "PlaceViewController.h"
#import "DataManager.h"
#import "PlaceTVCell.h"

@interface PlaceViewController ()

@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UISegmentedControl* segmentedControl;
@property (nonatomic, strong) NSArray* currentArray;

@end

@implementation PlaceViewController

- (instancetype)initWithType:(PlaceType)type{
    self = [super init];
    if (self) {
        self.placeType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems: @[@"Города", @"Аэропорты"]];
    [self.segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = self.segmentedControl;
    self.segmentedControl.selectedSegmentIndex = 0;
    [self changeSource];
    
    if (self.placeType == PlaceTypeDeparture) {
        self.title = @"Откуда";
    } else {
        self.title = @"Куда";
    }
}

- (void)changeSource {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.currentArray = [[DataManager sharedInstance] cities];
            break;
        case 1:
            self.currentArray = [[DataManager sharedInstance] airports];
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.currentArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlaceTVCell* cell = [tableView dequeueReusableCellWithIdentifier: NSLocaleIdentifier];
    if (!cell) {
        cell = [[PlaceTVCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: NSLocaleIdentifier];
        
    }

    if (self.segmentedControl.selectedSegmentIndex == 0) {
        City* city = [self.currentArray objectAtIndex: indexPath.row];
        cell.leftLabel.text = city.name;
        cell.rightLabel.text = city.code;
    } else if (self.segmentedControl.selectedSegmentIndex == 1){
        Airport* airport = [self.currentArray objectAtIndex: indexPath.row];
        cell.leftLabel.text = airport.name;
        cell.rightLabel.text = airport.code;
    }
    
    return cell;
    
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DataSourceType dataType = ((int) self.segmentedControl.selectedSegmentIndex) + 1;
    [self.delegate selectPlace:[self.currentArray objectAtIndex: indexPath.row] withType:self.placeType andDataType:dataType];
    [self.navigationController popViewControllerAnimated:true];
}



@end
