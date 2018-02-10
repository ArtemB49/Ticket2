//
//  TicketsViewController.m
//  Ticket
//
//  Created by Артем Б on 07.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import "TicketsViewController.h"
#import "TicketTVCell.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface TicketsViewController ()

@property (nonatomic, strong) NSArray* tickets;

@end

@implementation TicketsViewController

- (instancetype)initWithTickets:(NSArray *)tickets{
    self = [super init];
    if (self) {
        self.tickets = tickets;
        self.title = @"Билеты";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTVCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tickets.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TicketTVCell* cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier
                                                       forIndexPath:indexPath];
    cell.ticket = [self.tickets objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140.0;
}

@end
