//
//  TicketCollectionViewCell.h
//  Ticket
//
//  Created by Артем Б on 12.02.2018.
//  Copyright © 2018 Артем Б. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "APIManager.h"
@class Ticket;

@interface TicketCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) Ticket* ticket;

@end
