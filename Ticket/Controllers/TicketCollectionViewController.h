//
//  TicketCollectionViewController.h
//  Ticket
//
//  Created by Артем Б on 12.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketCollectionViewController : UICollectionViewController

- (instancetype)initWithTickets:(NSArray*)tickets andCollectionViewLayout:(UICollectionViewFlowLayout*)flowLayout;

@end
