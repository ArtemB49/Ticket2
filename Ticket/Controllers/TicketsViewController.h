//
//  TicketsViewController.h
//  Ticket
//
//  Created by Артем Б on 07.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketsViewController : UITableViewController

- (instancetype)initWithTickets:(NSArray*)tickets;
- (instancetype)initFavoriteTicketsController;

@end
