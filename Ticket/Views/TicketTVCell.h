//
//  TicketTVCell.h
//  Ticket
//
//  Created by Артем Б on 07.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "APIManager.h"
@class TicketFavorite;

@class Ticket;


@interface TicketTVCell : UITableViewCell

@property (nonatomic, strong) Ticket* ticket;
@property (nonatomic, strong) TicketFavorite* favorite;
@property (nonatomic, strong) UIImageView* airlineLogoView;

@end
